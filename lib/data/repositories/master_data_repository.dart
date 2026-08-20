import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/erp_api_client.dart';
import '../../core/sp/stored_procedure_contract.dart';
import '../models/catalog_diagnostic.dart';
import '../models/employee.dart';
import '../models/field_lot.dart';

/// Cache local + sincronizacion de catalogos maestros contra
/// `CLI547_AGM_MOBILE_MASTER_SYNC(@IdSede, @SinceVersion)` (sp_agrotareo.sql).
///
/// El SP devuelve 14 result sets sin nombre explicito, siempre en el mismo
/// orden (el de sus SELECT), mas uno extra (sublotes/mapa) cuando @IdSede
/// no es NULL. Se clasifican por POSICION porque ese orden es fijo; el
/// sublote se busca ademas por firma de columnas ya que es el unico
/// condicional.
class MasterDataRepository extends ChangeNotifier {
  MasterDataRepository._();

  static final instance = MasterDataRepository._();

  static const _prefsKey = 'agrotareo_master_cache_v3';

  List<ActivityCatalog> activities = [];
  List<ProductivityTypeCatalog> productivityTypes = [];
  List<ProductCatalog> products = [];
  List<Employee> employees = [];
  List<LocationCatalog> locations = [];
  List<LocationTypeCatalog> locationTypes = [];
  List<CropCatalog> crops = [];
  List<GroupCatalog> groups = [];
  List<SubgroupCatalog> subgroups = [];
  List<VarietyCatalog> varieties = [];
  List<BusinessUnitCatalog> businessUnits = [];
  List<TaskOrderCatalog> taskOrders = [];
  List<UserProfileRow> userProfiles = [];
  List<FieldLot> lots = [];

  List<CatalogDiagnostic> diagnostics = [];
  int rawTableCount = 0;

  DateTime? lastSyncAt;
  bool isSyncing = false;
  String? lastError;

  bool get hasData => activities.isNotEmpty || employees.isNotEmpty || locations.isNotEmpty;

  Future<void> loadCached() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      activities = _decodeList(json['activities'], ActivityCatalog.fromRow);
      employees = _decodeList(json['employees'], Employee.fromRow);
      locations = _decodeList(json['locations'], LocationCatalog.fromRow);
      crops = _decodeList(json['crops'], CropCatalog.fromRow);
      groups = _decodeList(json['groups'], GroupCatalog.fromRow);
      userProfiles = _decodeList(json['userProfiles'], UserProfileRow.fromRow);
      lots = normalizeLots(_decodeList(json['lots'], FieldLot.fromRow));
      diagnostics = (json['diagnostics'] as List<dynamic>? ?? [])
          .map((e) => CatalogDiagnostic.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      rawTableCount = json['rawTableCount'] as int? ?? 0;
      final ts = json['lastSyncAt'] as String?;
      lastSyncAt = ts == null ? null : DateTime.tryParse(ts);
      notifyListeners();
    } catch (_) {
      // Cache corrupta o de una version anterior: se ignora, se resincroniza.
    }
  }

  /// Sincroniza el maestro completo para la sede del usuario. Si [idSede]
  /// viene, el SP tambien devuelve -en la misma llamada- los sublotes de
  /// TODOS los cultivos de esa sede.
  Future<void> sync({
    required ErpApiClient api,
    int? idSede,
    int? sinceVersion,
  }) async {
    isSyncing = true;
    lastError = null;
    notifyListeners();
    try {
      final raw = await api.ejecutarSPRaw(
        nombreSP: StoredProcedureContract.masterSync,
        parametros: StoredProcedureContract.masterSyncParams(
          idSede: idSede,
          sinceVersion: sinceVersion,
        ),
      );
      final tables = ErpApiClient.asTables(raw);
      rawTableCount = tables.length;
      final expectedTables = idSede != null ? 15 : 14;

      debugPrint(
        '[MasterSync] $rawTableCount tabla(s) recibidas (se esperaban $expectedTables) '
        '| filas por tabla: ${tables.map((t) => t.length).toList()}',
      );
      developer.log(
        'master sync -> ${tables.length} tablas | filas por tabla: '
        '${tables.map((t) => t.length).toList()}',
        name: 'MasterSync',
      );

      if (rawTableCount < expectedTables) {
        debugPrint(
          '[MasterSync] *** Llegaron $rawTableCount de $expectedTables tablas esperadas. '
          'Revisa el detalle "[ERP/SP] <<<" de arriba: si el proxy devolvio menos claves de las '
          'que tiene el SP, puede ser que alguno de los SELECT fallo en el servidor (permisos '
          'cruzados entre bases de datos, timeout, etc.) o que el nombre de alguna tabla cambio '
          'y MasterDataRepository.sync() ya no la encuentra en la posicion esperada. ***',
        );
      }

      List<Map<String, dynamic>> at(int i) => i < tables.length ? tables[i] : const [];

      activities = at(0).map(ActivityCatalog.fromRow).toList();
      productivityTypes = at(1).map(ProductivityTypeCatalog.fromRow).toList();
      products = at(2).map(ProductCatalog.fromRow).toList();
      final productivityRelationCount = at(3).length;
      locations = at(4).map(LocationCatalog.fromRow).toList();
      locationTypes = at(5).map(LocationTypeCatalog.fromRow).toList();
      employees = at(6).map(Employee.fromRow).toList();
      userProfiles = at(7).map(UserProfileRow.fromRow).toList();
      groups = at(8).map(GroupCatalog.fromRow).toList();
      subgroups = at(9).map(SubgroupCatalog.fromRow).toList();
      varieties = at(10).map(VarietyCatalog.fromRow).toList();
      crops = at(11).map(CropCatalog.fromRow).toList();
      businessUnits = at(12).map(BusinessUnitCatalog.fromRow).toList();
      taskOrders = at(13).map(TaskOrderCatalog.fromRow).toList();

      // El sublote solo viene si se envio @IdSede; se busca por firma de
      // columnas (no por indice fijo) porque es el unico resultset
      // condicional del SP.
      final sublotesTable = tables.where(
        (t) => t.isNotEmpty && (t.first.containsKey('GeometriaWKT') || t.first.containsKey('Id_Sublote')),
      );
      if (sublotesTable.isNotEmpty) {
        lots = normalizeLots(sublotesTable.first.map(FieldLot.fromRow).toList());
      } else if (idSede != null) {
        // Se pidio con sede pero no vino tabla de sublotes: puede que la
        // sede no tenga sublotes o que el proxy no haya devuelto ese
        // resultset. Se deja visible en 0 en vez de mantener datos viejos.
        lots = [];
      }

      lastSyncAt = DateTime.now();

      diagnostics = [
        CatalogDiagnostic(label: 'Actividades', count: activities.length),
        CatalogDiagnostic(label: 'Tipos de productividad', count: productivityTypes.length),
        CatalogDiagnostic(label: 'Productos', count: products.length),
        CatalogDiagnostic(label: 'Relacion tipo-producto', count: productivityRelationCount),
        CatalogDiagnostic(label: 'Ubicaciones', count: locations.length),
        CatalogDiagnostic(label: 'Tipos de ubicacion', count: locationTypes.length),
        CatalogDiagnostic(label: 'Empleados', count: employees.length),
        CatalogDiagnostic(label: 'Perfiles de usuario', count: userProfiles.length),
        CatalogDiagnostic(label: 'Grupos', count: groups.length),
        CatalogDiagnostic(label: 'Subgrupos', count: subgroups.length),
        CatalogDiagnostic(label: 'Variedades', count: varieties.length),
        CatalogDiagnostic(label: 'Cultivos', count: crops.length),
        CatalogDiagnostic(label: 'Unidades de negocio', count: businessUnits.length),
        CatalogDiagnostic(label: 'Ordenes de trabajo', count: taskOrders.length),
        CatalogDiagnostic(label: 'Sublotes (mapa)', count: lots.length),
      ];

      await _persist();
    } catch (e) {
      lastError = e.toString();
      rethrow;
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  /// Busca el perfil de usuario sincronizado que corresponde al `Codigo`
  /// ingresado en el login (Accounts_userprofile.code). Solo se usa como
  /// respaldo si `CLI547_AGMSP_AGK_GetUserContext` no pudo resolver el
  /// perfil (por ejemplo, sin conexion al SP nuevo).
  UserProfileRow? profileForUsername(String username) {
    final target = username.trim().toLowerCase();
    for (final profile in userProfiles) {
      if (profile.codigo.trim().toLowerCase() == target) return profile;
    }
    return null;
  }

  Employee? employeeById(int? id) {
    if (id == null) return null;
    for (final e in employees) {
      if (e.id == id) return e;
    }
    return null;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode({
      'activities': activities.map((a) => a.toRow()).toList(),
      'employees': employees.map((e) => e.toRow()).toList(),
      'locations': locations.map((l) => l.toRow()).toList(),
      'crops': crops.map((c) => c.toRow()).toList(),
      'groups': groups.map((g) => g.toRow()).toList(),
      'userProfiles': userProfiles.map((u) => u.toRow()).toList(),
      'lots': lots.map((l) => l.toRow()).toList(),
      'diagnostics': diagnostics.map((d) => d.toJson()).toList(),
      'rawTableCount': rawTableCount,
      'lastSyncAt': lastSyncAt?.toIso8601String(),
    });
    await prefs.setString(_prefsKey, json);
  }

  List<T> _decodeList<T>(dynamic raw, T Function(Map<String, dynamic>) fromRow) {
    if (raw is! List) return [];
    return raw.whereType<Map>().map((e) => fromRow(Map<String, dynamic>.from(e))).toList();
  }
}
