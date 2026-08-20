import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/agro_theme.dart';
import '../../data/models/parte.dart';
import '../../data/models/sync_status.dart';
import '../../data/repositories/audit_repository.dart';
import '../../data/repositories/outbox_repository.dart';
import '../../data/repositories/tareo_repository.dart';
import '../../shared/widgets/event_tile.dart';
import '../../shared/widgets/section_title.dart';
import '../../shared/widgets/status_pill.dart';

enum _Filtro { todos, pendiente, enviado, error }

class HistoryPage extends StatefulWidget {
  const HistoryPage({required this.onSync, super.key});

  final VoidCallback onSync;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  _Filtro _filtro = _Filtro.todos;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([OutboxRepository.instance, AuditRepository.instance, TareoRepository.instance]),
      builder: (context, _) {
        final outbox = OutboxRepository.instance;
        final tareo = TareoRepository.instance;
        final events = outbox.events.where((e) {
          return switch (_filtro) {
            _Filtro.todos => true,
            _Filtro.pendiente => e.status == SyncStatus.pending,
            _Filtro.enviado => e.status == SyncStatus.sent,
            _Filtro.error => e.status == SyncStatus.failed,
          };
        }).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Row(
              children: [
                const Expanded(child: SectionTitle('Historial')),
                FilledButton.icon(
                  onPressed: outbox.pendingCount == 0 || outbox.isSyncing ? null : widget.onSync,
                  icon: outbox.isSyncing
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.sync_rounded),
                  label: const Text('Enviar'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final f in _Filtro.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(_label(f)),
                        selected: _filtro == f,
                        onSelected: (_) => setState(() => _filtro = f),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (outbox.lastError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  color: AgroTheme.dangerBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AgroTheme.dangerBorder),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('Ultimo error: ${outbox.lastError}', style: const TextStyle(color: Color(0xFFFCA5A5))),
                  ),
                ),
              ),
            if (events.isEmpty)
              const _HintCard(text: 'Sin tickajes en este filtro.')
            else
              for (final event in events) EventTile(event: event),
            const SizedBox(height: 20),
            const SectionTitle('Partes cerrados'),
            if (tareo.historialPartes.isEmpty)
              const _HintCard(text: 'Aun no cierras ningun parte.')
            else
              for (final parte in tareo.historialPartes) _ParteHistorialCard(parte: parte),
            const SizedBox(height: 20),
            const SectionTitle('Auditoria local'),
            if (AuditRepository.instance.rows.isEmpty)
              const _HintCard(text: 'Sin registros de auditoria todavia.')
            else
              for (final row in AuditRepository.instance.rows)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.storage_rounded),
                    title: Text('${row.table} - ${row.operation}'),
                    subtitle: Text('${row.deviceId} - ${DateFormat('dd/MM HH:mm').format(row.createdAt)}'),
                    trailing: StatusPill(label: row.status, ok: row.status == 'OK'),
                  ),
                ),
          ],
        );
      },
    );
  }

  String _label(_Filtro f) => switch (f) {
        _Filtro.todos => 'Todos',
        _Filtro.pendiente => 'Pendientes',
        _Filtro.enviado => 'Enviados',
        _Filtro.error => 'Con error',
      };
}

class _ParteHistorialCard extends StatelessWidget {
  const _ParteHistorialCard({required this.parte});

  final TareoParte parte;

  @override
  Widget build(BuildContext context) {
    final tareo = TareoRepository.instance;
    final asistencias = tareo.asistenciasDe(parte.id);
    final actividades = tareo.actividadesDe(parte.id);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.assignment_turned_in_rounded, color: AgroTheme.lime),
        title: Text(parte.locationNombre),
        subtitle: Text(
          '${DateFormat('dd/MM HH:mm').format(parte.horaInicio)} - '
          '${parte.horaFin != null ? DateFormat('HH:mm').format(parte.horaFin!) : '-'} '
          '- ${asistencias.length} trabajador(es) - ${actividades.length} actividad(es)',
        ),
        trailing: const StatusPill(label: 'CERRADO', ok: true),
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
