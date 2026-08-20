/// Modelos locales del flujo de Tareo (parte / jornada), segun
/// `flujocompleto.md`. Todo vive local (SharedPreferences) hasta el cierre
/// del parte, momento en el que se traducen a `tickages` +
/// `productivity_logs` reales para `CLI547_AGM_MOBILE_SYNC_INSERT`.
library;

enum ParteEstado { abierto, cerrado }

/// Entrada/salida de un trabajador dentro de un parte.
class Asistencia {
  const Asistencia({
    required this.id,
    required this.parteId,
    required this.employeeId,
    required this.employeeNombre,
    required this.locationId,
    required this.entrada,
    this.salida,
  });

  final String id;
  final String parteId;
  final int employeeId;
  final String employeeNombre;
  final int locationId;
  final DateTime entrada;
  final DateTime? salida;

  bool get enLabor => salida == null;

  Asistencia copyWith({DateTime? salida}) => Asistencia(
        id: id,
        parteId: parteId,
        employeeId: employeeId,
        employeeNombre: employeeNombre,
        locationId: locationId,
        entrada: entrada,
        salida: salida ?? this.salida,
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'parteId': parteId,
        'employeeId': employeeId,
        'employeeNombre': employeeNombre,
        'locationId': locationId,
        'entrada': entrada.toIso8601String(),
        'salida': salida?.toIso8601String(),
      };

  factory Asistencia.fromJson(Map<String, dynamic> json) => Asistencia(
        id: json['id'] as String,
        parteId: json['parteId'] as String,
        employeeId: json['employeeId'] as int,
        employeeNombre: json['employeeNombre'] as String,
        locationId: json['locationId'] as int,
        entrada: DateTime.parse(json['entrada'] as String),
        salida: json['salida'] == null ? null : DateTime.parse(json['salida'] as String),
      );
}

/// Actividad creada dentro de un parte, con los trabajadores asignados.
class ActividadParte {
  const ActividadParte({
    required this.id,
    required this.parteId,
    required this.activityId,
    required this.activityNombre,
    required this.locationId,
    this.productId,
    this.productNombre,
    this.productivityTypeId,
    this.productivityTypeNombre,
    this.workerIds = const [],
    required this.createdAt,
  });

  final String id;
  final String parteId;
  final int activityId;
  final String activityNombre;
  final int locationId;
  final int? productId;
  final String? productNombre;
  final int? productivityTypeId;
  final String? productivityTypeNombre;
  final List<int> workerIds;
  final DateTime createdAt;

  ActividadParte copyWith({List<int>? workerIds}) => ActividadParte(
        id: id,
        parteId: parteId,
        activityId: activityId,
        activityNombre: activityNombre,
        locationId: locationId,
        productId: productId,
        productNombre: productNombre,
        productivityTypeId: productivityTypeId,
        productivityTypeNombre: productivityTypeNombre,
        workerIds: workerIds ?? this.workerIds,
        createdAt: createdAt,
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'parteId': parteId,
        'activityId': activityId,
        'activityNombre': activityNombre,
        'locationId': locationId,
        'productId': productId,
        'productNombre': productNombre,
        'productivityTypeId': productivityTypeId,
        'productivityTypeNombre': productivityTypeNombre,
        'workerIds': workerIds,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ActividadParte.fromJson(Map<String, dynamic> json) => ActividadParte(
        id: json['id'] as String,
        parteId: json['parteId'] as String,
        activityId: json['activityId'] as int,
        activityNombre: json['activityNombre'] as String,
        locationId: json['locationId'] as int,
        productId: json['productId'] as int?,
        productNombre: json['productNombre'] as String?,
        productivityTypeId: json['productivityTypeId'] as int?,
        productivityTypeNombre: json['productivityTypeNombre'] as String?,
        workerIds: (json['workerIds'] as List<dynamic>? ?? []).cast<int>(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// Registro de productividad de un trabajador dentro de una actividad.
class ProductividadRegistro {
  const ProductividadRegistro({
    required this.id,
    required this.actividadParteId,
    required this.employeeId,
    required this.employeeNombre,
    required this.cantidad,
    required this.hora,
    this.productId,
    this.productivityTypeId,
  });

  final String id;
  final String actividadParteId;
  final int employeeId;
  final String employeeNombre;
  final double cantidad;
  final DateTime hora;
  final int? productId;
  final int? productivityTypeId;

  Map<String, Object?> toJson() => {
        'id': id,
        'actividadParteId': actividadParteId,
        'employeeId': employeeId,
        'employeeNombre': employeeNombre,
        'cantidad': cantidad,
        'hora': hora.toIso8601String(),
        'productId': productId,
        'productivityTypeId': productivityTypeId,
      };

  factory ProductividadRegistro.fromJson(Map<String, dynamic> json) => ProductividadRegistro(
        id: json['id'] as String,
        actividadParteId: json['actividadParteId'] as String,
        employeeId: json['employeeId'] as int,
        employeeNombre: json['employeeNombre'] as String,
        cantidad: (json['cantidad'] as num).toDouble(),
        hora: DateTime.parse(json['hora'] as String),
        productId: json['productId'] as int?,
        productivityTypeId: json['productivityTypeId'] as int?,
      );
}

/// El parte (jornada) del lider: agrupa asistencia + actividades +
/// productividad. Se cierra localmente y, al cerrarse, todo su contenido se
/// traduce a tickages/productivity_logs reales para el outbox.
class TareoParte {
  const TareoParte({
    required this.id,
    required this.locationId,
    required this.locationNombre,
    required this.fecha,
    required this.horaInicio,
    this.horaFin,
    this.observacion,
    this.campaignId,
    required this.estado,
  });

  final String id;
  final int locationId;
  final String locationNombre;
  final DateTime fecha;
  final DateTime horaInicio;
  final DateTime? horaFin;
  final String? observacion;
  final int? campaignId;
  final ParteEstado estado;

  TareoParte copyWith({DateTime? horaFin, ParteEstado? estado}) => TareoParte(
        id: id,
        locationId: locationId,
        locationNombre: locationNombre,
        fecha: fecha,
        horaInicio: horaInicio,
        horaFin: horaFin ?? this.horaFin,
        observacion: observacion,
        campaignId: campaignId,
        estado: estado ?? this.estado,
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'locationId': locationId,
        'locationNombre': locationNombre,
        'fecha': fecha.toIso8601String(),
        'horaInicio': horaInicio.toIso8601String(),
        'horaFin': horaFin?.toIso8601String(),
        'observacion': observacion,
        'campaignId': campaignId,
        'estado': estado.name,
      };

  factory TareoParte.fromJson(Map<String, dynamic> json) => TareoParte(
        id: json['id'] as String,
        locationId: json['locationId'] as int,
        locationNombre: json['locationNombre'] as String,
        fecha: DateTime.parse(json['fecha'] as String),
        horaInicio: DateTime.parse(json['horaInicio'] as String),
        horaFin: json['horaFin'] == null ? null : DateTime.parse(json['horaFin'] as String),
        observacion: json['observacion'] as String?,
        campaignId: json['campaignId'] as int?,
        estado: ParteEstado.values.firstWhere(
          (e) => e.name == json['estado'],
          orElse: () => ParteEstado.abierto,
        ),
      );
}
