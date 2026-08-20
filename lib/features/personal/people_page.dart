import 'package:flutter/material.dart';

import '../../core/theme/agro_theme.dart';
import '../../data/models/employee.dart';
import '../../data/repositories/master_data_repository.dart';
import '../scanner/scanner_page.dart';

/// Directorio de personal: filtra el catalogo de empleados sincronizado por
/// codigo, nombre o DNI. Pensado para validar el resultado de un escaneo QR
/// o para buscar manualmente a un trabajador y ver su ficha completa.
class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    final code = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(builder: (_) => const ScannerPage()),
    );
    if (code == null || code.isEmpty) return;
    _searchCtrl.text = code;
    setState(() => _query = code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal')),
      body: AnimatedBuilder(
        animation: MasterDataRepository.instance,
        builder: (context, _) {
          final employees = MasterDataRepository.instance.employees;
          final q = _query.trim().toLowerCase();
          final filtered = q.isEmpty
              ? employees
              : employees.where((e) {
                  return e.codigoTrabajador.toLowerCase().contains(q) ||
                      (e.nombre ?? '').toLowerCase().contains(q) ||
                      (e.documento ?? '').toLowerCase().contains(q);
                }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded),
                    hintText: 'Buscar por codigo, nombre o DNI',
                    suffixIcon: IconButton(
                      tooltip: 'Escanear',
                      icon: const Icon(Icons.qr_code_scanner_rounded),
                      onPressed: _scan,
                    ),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              if (employees.isEmpty)
                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Aun no hay personal sincronizado. Ve a Perfil y presiona "Sincronizar".',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else if (filtered.isEmpty)
                const Expanded(child: Center(child: Text('Sin resultados para esa busqueda')))
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final e = filtered[i];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: e.activo ? AgroTheme.secondaryContainer : AgroTheme.surfaceHigh,
                            child: Text(
                              _initials(e.displayName),
                              style: const TextStyle(color: AgroTheme.primary, fontWeight: FontWeight.w800),
                            ),
                          ),
                          title: Text(e.displayName),
                          subtitle: Text('Codigo: ${e.codigoTrabajador}${e.documento != null ? ' - DNI: ${e.documento}' : ''}'),
                          trailing: e.activo
                              ? const Icon(Icons.check_circle_rounded, color: AgroTheme.secondary, size: 18)
                              : const Icon(Icons.cancel_rounded, color: AgroTheme.danger, size: 18),
                          onTap: () => _showDetail(context, e),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showDetail(BuildContext context, Employee employee) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AgroTheme.secondaryContainer,
                    child: Text(
                      _initials(employee.displayName),
                      style: const TextStyle(color: AgroTheme.primary, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(employee.displayName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                        Text(employee.activo ? 'Activo' : 'Inactivo'),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 28),
              _detailRow('Codigo de trabajador', employee.codigoTrabajador),
              _detailRow('DNI / documento', employee.documento ?? '-'),
              _detailRow('Id ubicacion', employee.locationId?.toString() ?? '-'),
              _detailRow('Id interno', employee.id.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 150, child: Text(label, style: const TextStyle(color: AgroTheme.textDim))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}

String _initials(String value) {
  final parts = value.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) return '?';
  return parts.take(2).map((p) => p[0]).join().toUpperCase();
}
