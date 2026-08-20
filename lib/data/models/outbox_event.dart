import 'sync_status.dart';

/// Una lectura de productividad dentro de un tickage (1 trabajador puede
/// tener varias durante la misma actividad).
class ProductivityEntry {
  const ProductivityEntry({
    required this.quantity,
    required this.readtime,
    this.productId,
    this.productivityTypeId,
  });

  final double quantity;
  final DateTime readtime;
  final int? productId;
  final int? productivityTypeId;

  Map<String, Object?> toJson() => {
        'quantity': quantity,
        'readtime': readtime.toIso8601String(),
        'productId': productId,
        'productivityTypeId': productivityTypeId,
      };

  factory ProductivityEntry.fromJson(Map<String, dynamic> json) => ProductivityEntry(
        quantity: (json['quantity'] as num).toDouble(),
        readtime: DateTime.parse(json['readtime'] as String),
        productId: json['productId'] as int?,
        productivityTypeId: json['productivityTypeId'] as int?,
      );
}

/// Evento de tareo pendiente de envio: un tickage (asistencia de un
/// trabajador en una actividad, con hora de entrada/salida real) mas sus
/// lecturas de productividad. Se serializa 1:1 con las columnas que espera
/// `CLI547_AGM_MOBILE_SYNC_INSERT` para `tickages` y `productivity_logs`
/// (ver sp_agrotareo.sql).
class OutboxEvent {
  const OutboxEvent({
    required this.tempId,
    required this.worker,
    required this.employeeId,
    required this.activity,
    required this.activityId,
    required this.location,
    required this.locationId,
    required this.createdAt,
    required this.finalAt,
    required this.status,
    required this.attempts,
    this.entries = const [],
    this.errorMessage,
  });

  final String tempId;
  final String worker;
  final int employeeId;
  final String activity;
  final int activityId;
  final String location;
  final int locationId;

  /// Hora de entrada real del trabajador (columna `initial`).
  final DateTime createdAt;

  /// Hora de salida real (columna `final`).
  final DateTime finalAt;
  final SyncStatus status;
  final int attempts;
  final List<ProductivityEntry> entries;
  final String? errorMessage;

  /// Suma de todas las lecturas de productividad de este tickage.
  double get totalCantidad => entries.fold(0, (sum, e) => sum + e.quantity);

  OutboxEvent copyWith({SyncStatus? status, int? attempts, String? errorMessage}) {
    return OutboxEvent(
      tempId: tempId,
      worker: worker,
      employeeId: employeeId,
      activity: activity,
      activityId: activityId,
      location: location,
      locationId: locationId,
      createdAt: createdAt,
      finalAt: finalAt,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      entries: entries,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, Object?> toTickageJson() {
    return {
      'temp_id': tempId,
      'initial': createdAt.toIso8601String(),
      'final': finalAt.toIso8601String(),
      'state': 'OK',
      'type': 'TAREO',
      'activity_id': activityId,
      'employee_id': employeeId,
      'location_id': locationId,
      'cantidad_productividad': totalCantidad,
    };
  }

  List<Map<String, Object?>> toProductivityLogJsonList() {
    return entries
        .map((e) => {
              'tickage_temp_id': tempId,
              'readtime': e.readtime.toIso8601String(),
              'quantity': e.quantity,
              'employee_id': employeeId,
              'location_id': locationId,
              'product_id': e.productId,
              'productivity_type_id': e.productivityTypeId,
            })
        .toList();
  }

  Map<String, Object?> toJson() => {
        'tempId': tempId,
        'worker': worker,
        'employeeId': employeeId,
        'activity': activity,
        'activityId': activityId,
        'location': location,
        'locationId': locationId,
        'createdAt': createdAt.toIso8601String(),
        'finalAt': finalAt.toIso8601String(),
        'status': status.name,
        'attempts': attempts,
        'entries': entries.map((e) => e.toJson()).toList(),
        'errorMessage': errorMessage,
      };

  factory OutboxEvent.fromJson(Map<String, dynamic> json) => OutboxEvent(
        tempId: json['tempId'] as String,
        worker: json['worker'] as String,
        employeeId: json['employeeId'] as int? ?? 0,
        activity: json['activity'] as String,
        activityId: json['activityId'] as int? ?? 0,
        location: json['location'] as String,
        locationId: json['locationId'] as int? ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
        finalAt: json['finalAt'] != null
            ? DateTime.parse(json['finalAt'] as String)
            : DateTime.parse(json['createdAt'] as String).add(const Duration(minutes: 1)),
        status: SyncStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => SyncStatus.pending,
        ),
        attempts: json['attempts'] as int? ?? 0,
        entries: (json['entries'] as List<dynamic>? ?? [])
            .map((e) => ProductivityEntry.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        errorMessage: json['errorMessage'] as String?,
      );
}
