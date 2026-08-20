import 'package:flutter/material.dart';

import '../../core/theme/agro_theme.dart';
import '../../data/models/outbox_event.dart';
import '../../data/models/sync_status.dart';
import 'status_pill.dart';

class EventTile extends StatelessWidget {
  const EventTile({required this.event, super.key});

  final OutboxEvent event;

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = switch (event.status) {
      SyncStatus.sent => (Icons.cloud_done_rounded, AgroTheme.success, 'Enviado'),
      SyncStatus.failed => (Icons.cloud_off_rounded, AgroTheme.danger, 'Error'),
      SyncStatus.pending => (Icons.cloud_upload_rounded, AgroTheme.warning, 'Pendiente'),
    };
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(event.activity),
        subtitle: Text(
          '${event.worker} - ${event.location} - ${_formatTime(event.createdAt)}'
          '${event.status == SyncStatus.failed && event.errorMessage != null ? '\n${event.errorMessage}' : ''}',
        ),
        isThreeLine: event.status == SyncStatus.failed && event.errorMessage != null,
        trailing: StatusPill(label: label, ok: event.status == SyncStatus.sent),
      ),
    );
  }
}

String _formatTime(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
