import 'package:flutter/material.dart';

import '../core/services/app_services.dart';
import '../core/theme/agro_theme.dart';
import '../features/auth/login_page.dart';
import '../features/shell/agro_shell.dart';

class AgroTareoApp extends StatelessWidget {
  const AgroTareoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgroTareo AGK',
      theme: AgroTheme.dark(),
      darkTheme: AgroTheme.dark(),
      themeMode: ThemeMode.dark,
      home: const _AuthGate(),
    );
  }
}

/// Arranca AppServices (entorno, sesion cacheada, catalogos locales) antes
/// de decidir si mostrar el login o entrar directo al shell.
class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  late final Future<void> _bootstrap = AppServices.instance.bootstrap();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _bootstrap,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _SplashScreen();
        }
        return AppServices.instance.isLoggedIn ? const AgroShell() : const LoginPage();
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF060E08),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco_rounded, color: Color(0xFF8CC53F), size: 56),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Color(0xFF8CC53F), strokeWidth: 2.5),
          ],
        ),
      ),
    );
  }
}
