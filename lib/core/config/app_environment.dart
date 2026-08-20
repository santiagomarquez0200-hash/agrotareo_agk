import 'package:shared_preferences/shared_preferences.dart';

/// Entornos del backend ERP (proxy REST Agrokasa — WSRESTMovilidadERP).
///
/// El toggle Productivo/Pruebas cambia la [erpBaseUrl] en caliente y se
/// persiste en SharedPreferences para sobrevivir reinicios de la app.
enum AppEnv { produccion, pruebas }

class AppEnvironment {
  AppEnvironment._();

  static const String urlProduccion =
      'https://agkwebagro.agrokasa.pe/WSRESTMovilidadERP/api';
  static const String urlPruebas =
      'https://agkwebagro.agrokasa.pe/WSRESTMovilidadERPPruebas/api';

  static const String authEndpoint = '/login/authenticate';
  static const String spEndpoint = '/EjecutarSPERP';

  static const String _prefsKey = 'agrotareo_env_override';

  static AppEnv _current = AppEnv.produccion;

  static AppEnv get current => _current;

  static String get erpBaseUrl =>
      _current == AppEnv.produccion ? urlProduccion : urlPruebas;

  static String label(AppEnv env) =>
      env == AppEnv.produccion ? 'Productivo' : 'Pruebas';

  static String get currentLabel => label(_current);

  /// Carga el override guardado (si existe) antes de construir el ApiClient.
  static Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved == 'pruebas') {
      _current = AppEnv.pruebas;
    } else {
      _current = AppEnv.produccion;
    }
  }

  static Future<void> setEnv(AppEnv env) async {
    _current = env;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, env == AppEnv.pruebas ? 'pruebas' : 'produccion');
  }

  // ─── Timeouts ─────────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 120);
  static const Duration tokenTtl = Duration(hours: 8);
}
