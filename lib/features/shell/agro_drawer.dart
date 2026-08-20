import 'package:flutter/material.dart';

import '../../core/services/app_services.dart';
import '../../core/theme/agro_theme.dart';
import '../../data/repositories/audit_repository.dart';
import '../../data/repositories/outbox_repository.dart';
import '../auth/login_page.dart';
import '../personal/people_page.dart';
import 'agro_tab.dart';

class AgroDrawer extends StatelessWidget {
  const AgroDrawer({required this.current, required this.onSelect, super.key});

  final AgroTab current;
  final ValueChanged<AgroTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final user = AppServices.instance.currentUser;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: AgroTheme.primaryContainer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AgroTheme.secondaryContainer,
                    child: Text(
                      user?.initials ?? '?',
                      style: const TextStyle(
                        color: AgroTheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.displayName ?? 'Sin sesion',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    user?.username ?? '',
                    style: const TextStyle(color: AgroTheme.secondaryContainer),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  for (final tab in AgroTab.values)
                    ListTile(
                      selected: current == tab,
                      leading: Icon(tab.icon),
                      title: Text(tab.label),
                      onTap: () => onSelect(tab),
                    ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.people_alt_rounded),
                    title: const Text('Personal'),
                    subtitle: const Text('Buscar por codigo, nombre o DNI'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => const PeoplePage()),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: AuditRepository.instance,
                    builder: (context, _) => ListTile(
                      leading: const Icon(Icons.storage_rounded),
                      title: const Text('Auditoria local'),
                      subtitle: Text('${AuditRepository.instance.rows.length} registros - toca para ver'),
                      onTap: () => onSelect(AgroTab.historial),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: OutboxRepository.instance,
                    builder: (context, _) => ListTile(
                      leading: const Icon(Icons.inventory_2_rounded),
                      title: const Text('Outbox offline'),
                      subtitle: Text('${OutboxRepository.instance.pendingCount} pendientes - toca para ver'),
                      onTap: () => onSelect(AgroTab.historial),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                onPressed: () async {
                  await AppServices.instance.logout();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Cerrar Sesion'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
