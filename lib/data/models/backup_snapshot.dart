class BackupSnapshot {
  const BackupSnapshot({
    required this.name,
    required this.records,
    required this.sizeMb,
    required this.createdAt,
    required this.checksum,
  });

  final String name;
  final int records;
  final double sizeMb;
  final DateTime createdAt;
  final String checksum;

  Map<String, Object?> toJson() => {
        'name': name,
        'records': records,
        'sizeMb': sizeMb,
        'createdAt': createdAt.toIso8601String(),
        'checksum': checksum,
      };

  factory BackupSnapshot.fromJson(Map<String, dynamic> json) => BackupSnapshot(
        name: json['name'] as String,
        records: json['records'] as int,
        sizeMb: (json['sizeMb'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
        checksum: json['checksum'] as String,
      );
}
