import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/storage/session_storage.dart';
import '../models/audit_row.dart';

/// Auditoria local de operaciones de sincronizacion (envios, deltas de
/// catalogos). Persiste en SharedPreferences, ultimas 100 filas.
class AuditRepository extends ChangeNotifier {
  AuditRepository._();

  static final instance = AuditRepository._();

  static const _prefsKey = 'agrotareo_audit_v1';
  static const _maxRows = 100;

  List<AuditRow> rows = [];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefsKey) ?? [];
    rows = raw
        .map((s) {
          try {
            return AuditRow.fromJson(jsonDecode(s) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<AuditRow>()
        .toList();
    notifyListeners();
  }

  Future<void> log({
    required String table,
    required String operation,
    required String status,
    required int watermark,
  }) async {
    final deviceId = await SessionStorage.deviceId();
    rows.insert(
      0,
      AuditRow(
        table: table,
        operation: operation,
        status: status,
        watermark: watermark,
        deviceId: deviceId,
        createdAt: DateTime.now(),
      ),
    );
    if (rows.length > _maxRows) {
      rows = rows.sublist(0, _maxRows);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, rows.map((r) => jsonEncode(r.toJson())).toList());
    notifyListeners();
  }
}
