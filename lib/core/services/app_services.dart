import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../data/models/employee.dart';
import '../../data/repositories/audit_repository.dart';
import '../../data/repositories/backup_repository.dart';
import '../../data/repositories/master_data_repository.dart';
import '../../data/repositories/outbox_repository.dart';
import '../../data/repositories/tareo_repository.dart';
import '../config/app_environment.dart';
import '../errors/app_exceptions.dart';
import '../network/erp_api_client.dart';
import '../sp/stored_procedure_contract.dart';
import '../storage/session_storage.dart';

/// Orquesta login/logout, el cambio de entorno y el arranque de la app.
/// Unico punto de acceso al [ErpApiClient] compartido por toda la UI.
class AppServices extends ChangeNotifier {
  AppServices._();

  static final instance = AppServices._();

  final ErpApiClient api = ErpApiClient();

  SessionUser? currentUser;
  bool isBootstrapping = true;

  bool get isLoggedIn => currentUser != null;

  Future<void> bootstrap() async {
    await initializeDateFormatting('es');
    await AppEnvironment.restore();
    api.updateBaseUrl(AppEnvironment.erpBaseUrl);

    await Future.wait([
      MasterDataRepository.instance.loadCached(),
      OutboxRepository.instance.load(),
      AuditRepository.instance.load(),
      BackupRepository.instance.load(),
      TareoRepository.instance.load(),
    ]);

    final hasSession = await api.hasCachedSession;
    if (hasSession) {
      currentUser = await SessionStorage.getUser();
      if (currentUser == null) {
        await api.logout();
      } else {
        try {
          await api.getValidToken();
        } on AppException {
          currentUser = null;
          await SessionStorage.clear();
        }
      }
    }

    isBootstrapping = false;
    notifyListeners();
  }

  Future<void> setEnvironment(AppEnv env) async {
    if (env == AppEnvironment.current) return;
    await AppEnvironment.setEnv(env);
    api.updateBaseUrl(AppEnvironment.erpBaseUrl);
    notifyListeners();
  }

  /// Login real: autentica contra el ERP, resuelve el contexto del usuario
  /// (sede/fundo/perfil) via `CLI547_AGMSP_AGK_GetUserContext` y sincroniza
  /// -en una sola llamada- los catalogos maestros y los sublotes de esa
  /// sede (`CLI547_AGM_MOBILE_MASTER_SYNC(@IdSede, @SinceVersion)`).
  Future<void> login(String username, String password) async {
    await api.authenticate(username.trim(), password);

    final context = await _fetchUserContext(username.trim());

    await MasterDataRepository.instance.sync(api: api, idSede: context?.idSede);

    // Respaldo si el contexto no vino (SP no disponible, error de red puntual,
    // etc.): se intenta resolver el perfil buscando el `Codigo` dentro del
    // catalogo de Accounts_userprofile ya sincronizado.
    final fallbackProfile =
        context == null ? MasterDataRepository.instance.profileForUsername(username.trim()) : null;
    final fallbackEmployee = MasterDataRepository.instance.employeeById(fallbackProfile?.employeeId);

    final user = SessionUser(
      username: username.trim(),
      userProfileId: context?.userProfileId ?? fallbackProfile?.id,
      employeeId: context?.employeeId ?? fallbackProfile?.employeeId,
      personId: fallbackProfile?.personId,
      nombre: context?.nombreCompleto ?? fallbackEmployee?.displayName,
      groupId: fallbackProfile?.groupId,
      dni: context?.dni,
      puestoTrabajo: context?.puestoTrabajo,
      sede: context?.sede,
      idSede: context?.idSede,
      centroAgrotareo: context?.centroAgrotareo,
      fundo: context?.fundo,
      idFundo: context?.idFundo,
      estado: context?.estado,
    );

    currentUser = user;
    await SessionStorage.saveUser(user);
    notifyListeners();
  }

  Future<UserContext?> _fetchUserContext(String username) async {
    try {
      final raw = await api.ejecutarSPRaw(
        nombreSP: StoredProcedureContract.getUserContext,
        parametros: StoredProcedureContract.userContextParams(username),
      );
      final rows = ErpApiClient.asRows(raw);
      if (rows.isEmpty) return null;
      return UserContext.fromRow(rows.first);
    } catch (e) {
      developer.log('GetUserContext fallo, se usa el respaldo del catalogo: $e', name: 'Auth');
      return null;
    }
  }

  Future<void> logout() async {
    await api.logout();
    await SessionStorage.clear();
    currentUser = null;
    notifyListeners();
  }

  /// Botón "Sincronizar" (Inicio / Perfil / Mapa). Reutiliza la sede
  /// resuelta en el login; no requiere que el usuario ingrese nada. Trae de
  /// nuevo TODOS los catalogos + los sublotes de la sede en una sola
  /// llamada al SP.
  Future<void> syncMasterCatalogs() async {
    await MasterDataRepository.instance.sync(api: api, idSede: currentUser?.idSede);
  }
}
