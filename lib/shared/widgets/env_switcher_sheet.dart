import 'package:flutter/material.dart';

import '../../core/config/app_environment.dart';
import '../../core/services/app_services.dart';

/// Selector de entorno Productivo / Pruebas. Aplica el cambio de inmediato
/// (persistido) y actualiza la baseUrl del cliente HTTP compartido.
Future<void> showEnvSwitcherSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFF0E2016),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => const _EnvSwitcherContent(),
  );
}

class _EnvSwitcherContent extends StatefulWidget {
  const _EnvSwitcherContent();

  @override
  State<_EnvSwitcherContent> createState() => _EnvSwitcherContentState();
}

class _EnvSwitcherContentState extends State<_EnvSwitcherContent> {
  late AppEnv _selected = AppEnvironment.current;
  bool _applying = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Entorno de conexion',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text(
              'Elige a que servidor se conecta la app',
              style: TextStyle(color: Color(0xFF7CA885), fontSize: 12),
            ),
            const SizedBox(height: 20),
            _envTile(
              env: AppEnv.produccion,
              titulo: 'Productivo',
              subtitulo: 'Datos reales de operacion',
              icon: Icons.verified_rounded,
              color: const Color(0xFF86EFAC),
            ),
            const SizedBox(height: 10),
            _envTile(
              env: AppEnv.pruebas,
              titulo: 'Pruebas',
              subtitulo: 'Entorno de desarrollo / QA',
              icon: Icons.science_rounded,
              color: const Color(0xFFFBBF24),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: _applying || _selected == AppEnvironment.current
                    ? null
                    : () async {
                        setState(() => _applying = true);
                        await AppServices.instance.setEnvironment(_selected);
                        if (!context.mounted) return;
                        setState(() => _applying = false);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Entorno cambiado a ${AppEnvironment.currentLabel}')),
                        );
                      },
                icon: _applying
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.swap_horiz_rounded),
                label: const Text('APLICAR CAMBIO'),
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF4E7C22)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _envTile({
    required AppEnv env,
    required String titulo,
    required String subtitulo,
    required IconData icon,
    required Color color,
  }) {
    final selected = _selected == env;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => _selected = env),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.08) : const Color(0xFF15281C),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? color.withValues(alpha: 0.6) : const Color(0xFF1F3D28)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      color: selected ? color : Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(subtitulo, style: const TextStyle(color: Color(0xFF7CA885), fontSize: 12)),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
              color: selected ? color : const Color(0xFF4A7055),
            ),
          ],
        ),
      ),
    );
  }
}
