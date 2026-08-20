import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/erp_api_client.dart';
import '../../core/sp/stored_procedure_contract.dart';
import '../models/outbox_event.dart';
import '../models/sync_status.dart';
import 'audit_repository.dart';

/// Cola local de tareos pendientes de envio (outbox pattern) con
/// idempotencia por `temp_id`. Persiste en SharedPreferences para
/// sobrevivir cierres de la app (offline-first).
class OutboxRepository extends ChangeNotifier {
  OutboxRepository._();

  static final instance = OutboxRepository._();

  static const _prefsKey = 'agrotareo_outbox_v1';

  List<OutboxEvent> _events = [];
  bool isSyncing = false;
  String? lastError;

  List<OutboxEvent> get events => List.unmodifiable(_events);

  int get pendingCount => _events.where((e) => e.status != SyncStatus.sent).length;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefsKey) ?? [];
    _events = raw
        .map((s) {
          try {
            return OutboxEvent.fromJson(jsonDecode(s) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<OutboxEvent>()
        .toList();
    notifyListeners();
  }

  Future<void> enqueue(OutboxEvent event) async {
    _events.insert(0, event);
    await _persist();
    notifyListeners();
  }

  /// Envia todos los eventos pendientes via CLI547_AGM_MOBILE_SYNC_INSERT.
  /// Devuelve la cantidad de tickajes insertados en el servidor.
  Future<int> syncPending(ErpApiClient api) async {
    final pending = _events.where((e) => e.status != SyncStatus.sent).toList();
    if (pending.isEmpty) return 0;

    isSyncing = true;
    lastError = null;
    notifyListeners();
    try {
      final tickages = pending.map((e) => e.toTickageJson()).toList();
      final logs = pending.expand((e) => e.toProductivityLogJsonList()).toList();
      final raw = await api.ejecutarSPRaw(
        nombreSP: StoredProcedureContract.syncInsert,
        parametros: StoredProcedureContract.syncInsertParams(
          tickages: tickages,
          productivityLogs: logs,
        ),
      );
      final rows = ErpApiClient.asRows(raw);
      final resultado = rows.isNotEmpty ? rows.first['Resultado']?.toString() : null;

      if (resultado == 'ERROR') {
        final message = rows.first['ErrorMensaje']?.toString() ?? 'Error desconocido del servidor';
        lastError = message;
        for (final e in pending) {
          _markEvent(e.tempId, status: SyncStatus.failed, errorMessage: message);
        }
        await _persist();
        await AuditRepository.instance.log(
          table: 'ControlRoute_tickage',
          operation: 'INSERT',
          status: 'ERROR',
          watermark: 0,
        );
        return 0;
      }

      final inserted = rows.isNotEmpty ? (_toInt(rows.first['TickagesInsertados']) ?? pending.length) : pending.length;
      for (final e in pending) {
        _markEvent(e.tempId, status: SyncStatus.sent, attempts: e.attempts + 1);
      }
      await _persist();
      await AuditRepository.instance.log(
        table: 'ControlRoute_tickage',
        operation: 'INSERT',
        status: 'OK',
        watermark: inserted,
      );
      return inserted;
    } catch (e) {
      lastError = e.toString();
      for (final ev in pending) {
        _markEvent(ev.tempId, status: SyncStatus.failed, attempts: ev.attempts + 1, errorMessage: lastError);
      }
      await _persist();
      rethrow;
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  void _markEvent(String tempId, {SyncStatus? status, int? attempts, String? errorMessage}) {
    final index = _events.indexWhere((e) => e.tempId == tempId);
    if (index == -1) return;
    _events[index] = _events[index].copyWith(status: status, attempts: attempts, errorMessage: errorMessage);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _events.map((e) => jsonEncode(e.toJson())).toList());
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
