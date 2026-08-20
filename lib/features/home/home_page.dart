import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/errors/app_exceptions.dart';
import '../../core/services/app_services.dart';
import '../../core/theme/agro_theme.dart';
import '../../data/repositories/master_data_repository.dart';
import '../../data/repositories/outbox_repository.dart';
import '../../data/repositories/tareo_repository.dart';
import '../../shared/widgets/event_tile.dart';
import '../../shared/widgets/section_title.dart';
import '../personal/people_page.dart';
import '../shell/agro_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.onOpen, super.key});

  final ValueChanged<AgroTab> onOpen;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _syncing = false;

  Future<void> _sync() async {
    if (_syncing) return;
    setState(() => _syncing = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await AppServices.instance.syncMasterCatalogs();
      messenger.showSnackBar(const SnackBar(content: Text('Catalogos actualizados.')));
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
      animation: Listenable.merge([
        MasterDataRepository.instance,
        OutboxRepository.instance,
        TareoRepository.instance,
      ]),
      builder: (context, _) {
        final master = MasterDataRepository.instance;
        final outbox = OutboxRepository.instance;
        final tareo = TareoRepository.instance;
        final hour = DateTime.now().hour;
        final saludo = hour < 12 ? 'Buenos dias' : (hour < 19 ? 'Buenas tardes' : 'Buenas noches');

        return RefreshIndicator(
          onRefresh: _sync,
          color: AgroTheme.lime,
          backgroundColor: AgroTheme.card,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              Text(
                '$saludo, ${user?.displayName ?? ''}',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat("EEEE d 'de' MMMM", 'es').format(DateTime.now()),
                style: const TextStyle(color: AgroTheme.textDim, fontSize: 13),
              ),
              const SizedBox(height: 16),
              _StatusCard(master: master, syncing: _syncing, onSync: _sync),
              const SizedBox(height: 16),
              _KpiGrid(tareo: tareo),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: MediaQuery.sizeOf(context).width > 680 ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
                children: [
                  _ShortcutCard(
                    icon: Icons.task_alt_rounded,
                    title: 'Tareo',
                    subtitle: tareo.parteActivo != null ? 'Parte abierto' : '${master.activities.length} actividades',
                    onTap: () => widget.onOpen(AgroTab.tareo),
                    highlighted: tareo.parteActivo != null,
                  ),
                  _ShortcutCard(
                    icon: Icons.satellite_alt_rounded,
                    title: 'Mapa',
                    subtitle: '${master.lots.length} sublotes ERP',
                    onTap: () => widget.onOpen(AgroTab.mapa),
                  ),
                  _ShortcutCard(
                    icon: Icons.history_rounded,
                    title: 'Historial',
                    subtitle: '${outbox.pendingCount} envios pendientes',
                    onTap: () => widget.onOpen(AgroTab.historial),
                  ),
                  _ShortcutCard(
                    icon: Icons.people_alt_rounded,
                    title: 'Personal',
                    subtitle: '${master.employees.length} trabajadores',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const PeoplePage()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const SectionTitle('Ultimos sincronizados'),
              if (outbox.events.where((e) => e.status.name == 'sent').isEmpty)
                const _HintCard(text: 'Aun no hay tickajes enviados al servidor.')
              else
                for (final event in outbox.events.where((e) => e.status.name == 'sent').take(5))
                  GestureDetector(
                    onTap: () => widget.onOpen(AgroTab.historial),
                    child: EventTile(event: event),
                  ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.master, required this.syncing, required this.onSync});

  final MasterDataRepository master;
  final bool syncing;
  final VoidCallback onSync;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AgroTheme.primaryContainer, AgroTheme.card],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AgroTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                master.hasData ? Icons.verified_rounded : Icons.cloud_off_rounded,
                color: AgroTheme.lime,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  master.hasData ? 'Modo Online - catalogos listos' : 'Sin catalogos locales',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17),
                ),
              ),
              IconButton(
                tooltip: 'Sincronizar catalogos',
                onPressed: syncing ? null : onSync,
                icon: syncing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AgroTheme.lime),
                      )
                    : const Icon(Icons.sync_rounded, color: AgroTheme.lime),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            master.lastSyncAt != null
                ? 'Ultima sincronizacion: hace ${_hace(master.lastSyncAt!)}'
                : 'Desliza hacia abajo o toca sincronizar para descargar los catalogos.',
            style: const TextStyle(color: AgroTheme.textDim, height: 1.35, fontSize: 12.5),
          ),
        ],
      ),
    );
  }

  String _hace(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'instantes';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours} h';
    return '${diff.inDays} d';
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.tareo});

  final TareoRepository tareo;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.groups_rounded, '${tareo.trabajadoresActivosHoy}', 'Trabajadores activos', AgroTheme.success),
      (Icons.assignment_rounded, '${tareo.partesAbiertosCount}', 'Partes abiertos', AgroTheme.lime),
      (Icons.task_alt_rounded, '${tareo.actividadesCreadasHoy}', 'Actividades hoy', AgroTheme.warning),
      (Icons.trending_up_rounded, _fmt(tareo.productividadTotalHoy), 'Productividad hoy', AgroTheme.lime),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: [
        for (final (icon, value, label, color) in items)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AgroTheme.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AgroTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 20),
                const Spacer(),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                Text(label, style: const TextStyle(color: AgroTheme.textDim, fontSize: 11)),
              ],
            ),
          ),
      ],
    );
  }

  String _fmt(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: highlighted ? AgroTheme.lime : AgroTheme.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AgroTheme.lime, size: 28),
              const Spacer(),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AgroTheme.textDim, fontSize: 12),
              ),
            ],
          ),
        ),
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
