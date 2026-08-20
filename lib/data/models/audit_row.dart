class AuditRow {
  const AuditRow({
    required this.table,
    required this.operation,
    required this.status,
    required this.watermark,
    required this.deviceId,
    required this.createdAt,
  });

  final String table;
  final String operation;
  final String status;
  final int watermark;
  final String deviceId;
  final DateTime createdAt;

  Map<String, Object?> toJson() => {
        'table': table,
        'operation': operation,
        'status': status,
        'watermark': watermark,
        'deviceId': deviceId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory AuditRow.fromJson(Map<String, dynamic> json) => AuditRow(
        table: json['table'] as String,
        operation: json['operation'] as String,
        status: json['status'] as String,
        watermark: json['watermark'] as int? ?? 0,
        deviceId: json['deviceId'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
