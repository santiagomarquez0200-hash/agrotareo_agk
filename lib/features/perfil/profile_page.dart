import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/config/app_environment.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/services/app_services.dart';
import '../../core/theme/agro_theme.dart';
import '../../data/repositories/backup_repository.dart';
import '../../data/repositories/master_data_repository.dart';
import '../../shared/widgets/env_switcher_sheet.dart';
import '../../shared/widgets/section_title.dart';
import '../../shared/widgets/settings_tile.dart';
import '../../shared/widgets/status_pill.dart';
import '../personal/people_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _syncing = false;

  Future<void> _syncCatalogs() async {
    if (_syncing) return;
    setState(() => _syncing = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await AppServices.instance.syncMasterCatalogs();
      messenger.showSnackBar(const SnackBar(content: Text('Catalogos sincronizados correctamente.')));
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('No se pudo sincronizar: $e')));
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AppServices.instance.currentUser;
    return AnimatedBuilder(
      animation: Listenable.merge([MasterDataRepository.instance, BackupRepository.instance]),
      builder: (context, _) {
        final master = MasterDataRepository.instance;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundColor: AgroTheme.secondaryContainer,
                          child: Text(
                            user?.initials ?? '?',
                            style: const TextStyle(color: AgroTheme.primary, fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.displayName ?? 'Sin sesion',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                              ),
                              Text(user?.puestoTrabajo ?? user?.username ?? ''),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  StatusPill(
                                    label: AppEnvironment.currentLabel,
                                    ok: AppEnvironment.current == AppEnv.produccion,
                                  ),
                                  if (user?.estado != null) StatusPill(label: user!.estado!, ok: user.estado == 'Activo'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Cambiar entorno',
                          onPressed: () => showEnvSwitcherSheet(context),
                          icon: const Icon(Icons.swap_horiz_rounded),
                        ),
                      ],
                    ),
                    if (user != null && (user.sede != null || user.fundo != null || user.dni != null)) ...[
                      const Divider(height: 24),
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          if (user.dni != null) _infoChip(Icons.badge_rounded, 'DNI', user.dni!),
                          if (user.sede != null) _infoChip(Icons.location_city_rounded, 'Sede', user.sede!),
                          if (user.fundo != null) _infoChip(Icons.agriculture_rounded, 'Fundo', user.fundo!),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(child: SectionTitle('Sincronizacion y catalogos')),
                FilledButton.icon(
                  onPressed: _syncing ? null : _syncCatalogs,
                  icon: _syncing
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.sync_rounded),
                  label: const Text('Sincronizar'),
                ),
              ],
            ),
            SettingsTile(
              icon: master.hasData ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
              title: master.hasData ? 'Catalogos disponibles' : 'Sin catalogos locales',
              subtitle: master.lastSyncAt != null
                  ? 'Ultima sinc: ${DateFormat('dd/MM/yyyy HH:mm').format(master.lastSyncAt!)}'
                  : 'Aun no se ha sincronizado',
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Detalle de catalogos', style: TextStyle(fontWeight: FontWeight.w800)),
                        const Spacer(),
                        if (master.rawTableCount > 0)
                          Text('${master.rawTableCount} tablas recibidas', style: const TextStyle(fontSize: 12, color: AgroTheme.textDim)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (master.diagnostics.isEmpty)
                      const Text('Sincroniza para ver el detalle de cada catalogo.')
                    else
                      for (final d in master.diagnostics)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Icon(
                                d.loaded ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                                size: 16,
                                color: d.loaded ? AgroTheme.secondary : AgroTheme.danger,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(d.label)),
                              Text('${d.count}', style: const TextStyle(fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SettingsTile(
              icon: Icons.people_alt_rounded,
              title: 'Directorio de personal',
              subtitle: '${master.employees.length} trabajadores sincronizados. Buscar por codigo, nombre o DNI.',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const PeoplePage()),
              ),
            ),
            const SettingsTile(
              icon: Icons.offline_pin_rounded,
              title: 'Mapa offline',
              subtitle: 'Sublotes, WKT, centroides y colores por cultivo (cache local)',
            ),
            const SettingsTile(
              icon: Icons.history_rounded,
              title: 'Outbox local',
              subtitle: 'Cola de tareos con idempotencia, persistida en el dispositivo',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(child: SectionTitle('Backups de informacion')),
                TextButton.icon(
                  onPressed: () => BackupRepository.instance.createSnapshot(),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Generar'),
                ),
              ],
            ),
            if (BackupRepository.instance.snapshots.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Sin backups locales todavia.'),
                ),
              )
            else
              for (final snapshot in BackupRepository.instance.snapshots)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.backup_rounded),
                    title: Text(snapshot.name),
                    subtitle: Text(
                      '${snapshot.records} registros - ${snapshot.sizeMb.toStringAsFixed(2)} MB - ${snapshot.checksum}',
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }

  Widget _infoChip(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AgroTheme.textDim),
        const SizedBox(width: 6),
        Text('$label: ', style: const TextStyle(color: AgroTheme.textDim)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
