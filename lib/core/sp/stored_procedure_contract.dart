import 'dart:convert';

import '../network/erp_api_client.dart';

/// Contrato de los Stored Procedures reales de AgroTareo, definidos en
/// `sp_agrotareo.sql`. Toda la app pasa por estos dos SPs (mas el login).
class StoredProcedureContract {
  StoredProcedureContract._();

  static const masterSync = 'CLI547_AGM_MOBILE_MASTER_SYNC';
  static const syncInsert = 'CLI547_AGM_MOBILE_SYNC_INSERT';
  static const getUserContext = 'CLI547_AGMSP_AGK_GetUserContext';

  static List<Map<String, Object?>> userContextParams(String usuarioCodigo) {
    return [ErpApiClient.parametro('@UsuarioCodigo', usuarioCodigo)];
  }

  /// `CLI547_AGM_MOBILE_MASTER_SYNC(@IdSede, @SinceVersion)`. Con `@IdSede`
  /// el SP ya devuelve los sublotes/mapa de TODOS los cultivos de esa sede
  /// en la misma llamada (ya no hace falta pedirlos cultivo por cultivo).
  static List<Map<String, Object?>> masterSyncParams({
    int? idSede,
    int? sinceVersion,
  }) {
    return [
      ErpApiClient.parametro('@IdSede', idSede),
      ErpApiClient.parametro('@SinceVersion', sinceVersion),
    ];
  }

  static List<Map<String, Object?>> syncInsertParams({
    List<Map<String, Object?>> tickages = const [],
    List<Map<String, Object?>> productivityLogs = const [],
    List<Map<String, Object?>> locations = const [],
    List<Map<String, Object?>> activities = const [],
  }) {
    final json = jsonEncode({
      if (locations.isNotEmpty) 'locations': locations,
      if (activities.isNotEmpty) 'activities': activities,
      'tickages': tickages,
      if (productivityLogs.isNotEmpty) 'productivity_logs': productivityLogs,
    });
    return [ErpApiClient.parametro('@JsonData', json)];
  }
}
