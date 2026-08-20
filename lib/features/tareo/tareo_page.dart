import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/agro_theme.dart';
import '../../data/models/employee.dart';
import '../../data/models/parte.dart';
import '../../data/repositories/master_data_repository.dart';
import '../../data/repositories/tareo_repository.dart';
import '../../shared/widgets/section_title.dart';
import '../scanner/scanner_page.dart';

/// Pantalla de Tareo: ciclo completo del parte (jornada) segun
/// `flujocompleto.md` -- crear parte, asistencia, actividades, asignacion
/// de trabajadores, productividad y cierre.
class TareoPage extends StatefulWidget {
  const TareoPage({required this.onScan, super.key});

  final VoidCallback onScan;

  @override
  State<TareoPage> createState() => _TareoPageState();
}

class _TareoPageState extends State<TareoPage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([MasterDataRepository.instance, TareoRepository.instance]),
      builder: (context, _) {
        final master = MasterDataRepository.instance;
        final tareo = TareoRepository.instance;

        if (!master.hasData) {
          return const _EmptyCatalog();
        }

        final parte = tareo.parteActivo;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            if (parte == null)
              _CrearParteCard(locations: master.locations, onCrear: (l, obs) => _crearParte(l, obs))
            else ...[
              _ParteHeaderCard(parte: parte, onCerrar: () => _cerrarParte(parte)),
              const SizedBox(height: 20),
              _AsistenciaSection(parte: parte, onScan: () => _scanAsistencia(parte)),
              const SizedBox(height: 20),
              _ActividadesSection(parte: parte),
            ],
          ],
        );
      },
    );
  }

  Future<void> _crearParte(LocationCatalog location, String? observacion) async {
    try {
      await TareoRepository.instance.crearParte(location: location, observacion: observacion);
    } on TareoValidationException catch (e) {
      _snack(e.message);
    }
  }

  Future<void> _scanAsistencia(TareoParte parte) async {
    final code = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(builder: (_) => const ScannerPage()),
    );
    if (code == null || code.isEmpty || !mounted) return;
    final master = MasterDataRepository.instance;
    final match = master.employees.where(
      (e) => e.codigoTrabajador.trim().toLowerCase() == code.trim().toLowerCase(),
    );
    if (match.isEmpty) {
      _snack('No se encontro un trabajador con el codigo "$code"');
      return;
    }
    await _registrarAsistencia(match.first);
  }

  Future<void> _registrarAsistencia(Employee employee) async {
    try {
      final (_, esEntrada) = await TareoRepository.instance.registrarAsistencia(employee);
      _snack(esEntrada ? '${employee.displayName}: ENTRADA registrada' : '${employee.displayName}: SALIDA registrada');
    } on TareoValidationException catch (e) {
      _snack(e.message);
    }
  }

  Future<void> _cerrarParte(TareoParte parte) async {
    final abiertas = TareoRepository.instance.asistenciasDe(parte.id).where((a) => a.enLabor).length;
    var force = false;
    if (abiertas > 0) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cerrar parte'),
          content: Text(
            '$abiertas trabajador(es) siguen "en labor" sin registrar salida. '
            'Si cierras ahora, se les registrara la salida con la hora actual.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Forzar cierre')),
          ],
        ),
      );
      if (confirm != true) return;
      force = true;
    } else {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cerrar parte'),
          content: const Text('Se enviaran los tickajes de todos los trabajadores registrados. Continuar?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Cerrar parte')),
          ],
        ),
      );
      if (confirm != true) return;
    }

    try {
      final generados = await TareoRepository.instance.cerrarParte(force: force);
      _snack('Parte cerrado. $generados tickaje(s) en cola para enviar (ve a Historial).');
    } on TareoValidationException catch (e) {
      _snack(e.message);
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

// ─── Crear parte ────────────────────────────────────────────────────────────

class _CrearParteCard extends StatefulWidget {
  const _CrearParteCard({required this.locations, required this.onCrear});

  final List<LocationCatalog> locations;
  final void Function(LocationCatalog location, String? observacion) onCrear;

  @override
  State<_CrearParteCard> createState() => _CrearParteCardState();
}

class _CrearParteCardState extends State<_CrearParteCard> {
  LocationCatalog? _location;
  final _obsCtrl = TextEditingController();

  @override
  void dispose() {
    _obsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _location ??= widget.locations.isNotEmpty ? widget.locations.first : null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.assignment_add, color: AgroTheme.lime),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Iniciar nuevo parte', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Un parte agrupa la asistencia, actividades y productividad del dia.',
              style: TextStyle(color: AgroTheme.textDim, fontSize: 12.5),
            ),
            const SizedBox(height: 18),
            const Text('UBICACION', style: TextStyle(color: AgroTheme.textDim, fontSize: 11, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            _DropdownField<LocationCatalog>(
              value: _location,
              items: widget.locations,
              display: (l) => l.nombre,
              onChanged: (v) => setState(() => _location = v),
            ),
            const SizedBox(height: 14),
            const Text('OBSERVACION (OPCIONAL)', style: TextStyle(color: AgroTheme.textDim, fontSize: 11, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            TextField(controller: _obsCtrl, decoration: const InputDecoration(hintText: 'Ej. Cuadrilla A - lluvia leve')),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: _location == null
                    ? null
                    : () => widget.onCrear(_location!, _obsCtrl.text.trim().isEmpty ? null : _obsCtrl.text.trim()),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('INICIAR PARTE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header del parte activo ───────────────────────────────────────────────

class _ParteHeaderCard extends StatelessWidget {
  const _ParteHeaderCard({required this.parte, required this.onCerrar});

  final TareoParte parte;
  final VoidCallback onCerrar;

  @override
  Widget build(BuildContext context) {
    final tareo = TareoRepository.instance;
    final asistencias = tareo.asistenciasDe(parte.id);
    final enLabor = asistencias.where((a) => a.enLabor).length;
    final duracion = DateTime.now().difference(parte.horaInicio);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AgroTheme.primaryContainer, AgroTheme.card],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AgroTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  parte.locationNombre,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onCerrar,
                icon: const Icon(Icons.lock_clock_rounded, size: 18),
                label: const Text('Cerrar parte'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Iniciado ${DateFormat('HH:mm').format(parte.horaInicio)} - ${_fmtDuration(duracion)} en curso',
            style: const TextStyle(color: AgroTheme.textDim, fontSize: 12.5),
          ),
          if (parte.observacion != null) ...[
            const SizedBox(height: 6),
            Text(parte.observacion!, style: const TextStyle(color: AgroTheme.textDim, fontSize: 12.5)),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              _kpiChip(Icons.groups_rounded, '$enLabor en labor', AgroTheme.success),
              const SizedBox(width: 8),
              _kpiChip(Icons.how_to_reg_rounded, '${asistencias.length} registrados', AgroTheme.lime),
              const SizedBox(width: 8),
              _kpiChip(Icons.task_alt_rounded, '${tareo.actividadesDe(parte.id).length} actividades', AgroTheme.warning),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kpiChip(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 2),
            Text(label, textAlign: TextAlign.center, style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  String _fmtDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }
}

// ─── Asistencia ─────────────────────────────────────────────────────────────

class _AsistenciaSection extends StatelessWidget {
  const _AsistenciaSection({required this.parte, required this.onScan});

  final TareoParte parte;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final tareo = TareoRepository.instance;
    final master = MasterDataRepository.instance;
    final asistencias = tareo.asistenciasDe(parte.id).reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: SectionTitle('Asistencia')),
            OutlinedButton.icon(
              onPressed: onScan,
              icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
              label: const Text('Escanear'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () => _pickEmployeeAndRegister(context, master),
              icon: const Icon(Icons.person_search_rounded, size: 18),
              label: const Text('Buscar'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (asistencias.isEmpty)
          const _HintCard(text: 'Ningun trabajador registrado todavia. Escanea o busca para dar entrada.')
        else
          for (final a in asistencias)
            Card(
              child: ListTile(
                leading: Icon(
                  a.enLabor ? Icons.circle : Icons.circle_outlined,
                  color: a.enLabor ? AgroTheme.success : AgroTheme.textDim,
                  size: 14,
                ),
                title: Text(a.employeeNombre),
                subtitle: Text(
                  a.enLabor
                      ? 'Entrada ${DateFormat('HH:mm').format(a.entrada)}'
                      : 'Entrada ${DateFormat('HH:mm').format(a.entrada)} - Salida ${DateFormat('HH:mm').format(a.salida!)}',
                ),
                trailing: a.enLabor
                    ? TextButton(
                        onPressed: () => _registrarSalida(context, a),
                        child: const Text('Marcar salida'),
                      )
                    : const Icon(Icons.check_circle_rounded, color: AgroTheme.success, size: 18),
              ),
            ),
      ],
    );
  }

  Future<void> _registrarSalida(BuildContext context, Asistencia asistencia) async {
    final employee = MasterDataRepository.instance.employeeById(asistencia.employeeId);
    if (employee == null) return;
    try {
      await TareoRepository.instance.registrarAsistencia(employee);
    } on TareoValidationException catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _pickEmployeeAndRegister(BuildContext context, MasterDataRepository master) async {
    final employee = await _pickEmployee(context, master.employees);
    if (employee == null || !context.mounted) return;
    try {
      final (_, esEntrada) = await TareoRepository.instance.registrarAsistencia(employee);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(esEntrada ? '${employee.displayName}: ENTRADA registrada' : '${employee.displayName}: SALIDA registrada')),
      );
    } on TareoValidationException catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}

// ─── Actividades ────────────────────────────────────────────────────────────

class _ActividadesSection extends StatelessWidget {
  const _ActividadesSection({required this.parte});

  final TareoParte parte;

  @override
  Widget build(BuildContext context) {
    final tareo = TareoRepository.instance;
    final actividades = tareo.actividadesDe(parte.id);
    final enLabor = tareo.asistenciasDe(parte.id).where((a) => a.enLabor).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: SectionTitle('Actividades')),
            FilledButton.icon(
              onPressed: enLabor.isEmpty ? null : () => _crearActividad(context, enLabor),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Actividad'),
            ),
          ],
        ),
        if (enLabor.isEmpty)
          const _HintCard(text: 'Registra al menos un trabajador "en labor" para poder crear una actividad.')
        else if (actividades.isEmpty)
          const _HintCard(text: 'Ninguna actividad creada todavia en este parte.')
        else
          for (final actividad in actividades) _ActividadCard(actividad: actividad, parte: parte),
      ],
    );
  }

  Future<void> _crearActividad(BuildContext context, List<Asistencia> enLabor) async {
    final master = MasterDataRepository.instance;
    final result = await showModalBottomSheet<_NuevaActividad>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CrearActividadSheet(activities: master.activities, products: master.products, types: master.productivityTypes, disponibles: enLabor),
    );
    if (result == null || !context.mounted) return;
    try {
      await TareoRepository.instance.crearActividad(
        activity: result.activity,
        product: result.product,
        productivityType: result.productivityType,
        workerIds: result.workerIds,
      );
    } on TareoValidationException catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}

class _ActividadCard extends StatelessWidget {
  const _ActividadCard({required this.actividad, required this.parte});

  final ActividadParte actividad;
  final TareoParte parte;

  @override
  Widget build(BuildContext context) {
    final master = MasterDataRepository.instance;
    final workers = actividad.workerIds.map(master.employeeById).whereType<Employee>().toList();

    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.task_alt_rounded, color: AgroTheme.lime),
        title: Text(actividad.activityNombre, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(
          '${workers.length} trabajador(es)'
          '${actividad.productNombre != null ? ' - ${actividad.productNombre}' : ''}',
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: [
          if (workers.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Sin trabajadores asignados.', style: TextStyle(color: AgroTheme.textDim)),
            )
          else
            for (final w in workers)
              _WorkerProductivityRow(actividad: actividad, employee: w),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _editarAsignados(context),
              icon: const Icon(Icons.group_add_rounded, size: 16),
              label: const Text('Editar trabajadores asignados'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editarAsignados(BuildContext context) async {
    final tareo = TareoRepository.instance;
    final enLabor = tareo.asistenciasDe(parte.id);
    final result = await showModalBottomSheet<List<int>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AsignarTrabajadoresSheet(disponibles: enLabor, seleccionados: actividad.workerIds.toSet()),
    );
    if (result == null) return;
    await tareo.asignarTrabajadores(actividad.id, result);
  }
}

class _WorkerProductivityRow extends StatelessWidget {
  const _WorkerProductivityRow({required this.actividad, required this.employee});

  final ActividadParte actividad;
  final Employee employee;

  @override
  Widget build(BuildContext context) {
    final registros = TareoRepository.instance.productividadDe(actividad.id).where((p) => p.employeeId == employee.id).toList();
    final total = registros.fold<double>(0, (s, r) => s + r.cantidad);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employee.displayName, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(
                  registros.isEmpty ? 'Sin productividad registrada' : '${registros.length} lectura(s) - total ${_fmt(total)}',
                  style: const TextStyle(color: AgroTheme.textDim, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _registrar(context),
            child: const Text('+ Productividad'),
          ),
        ],
      ),
    );
  }

  String _fmt(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);

  Future<void> _registrar(BuildContext context) async {
    final master = MasterDataRepository.instance;
    final tipo = master.productivityTypes.where((t) => t.id == actividad.productivityTypeId).toList();
    final producto = master.products.where((p) => p.id == actividad.productId).toList();
    final cantidad = await showDialog<double>(
      context: context,
      builder: (context) => _CantidadDialog(
        titulo: 'Productividad - ${employee.displayName}',
        tipo: tipo.isEmpty ? null : tipo.first,
      ),
    );
    if (cantidad == null) return;
    try {
      await TareoRepository.instance.registrarProductividad(
        actividad: actividad,
        employee: employee,
        cantidad: cantidad,
        product: producto.isEmpty ? null : producto.first,
        productivityType: tipo.isEmpty ? null : tipo.first,
      );
    } on TareoValidationException catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}

// ─── Dialogos / sheets ──────────────────────────────────────────────────────

class _NuevaActividad {
  const _NuevaActividad({required this.activity, this.product, this.productivityType, required this.workerIds});
  final ActivityCatalog activity;
  final ProductCatalog? product;
  final ProductivityTypeCatalog? productivityType;
  final List<int> workerIds;
}

class _CrearActividadSheet extends StatefulWidget {
  const _CrearActividadSheet({required this.activities, required this.products, required this.types, required this.disponibles});

  final List<ActivityCatalog> activities;
  final List<ProductCatalog> products;
  final List<ProductivityTypeCatalog> types;
  final List<Asistencia> disponibles;

  @override
  State<_CrearActividadSheet> createState() => _CrearActividadSheetState();
}

class _CrearActividadSheetState extends State<_CrearActividadSheet> {
  ActivityCatalog? _activity;
  ProductCatalog? _product;
  ProductivityTypeCatalog? _type;
  final Set<int> _workerIds = {};

  @override
  Widget build(BuildContext context) {
    _activity ??= widget.activities.isNotEmpty ? widget.activities.first : null;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Nueva actividad', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              const Text('ACTIVIDAD', style: TextStyle(color: AgroTheme.textDim, fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              _DropdownField<ActivityCatalog>(
                value: _activity,
                items: widget.activities,
                display: (a) => a.nombre,
                onChanged: (v) => setState(() => _activity = v),
              ),
              const SizedBox(height: 14),
              const Text('PRODUCTO (OPCIONAL)', style: TextStyle(color: AgroTheme.textDim, fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              _DropdownField<ProductCatalog>(
                value: _product,
                items: widget.products,
                display: (p) => p.nombre,
                onChanged: (v) => setState(() => _product = v),
                allowEmpty: true,
              ),
              const SizedBox(height: 14),
              const Text('TIPO DE PRODUCTIVIDAD (OPCIONAL)', style: TextStyle(color: AgroTheme.textDim, fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              _DropdownField<ProductivityTypeCatalog>(
                value: _type,
                items: widget.types,
                display: (t) => t.nombre,
                onChanged: (v) => setState(() => _type = v),
                allowEmpty: true,
              ),
              const SizedBox(height: 14),
              Text(
                'TRABAJADORES (${_workerIds.length} seleccionados)',
                style: const TextStyle(color: AgroTheme.textDim, fontSize: 11, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final a in widget.disponibles)
                      CheckboxListTile(
                        dense: true,
                        value: _workerIds.contains(a.employeeId),
                        title: Text(a.employeeNombre),
                        onChanged: (v) => setState(() {
                          if (v ?? false) {
                            _workerIds.add(a.employeeId);
                          } else {
                            _workerIds.remove(a.employeeId);
                          }
                        }),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _activity == null
                      ? null
                      : () => Navigator.of(context).pop(_NuevaActividad(
                            activity: _activity!,
                            product: _product,
                            productivityType: _type,
                            workerIds: _workerIds.toList(),
                          )),
                  child: const Text('CREAR ACTIVIDAD'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AsignarTrabajadoresSheet extends StatefulWidget {
  const _AsignarTrabajadoresSheet({required this.disponibles, required this.seleccionados});

  final List<Asistencia> disponibles;
  final Set<int> seleccionados;

  @override
  State<_AsignarTrabajadoresSheet> createState() => _AsignarTrabajadoresSheetState();
}

class _AsignarTrabajadoresSheetState extends State<_AsignarTrabajadoresSheet> {
  late final Set<int> _seleccionados = {...widget.seleccionados};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Trabajadores asignados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final a in widget.disponibles)
                    CheckboxListTile(
                      value: _seleccionados.contains(a.employeeId),
                      title: Text(a.employeeNombre),
                      subtitle: Text(a.enLabor ? 'En labor' : 'Con salida registrada'),
                      onChanged: (v) => setState(() {
                        if (v ?? false) {
                          _seleccionados.add(a.employeeId);
                        } else {
                          _seleccionados.remove(a.employeeId);
                        }
                      }),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(_seleccionados.toList()),
                child: const Text('GUARDAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CantidadDialog extends StatefulWidget {
  const _CantidadDialog({required this.titulo, this.tipo});

  final String titulo;
  final ProductivityTypeCatalog? tipo;

  @override
  State<_CantidadDialog> createState() => _CantidadDialogState();
}

class _CantidadDialogState extends State<_CantidadDialog> {
  late final _ctrl = TextEditingController(text: _fmt(widget.tipo?.valorDefecto ?? 0));
  String? _error;

  String _fmt(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  @override
  Widget build(BuildContext context) {
    final tipo = widget.tipo;
    return AlertDialog(
      title: Text(widget.titulo),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _ctrl,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: tipo?.nombre ?? 'Cantidad',
              errorText: _error,
            ),
          ),
          if (tipo != null && (tipo.minimo != null || tipo.maximo != null)) ...[
            const SizedBox(height: 8),
            Text(
              'Rango permitido: ${tipo.minimo ?? '-'} a ${tipo.maximo ?? '-'}',
              style: const TextStyle(color: AgroTheme.textDim, fontSize: 12),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(
          onPressed: () {
            final value = double.tryParse(_ctrl.text.replaceAll(',', '.'));
            if (value == null) {
              setState(() => _error = 'Ingresa un numero valido');
              return;
            }
            final error = tipo?.validar(value);
            if (error != null) {
              setState(() => _error = error);
              return;
            }
            Navigator.of(context).pop(value);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

// ─── Utilidades UI ──────────────────────────────────────────────────────────

Future<Employee?> _pickEmployee(BuildContext context, List<Employee> employees) {
  return showModalBottomSheet<Employee>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      var query = '';
      return StatefulBuilder(
        builder: (context, setSheetState) {
          final filtered = employees
              .where((e) => e.displayName.toLowerCase().contains(query.toLowerCase()) || e.codigoTrabajador.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.7,
                child: Column(
                  children: [
                    const Text('Selecciona trabajador', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'Buscar por nombre o codigo'),
                      onChanged: (v) => setSheetState(() => query = v),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(child: Text('Sin resultados'))
                          : ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, i) {
                                final e = filtered[i];
                                return ListTile(
                                  leading: const Icon(Icons.person_rounded),
                                  title: Text(e.displayName),
                                  subtitle: Text('Codigo: ${e.codigoTrabajador}'),
                                  onTap: () => Navigator.of(context).pop(e),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.items,
    required this.display,
    required this.onChanged,
    this.allowEmpty = false,
    super.key,
  });

  final T? value;
  final List<T> items;
  final String Function(T) display;
  final ValueChanged<T?> onChanged;
  final bool allowEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AgroTheme.cardAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AgroTheme.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: items.contains(value) ? value : null,
          hint: const Text('Selecciona', style: TextStyle(color: AgroTheme.textFaint)),
          dropdownColor: AgroTheme.cardAlt,
          items: [
            if (allowEmpty) const DropdownMenuItem<Never>(value: null, child: Text('(ninguno)')),
            for (final item in items)
              DropdownMenuItem<T>(value: item, child: Text(display(item), overflow: TextOverflow.ellipsis)),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _HintCard extends StatelessWidget {
  const _HintCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(text, style: const TextStyle(color: AgroTheme.textDim)),
      ),
    );
  }
}

class _EmptyCatalog extends StatelessWidget {
  const _EmptyCatalog();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Aun no hay catalogos sincronizados. Vuelve a iniciar sesion o revisa tu conexion.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
