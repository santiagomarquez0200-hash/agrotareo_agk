import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/backup_snapshot.dart';
import 'master_data_repository.dart';
import 'outbox_repository.dart';

/// Snapshots locales del cache de catalogos + outbox, con checksum real
/// (sha256) sobre el contenido serializado. Se guardan en SharedPreferences.
class BackupRepository extends ChangeNotifier {
  BackupRepository._();

  static final instance = BackupRepository._();

  static const _prefsKey = 'agrotareo_backups_v1';
  static const _maxSnapshots = 10;

  List<BackupSnapshot> snapshots = [];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefsKey) ?? [];
    snapshots = raw
        .map((s) {
          try {
            return BackupSnapshot.fromJson(jsonDecode(s) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<BackupSnapshot>()
        .toList();
    notifyListeners();
  }

  Future<BackupSnapshot> createSnapshot() async {
    final master = MasterDataRepository.instance;
    final outbox = OutboxRepository.instance;

    final payload = jsonEncode({
      'activities': master.activities.map((a) => a.toRow()).toList(),
      'employees': master.employees.map((e) => e.toRow()).toList(),
      'locations': master.locations.map((l) => l.toRow()).toList(),
      'lots': master.lots.map((l) => l.toRow()).toList(),
      'outbox': outbox.events.map((e) => e.toJson()).toList(),
      'takenAt': DateTime.now().toIso8601String(),
    });

    final bytes = utf8.encode(payload);
    final checksum = 'sha256:${sha256.convert(bytes).toString().substring(0, 12)}';
    final records = master.activities.length +
        master.employees.length +
        master.locations.length +
        master.lots.length +
        outbox.events.length;
    final name =
        'backup_agrotareo_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.json';

    final snapshot = BackupSnapshot(
      name: name,
      records: records,
      sizeMb: bytes.length / (1024 * 1024),
      createdAt: DateTime.now(),
      checksum: checksum,
    );

    snapshots.insert(0, snapshot);
    if (snapshots.length > _maxSnapshots) {
      snapshots = snapshots.sublist(0, _maxSnapshots);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, snapshots.map((s) => jsonEncode(s.toJson())).toList());
    notifyListeners();
    return snapshot;
  }
}
