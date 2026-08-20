import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_environment.dart';
import '../errors/app_exceptions.dart';

const _tag = 'ERP';
const _tokenKey = 'agrotareo_erp_token';
const _tokenExpiryKey = 'agrotareo_erp_token_expiry';

/// Cliente HTTP hacia el proxy REST del ERP (WSRESTMovilidadERP / agkwebagro).
///
/// Replica el patron probado en produccion para este mismo backend:
/// - Login: POST /login/authenticate con `username`/`password` en headers.
/// - SP:    POST /EjecutarSPERP con Bearer token y `NombreSP` + `Parametros`.
/// - Refresh silencioso ante 401 y cache del token con TTL de 8h.
class ErpApiClient {
  ErpApiClient({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _dio = _buildDio();

  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  static Dio _buildDio() {
    final dio = Dio(BaseOptions(
      baseUrl: AppEnvironment.erpBaseUrl,
      connectTimeout: AppEnvironment.connectTimeout,
      receiveTimeout: AppEnvironment.receiveTimeout,
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    return dio;
  }

  /// Aplica el cambio Productivo/Pruebas al cliente ya construido.
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  Future<void> _clearToken() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _tokenExpiryKey);
  }

  Future<void> logout() => _clearToken();

  Future<bool> get hasCachedSession async =>
      (await _secureStorage.read(key: _tokenKey)) != null;

  /// Autentica contra el ERP y guarda el token. Devuelve el JWT.
  Future<String> authenticate(String username, String password) async {
    try {
      final response = await _dio.post<dynamic>(
        AppEnvironment.authEndpoint,
        options: Options(headers: {
          'username': username,
          'password': password,
        }),
      );
      final token = _extractToken(response.data);
      await _saveToken(token);
      return token;
    } on DioException catch (e) {
      developer.log('auth error: ${e.response?.statusCode} ${e.response?.data}', name: '$_tag/AUTH');
      throw _mapDioException(e);
    }
  }

  Future<String> getValidToken() async {
    final stored = await _secureStorage.read(key: _tokenKey);
    final expiryStr = await _secureStorage.read(key: _tokenExpiryKey);
    if (stored != null && expiryStr != null) {
      final expiry = DateTime.tryParse(expiryStr);
      if (expiry != null && DateTime.now().isBefore(expiry)) {
        return stored;
      }
    }
    throw const AuthException('Sesion expirada. Vuelve a iniciar sesion.');
  }

  /// Ejecuta un SP en el proxy y devuelve la respuesta cruda ya decodificada
  /// (puede ser List, Map con Table/Table1/..., etc). Usa [asRows] o
  /// [asTables] para normalizarla segun el SP.
  ///
  /// Loguea SIEMPRE (visible en la terminal de `flutter run` / `adb logcat`)
  /// el payload enviado y la forma cruda de la respuesta -- antes de
  /// cualquier parseo -- para poder diagnosticar si el proxy realmente
  /// devuelve varios result sets o si el SP se corta a mitad de camino
  /// (por ejemplo por permisos en tablas de otra base de datos).
  Future<dynamic> ejecutarSPRaw({
    required String nombreSP,
    required List<Map<String, Object?>> parametros,
    String? bearerTokenOverride,
  }) async {
    final token = bearerTokenOverride ?? await getValidToken();
    final payload = {
      'NombreSP': nombreSP,
      'TipoRespuesta': 0,
      'EntidadMapa': '',
      'Parametros': parametros,
    };

    _logRequest(nombreSP, payload);

    Future<Response<dynamic>> call(String bearer) => _dio.post<dynamic>(
          AppEnvironment.spEndpoint,
          data: payload,
          options: Options(headers: {'Authorization': 'Bearer $bearer'}),
        );

    try {
      final response = await call(token);
      _logRawResponse(nombreSP, response.statusCode, response.data);
      return response.data;
    } on DioException catch (e) {
      _logError(nombreSP, e);
      if (e.response?.statusCode == 401) {
        // El token quedo invalido en el servidor (expiro o fue revocado).
        // No guardamos la contrasena en el dispositivo, asi que no podemos
        // reautenticar en silencio: se limpia la sesion y se propaga el
        // error para que la UI redirija al login.
        await _clearToken();
        throw const AuthException('Sesion expirada. Vuelve a iniciar sesion.');
      }
      throw _mapDioException(e);
    }
  }

  void _logRequest(String nombreSP, Map<String, Object?> payload) {
    final resumenParams = payload['Parametros'] as List;
    final resumen = resumenParams
        .map((p) => '${(p as Map)['NombreParametro']}=${p['Valor']}')
        .join(', ');
    debugPrint('[$_tag/SP] >>> $nombreSP  |  ${AppEnvironment.erpBaseUrl}${AppEnvironment.spEndpoint}');
    debugPrint('[$_tag/SP] >>> parametros: $resumen');
  }

  void _logRawResponse(String nombreSP, int? statusCode, dynamic data) {
    debugPrint('[$_tag/SP] <<< $nombreSP  HTTP $statusCode  tipo=${data.runtimeType}');

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      debugPrint('[$_tag/SP] <<< $nombreSP  keys de nivel superior: ${map.keys.toList()}');
      final numberedKeys = map.keys.where((k) => RegExp(r'^Table\d*$').hasMatch(k)).toList();
      final listEntries = map.entries.where((e) => e.value is List).toList();
      final tableEntries = numberedKeys.isNotEmpty
          ? numberedKeys.map((k) => MapEntry(k, map[k])).toList()
          : listEntries;

      if (tableEntries.length <= 1 && numberedKeys.isEmpty) {
        debugPrint(
          '[$_tag/SP] <<< $nombreSP  *** solo hay ${tableEntries.length} clave con lista de nivel '
          'superior -- respuesta de una sola fila/tabla (esperado para SPs de un solo SELECT). ***',
        );
      } else {
        debugPrint(
          '[$_tag/SP] <<< $nombreSP  ${tableEntries.length} tabla(s) detectada(s) '
          '(formato ${numberedKeys.isNotEmpty ? 'Table/Table1/...' : 'nombre de tabla SQL'}): '
          '${tableEntries.map((e) => e.key).toList()}',
        );
        for (final entry in tableEntries) {
          final value = entry.value;
          final count = value is List ? value.length : -1;
          final firstKeys = (value is List && value.isNotEmpty && value.first is Map)
              ? (value.first as Map).keys.toList()
              : null;
          debugPrint(
            '[$_tag/SP] <<<   ${entry.key} -> $count fila(s)${firstKeys != null ? ' | columnas: $firstKeys' : ''}',
          );
        }
      }
    } else if (data is List) {
      debugPrint(
        '[$_tag/SP] <<< $nombreSP  respuesta es una LISTA con ${data.length} elemento(s) '
        '(un solo result set aplanado, o lista-de-listas si el primer elemento tambien es List).',
      );
    }

    _dumpRaw(nombreSP, data);
  }

  void _logError(String nombreSP, DioException e) {
    debugPrint(
      '[$_tag/SP] !!! $nombreSP  ERROR HTTP ${e.response?.statusCode} (${e.type}): ${e.message}',
    );
    if (e.response?.data != null) {
      debugPrint('[$_tag/SP] !!! $nombreSP  cuerpo del error: ${e.response!.data}');
    }
  }

  void _dumpRaw(String nombreSP, dynamic data) {
    try {
      final raw = data is String ? data : jsonEncode(data);
      const maxLen = 4000;
      if (raw.length <= maxLen) {
        debugPrint('[$_tag/SP] <<< $nombreSP  JSON crudo: $raw');
      } else {
        debugPrint(
          '[$_tag/SP] <<< $nombreSP  JSON crudo (primeros $maxLen de ${raw.length} chars): '
          '${raw.substring(0, maxLen)}...[truncado]',
        );
      }
    } catch (_) {
      debugPrint('[$_tag/SP] <<< $nombreSP  (no se pudo serializar la respuesta para el log)');
    }
  }

  /// Helper para construir un parametro de SP. Duplica las claves
  /// (Nombre/NombreParametro/Valor/ValorParametro) porque es el formato
  /// verificado contra este mismo proxy (WSRESTMovilidadERP) en produccion.
  static Map<String, Object?> parametro(String nombre, Object? valor) {
    final valorStr = valor?.toString();
    return {
      'Nombre': nombre,
      'NombreParametro': nombre,
      'Valor': valorStr,
      'ValorParametro': valorStr,
    };
  }

  /// Normaliza cualquier respuesta a una lista plana de filas.
  static List<Map<String, dynamic>> asRows(dynamic data) {
    if (data is List) {
      return data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final jr = map['JsonResult'] ?? map['jsonResult'];
      if (jr is String && jr.isNotEmpty) {
        try {
          return asRows(jsonDecode(jr));
        } catch (_) {}
      }
      for (final value in map.values) {
        if (value is List && value.isNotEmpty && value.first is Map) {
          return value.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
        }
      }
      return [map];
    }
    if (data is String && data.isNotEmpty) {
      try {
        return asRows(jsonDecode(data));
      } catch (_) {}
    }
    return [];
  }

  /// Normaliza una respuesta multi-resultset (SPs con varios SELECT, como
  /// CLI547_AGM_MOBILE_MASTER_SYNC) a una lista ordenada de tablas.
  ///
  /// El proxy WSRESTMovilidadERP NO usa el formato clasico `Table`/`Table1`/
  /// `Table2`... -- envuelve cada result set bajo una clave con el NOMBRE
  /// REAL de la tabla SQL de origen (ej. `Tareo_activity`, `Cultivos`), en
  /// el mismo orden que los SELECT del SP. `jsonDecode` preserva el orden
  /// de insercion del JSON, asi que ese orden es confiable.
  static List<List<Map<String, dynamic>>> asTables(dynamic data) {
    if (data is List) {
      if (data.isNotEmpty && data.first is List) {
        return data
            .whereType<List>()
            .map((table) => table.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList())
            .toList();
      }
      return [asRows(data)];
    }
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);

      // Formato clasico: Table, Table1, Table2, ...
      final tableKeys = map.keys.where((k) => RegExp(r'^Table\d*$').hasMatch(k)).toList()
        ..sort((a, b) {
          final na = int.tryParse(a.replaceFirst('Table', '')) ?? 0;
          final nb = int.tryParse(b.replaceFirst('Table', '')) ?? 0;
          return na.compareTo(nb);
        });
      if (tableKeys.isNotEmpty) {
        return tableKeys.map((key) => _asTableRows(map[key])).toList();
      }

      // Formato real de este proxy: una clave por nombre de tabla SQL, cada
      // una con su lista de filas. Si hay 2 o mas claves con valor lista,
      // se toman TODAS en orden de aparicion como result sets separados.
      final listEntries = map.entries.where((e) => e.value is List).toList();
      if (listEntries.length > 1) {
        return listEntries.map((e) => _asTableRows(e.value)).toList();
      }

      return [asRows(map)];
    }
    if (data is String && data.isNotEmpty) {
      try {
        return asTables(jsonDecode(data));
      } catch (_) {}
    }
    return [];
  }

  static List<Map<String, dynamic>> _asTableRows(dynamic value) {
    if (value is List) {
      return value.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return <Map<String, dynamic>>[];
  }

  String _extractToken(dynamic data) {
    if (data is String && data.isNotEmpty) {
      return data.replaceAll('"', '').trim();
    }
    if (data is Map) {
      final v = data['token'] ?? data['Token'] ?? data['access_token'];
      if (v != null) return v.toString().trim();
    }
    throw const ServerException('Formato de token inesperado del servidor.');
  }

  Future<void> _saveToken(String token) async {
    final expiry = DateTime.now().add(AppEnvironment.tokenTtl).toIso8601String();
    await _secureStorage.write(key: _tokenKey, value: token);
    await _secureStorage.write(key: _tokenExpiryKey, value: expiry);
  }

  AppException _mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const TimeoutExceptionApp();
    }
    final code = e.response?.statusCode ?? 0;
    if (code == 401 || code == 403) {
      return const AuthException();
    }
    final msg = e.response?.data?.toString() ?? e.message ?? 'Error de comunicacion con el servidor.';
    return ServerException(msg, statusCode: code);
  }
}
