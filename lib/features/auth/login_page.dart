import 'package:flutter/material.dart';

import '../../core/config/app_environment.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/services/app_services.dart';
import '../../shared/widgets/env_switcher_sheet.dart';
import '../shell/agro_shell.dart';

const _kBg = Color(0xFF060E08);
const _kCard = Color(0xFF0E2016);
const _kLime = Color(0xFF8CC53F);
const _kBorder = Color(0xFF1F3D28);
const _kTextDim = Color(0xFF7CA885);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AppServices.instance.login(_userCtrl.text, _passCtrl.text);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const AgroShell()),
      );
    } on AppException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'No se pudo iniciar sesion: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          const _LoginBackdrop(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: _EnvBadge(onTap: () => showEnvSwitcherSheet(context)),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF8CC53F), Color(0xFF1B4332)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _kLime.withValues(alpha: 0.35),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.eco_rounded, size: 48, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'AgroTareo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'SISTEMA DE TAREO AGRICOLA',
                        style: TextStyle(
                          color: _kTextDim,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _kCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _kBorder),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Iniciar Sesion',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              AnimatedBuilder(
                                animation: AppServices.instance,
                                builder: (context, _) => Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(color: _kLime, shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Conectado a ${AppEnvironment.currentLabel}',
                                      style: const TextStyle(color: _kTextDim, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (_error != null) ...[
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3A0A0A),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFF7F1D1D)),
                                  ),
                                  child: Text(
                                    _error!,
                                    style: const TextStyle(color: Color(0xFFFCA5A5), fontSize: 12.5),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                              _fieldLabel('USUARIO'),
                              const SizedBox(height: 6),
                              _DarkField(
                                controller: _userCtrl,
                                hint: 'Ingrese su usuario',
                                icon: Icons.person_rounded,
                                enabled: !_loading,
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingrese su usuario' : null,
                              ),
                              const SizedBox(height: 16),
                              _fieldLabel('CONTRASENA'),
                              const SizedBox(height: 6),
                              _DarkField(
                                controller: _passCtrl,
                                hint: 'Ingrese su contrasena',
                                icon: Icons.lock_rounded,
                                obscure: _obscure,
                                enabled: !_loading,
                                onSubmitted: (_) => _submit(),
                                validator: (v) => (v == null || v.isEmpty) ? 'Ingrese su contrasena' : null,
                                suffix: IconButton(
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                  icon: Icon(
                                    _obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                    color: _kTextDim,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 22),
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF7DB535), Color(0xFF4E7C22)],
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(14),
                                      onTap: _loading ? null : _submit,
                                      child: Center(
                                        child: _loading
                                            ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2.5,
                                                ),
                                              )
                                            : const Text(
                                                'INGRESAR',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 1.4,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const _OfflineBanner(),
                      const SizedBox(height: 16),
                      const Text(
                        'v1.0.0  |  Soporte AgroTareo  |  Agrokasa',
                        style: TextStyle(color: Color(0xFF4A7055), fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) => Text(
        text,
        style: const TextStyle(
          color: _kTextDim,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      );
}

class _DarkField extends StatelessWidget {
  const _DarkField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.enabled = true,
    this.suffix,
    this.validator,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final bool enabled;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      enabled: enabled,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF4A7055)),
        prefixIcon: Icon(icon, color: _kTextDim, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFF15281C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kLime, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF7F1D1D)),
        ),
      ),
    );
  }
}

class _EnvBadge extends StatelessWidget {
  const _EnvBadge({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppServices.instance,
      builder: (context, _) {
        final isProd = AppEnvironment.current == AppEnv.produccion;
        final color = isProd ? const Color(0xFF86EFAC) : const Color(0xFFFBBF24);
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isProd ? Icons.verified_rounded : Icons.science_rounded, size: 14, color: color),
                const SizedBox(width: 6),
                Text(
                  AppEnvironment.currentLabel,
                  style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 4),
                Icon(Icons.swap_horiz_rounded, size: 14, color: color.withValues(alpha: 0.8)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoginBackdrop extends StatelessWidget {
  const _LoginBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0B1F13), Color(0xFF060E08)],
            ),
          ),
        ),
        Positioned(
          top: -80,
          left: -60,
          child: _blob(220, const Color(0xFF1B4332).withValues(alpha: 0.55)),
        ),
        Positioned(
          top: 120,
          right: -90,
          child: _blob(260, const Color(0xFF14532D).withValues(alpha: 0.4)),
        ),
        Positioned(
          bottom: -100,
          left: -40,
          child: _blob(240, const Color(0xFF0F2E1C).withValues(alpha: 0.6)),
        ),
      ],
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield_moon_rounded, color: _kTextDim, size: 16),
          SizedBox(width: 6),
          Flexible(
            child: Text(
              'Modo campo: tus tareos se guardan localmente sin conexion',
              textAlign: TextAlign.center,
              style: TextStyle(color: _kTextDim, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
