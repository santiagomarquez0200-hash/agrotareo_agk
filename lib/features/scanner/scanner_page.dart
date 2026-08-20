import 'package:flutter/material.dart';

import '../../core/theme/agro_theme.dart';
import '../../shared/widgets/field_background.dart';

/// Escaneo de codigo de trabajador. No se integro una libreria de camara en
/// esta version (mantiene el proyecto libre de permisos nativos extra); el
/// ingreso manual devuelve el codigo a la pantalla de Tareo, que lo resuelve
/// contra el catalogo real de empleados sincronizado.
class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Escanear codigo')),
      body: Stack(
        children: [
          const Positioned.fill(child: FieldBackground(dark: true)),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    border: Border.all(color: AgroTheme.secondaryContainer, width: 4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 90),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Camara no disponible en este build.\nIngresa el codigo manualmente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 32,
            child: Column(
              children: [
                TextField(
                  controller: _ctrl,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white10,
                    hintText: 'Codigo de trabajador',
                    hintStyle: TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(_ctrl.text.trim()),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Usar codigo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
