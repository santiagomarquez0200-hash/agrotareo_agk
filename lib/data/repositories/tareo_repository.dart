import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/employee.dart';
import '../models/outbox_event.dart';
import '../models/parte.dart';
import '../models/sync_status.dart';
import 'outbox_repository.dart';

class TareoValidationException implements Exception {
  const TareoValidationException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Estado local del flujo de Tareo (parte -> asistencia -> actividad ->
/// asignacion -> productividad -> cierre), segun `flujocompleto.md`.
///
/// Todo vive local hasta que se cierra el parte: en ese momento se arma un
/// [OutboxEvent] (tickage real) por cada (trabajador, actividad) que
/// participo, con sus lecturas de productividad, y se encola en
/// [OutboxRepository] para el envio real via
/// `CLI547_AGM_MOBILE_SYNC_INSERT`.
class TareoRepository extends ChangeNotifier {
  TareoRepository._();

  static final instance = TareoRepository._();

  static const _prefsKey = 'agrotareo_tareo_v1';
  static const _uuid = Uuid();

  TareoParte? parteActivo;
  final List<TareoParte> _historialPartes = [];
  final List<Asistencia> _asistencias = [];
  final List<ActividadParte> _actividades = [];
  final List<ProductividadRegistro> _productividades = [];

  List<TareoParte> get historialPartes => List.unmodifiable(_historialPartes);
  List<Asistencia> get asistencias => List.unmodifiable(_asistencias);
  List<ActividadParte> get actividades => List.unmodifiable(_actividades);
  List<ProductividadRegistro> get productividades => List.unmodifiable(_productividades);

  List<Asistencia> asistenciasDe(String parteId) =>
      _asistencias.where((a) => a.parteId == parteId).toList();

  List<ActividadParte> actividadesDe(String parteId) =>
      _actividades.where((a) => a.parteId == parteId).toList();

  List<ProductividadRegistro> productividadDe(String actividadParteId) =>
      _productividades.where((p) => p.actividadParteId == actividadParteId).toList();

  Asistencia? asistenciaAbierta(int employeeId) {
    if (parteActivo == null) return null;
    for (final a in _asistencias.reversed) {
      if (a.parteId == parteActivo!.id && a.employeeId == employeeId && a.enLabor) return a;
    }
    return null;
  }

  // ─── KPIs (Inicio) ────────────────────────────────────────────────────────

  int get trabajadoresActivosHoy {
    if (parteActivo == null) return 0;
    return asistenciasDe(parteActivo!.id).where((a) => a.enLabor).length;
  }

  int get partesAbiertosCount => parteActivo != null ? 1 : 0;

  int get actividadesCreadasHoy {
    final hoy = DateTime.now();
    return _actividades
        .where((a) => a.createdAt.year == hoy.year && a.createdAt.month == hoy.month && a.createdAt.day == hoy.day)
        .length;
  }

  double get productividadTotalHoy {
    final hoy = DateTime.now();
    return _productividades
        .where((p) => p.hora.year == hoy.year && p.hora.month == hoy.month && p.hora.day == hoy.day)
        .fold(0.0, (sum, p) => sum + p.cantidad);
  }

  // ─── Persistencia ─────────────────────────────────────────────────────────

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      parteActivo = json['parteActivo'] == null
          ? null
          : TareoParte.fromJson(Map<String, dynamic>.from(json['parteActivo'] as Map));
      _historialPartes
        ..clear()
        ..addAll((json['historialPartes'] as List<dynamic>? ?? [])
            .map((e) => TareoParte.fromJson(Map<String, dynamic>.from(e as Map))));
      _asistencias
        ..clear()
        ..addAll((json['asistencias'] as List<dynamic>? ?? [])
            .map((e) => Asistencia.fromJson(Map<String, dynamic>.from(e as Map))));
      _actividades
        ..clear()
        ..addAll((json['actividades'] as List<dynamic>? ?? [])
            .map((e) => ActividadParte.fromJson(Map<String, dynamic>.from(e as Map))));
      _productividades
        ..clear()
        ..addAll((json['productividades'] as List<dynamic>? ?? [])
            .map((e) => ProductividadRegistro.fromJson(Map<String, dynamic>.from(e as Map))));
      notifyListeners();
    } catch (_) {
      // Cache corrupta: se ignora, arranca en blanco.
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode({
      'parteActivo': parteActivo?.toJson(),
      'historialPartes': _historialPartes.map((p) => p.toJson()).toList(),
      'asistencias': _asistencias.map((a) => a.toJson()).toList(),
      'actividades': _actividades.map((a) => a.toJson()).toList(),
      'productividades': _productividades.map((p) => p.toJson()).toList(),
    });
    await prefs.setString(_prefsKey, json);
  }

  // ─── Paso 1: crear parte ────────────────────────────────────────────────

  Future<TareoParte> crearParte({
    required LocationCatalog location,
    String? observacion,
    int? campaignId,
  }) async {
    if (parteActivo != null) {
      throw const TareoValidationException('Ya hay un parte abierto. Cierralo antes de crear otro.');
    }
    final now = DateTime.now();
    final parte = TareoParte(
      id: _uuid.v4(),
      locationId: location.id,
      locationNombre: location.nombre,
      fecha: DateTime(now.year, now.month, now.day),
      horaInicio: now,
      observacion: observacion,
      campaignId: campaignId,
      estado: ParteEstado.abierto,
    );
    parteActivo = parte;
    await _persist();
    notifyListeners();
    return parte;
  }

  // ─── Paso 2: asistencia (entrada/salida) ───────────────────────────────

  /// Si el trabajador no tiene entrada activa en el parte, registra
  /// ENTRADA; si ya la tiene, registra SALIDA. Devuelve la asistencia
  /// resultante y si fue una entrada (`true`) o salida (`false`).
  Future<(Asistencia, bool esEntrada)> registrarAsistencia(Employee employee) async {
    final parte = parteActivo;
    if (parte == null) {
      throw const TareoValidationException('No hay un parte abierto. Crea uno primero.');
    }
    final abierta = asistenciaAbierta(employee.id);
    if (abierta != null) {
      final index = _asistencias.indexWhere((a) => a.id == abierta.id);
      final actualizada = abierta.copyWith(salida: DateTime.now());
      _asistencias[index] = actualizada;
      await _persist();
      notifyListeners();
      return (actualizada, false);
    }

    final nueva = Asistencia(
      id: _uuid.v4(),
      parteId: parte.id,
      employeeId: employee.id,
      employeeNombre: employee.displayName,
      locationId: parte.locationId,
      entrada: DateTime.now(),
    );
    _asistencias.add(nueva);
    await _persist();
    notifyListeners();
    return (nueva, true);
  }

  // ─── Paso 3: crear actividad ────────────────────────────────────────────

  Future<ActividadParte> crearActividad({
    required ActivityCatalog activity,
    ProductCatalog? product,
    ProductivityTypeCatalog? productivityType,
    List<int> workerIds = const [],
  }) async {
    final parte = parteActivo;
    if (parte == null) {
      throw const TareoValidationException('No hay un parte abierto.');
    }
    final yaExiste = actividadesDe(parte.id).any(
      (a) => a.activityNombre.trim().toLowerCase() == activity.nombre.trim().toLowerCase(),
    );
    if (yaExiste) {
      throw TareoValidationException('Ya existe una actividad "${activity.nombre}" en este parte.');
    }
    final validos = _soloConEntrada(workerIds);
    final actividad = ActividadParte(
      id: _uuid.v4(),
      parteId: parte.id,
      activityId: activity.id,
      activityNombre: activity.nombre,
      locationId: parte.locationId,
      productId: product?.id,
      productNombre: product?.nombre,
      productivityTypeId: productivityType?.id,
      productivityTypeNombre: productivityType?.nombre,
      workerIds: validos,
      createdAt: DateTime.now(),
    );
    _actividades.add(actividad);
    await _persist();
    notifyListeners();
    return actividad;
  }

  // ─── Asignar/actualizar trabajadores de una actividad ──────────────────

  Future<void> asignarTrabajadores(String actividadParteId, List<int> workerIds) async {
    final index = _actividades.indexWhere((a) => a.id == actividadParteId);
    if (index == -1) return;
    _actividades[index] = _actividades[index].copyWith(workerIds: _soloConEntrada(workerIds));
    await _persist();
    notifyListeners();
  }

  List<int> _soloConEntrada(List<int> workerIds) {
    if (parteActivo == null) return const [];
    final conEntrada = asistenciasDe(parteActivo!.id).map((a) => a.employeeId).toSet();
    return workerIds.where(conEntrada.contains).toList();
  }

  // ─── Paso 4: registrar productividad ────────────────────────────────────

  Future<ProductividadRegistro> registrarProductividad({
    required ActividadParte actividad,
    required Employee employee,
    required double cantidad,
    ProductCatalog? product,
    ProductivityTypeCatalog? productivityType,
  }) async {
    if (parteActivo == null || parteActivo!.id != actividad.parteId) {
      throw const TareoValidationException('El parte de esta actividad ya no esta abierto.');
    }
    if (!actividad.workerIds.contains(employee.id)) {
      throw TareoValidationException('${employee.displayName} no esta asignado a esta actividad.');
    }
    if (productivityType != null) {
      final error = productivityType.validar(cantidad);
      if (error != null) throw TareoValidationException(error);
    }

    final registro = ProductividadRegistro(
      id: _uuid.v4(),
      actividadParteId: actividad.id,
      employeeId: employee.id,
      employeeNombre: employee.displayName,
      cantidad: cantidad,
      hora: DateTime.now(),
      productId: product?.id ?? actividad.productId,
      productivityTypeId: productivityType?.id ?? actividad.productivityTypeId,
    );
    _productividades.add(registro);
    await _persist();
    notifyListeners();
    return registro;
  }

  // ─── Paso 5: cerrar parte ────────────────────────────────────────────────

  /// Cierra el parte activo. Si algun trabajador sigue "en labor" y
  /// [force] es false, lanza [TareoValidationException]. Al cerrar, arma
  /// los tickages reales (uno por trabajador x actividad) y los encola en
  /// el outbox para el envio real.
  Future<int> cerrarParte({bool force = false}) async {
    final parte = parteActivo;
    if (parte == null) {
      throw const TareoValidationException('No hay un parte abierto.');
    }
    final propias = asistenciasDe(parte.id);
    final sinSalida = propias.where((a) => a.enLabor).toList();
    if (sinSalida.isNotEmpty && !force) {
      throw TareoValidationException(
        '${sinSalida.length} trabajador(es) siguen "en labor" sin registrar salida. '
        'Registra su salida o fuerza el cierre.',
      );
    }

    final ahora = DateTime.now();
    // Si se fuerza el cierre, las asistencias abiertas se cierran con la
    // hora actual para poder generar su tickage.
    for (final a in sinSalida) {
      final index = _asistencias.indexWhere((x) => x.id == a.id);
      _asistencias[index] = a.copyWith(salida: ahora);
    }

    var generados = 0;
    for (final actividad in actividadesDe(parte.id)) {
      for (final workerId in actividad.workerIds) {
        final asistencia = _asistencias
            .where((a) => a.parteId == parte.id && a.employeeId == workerId)
            .fold<Asistencia?>(null, (best, a) => best == null || a.entrada.isAfter(best.entrada) ? a : best);
        if (asistencia == null) continue;

        final entradas = productividadDe(actividad.id).where((p) => p.employeeId == workerId).toList();

        await OutboxRepository.instance.enqueue(
          OutboxEvent(
            tempId: _uuid.v4(),
            worker: asistencia.employeeNombre,
            employeeId: workerId,
            activity: actividad.activityNombre,
            activityId: actividad.activityId,
            location: parte.locationNombre,
            locationId: actividad.locationId,
            createdAt: asistencia.entrada,
            finalAt: asistencia.salida ?? ahora,
            status: SyncStatus.pending,
            attempts: 0,
            entries: entradas
                .map((p) => ProductivityEntry(
                      quantity: p.cantidad,
                      readtime: p.hora,
                      productId: p.productId,
                      productivityTypeId: p.productivityTypeId,
                    ))
                .toList(),
          ),
        );
        generados++;
      }
    }

    final cerrado = parte.copyWith(horaFin: ahora, estado: ParteEstado.cerrado);
    _historialPartes.insert(0, cerrado);
    parteActivo = null;
    await _persist();
    notifyListeners();
    return generados;
  }
}
