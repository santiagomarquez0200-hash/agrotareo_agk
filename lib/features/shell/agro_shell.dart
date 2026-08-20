import 'package:flutter/material.dart';

import '../../core/errors/app_exceptions.dart';
import '../../core/services/app_services.dart';
import '../../data/repositories/outbox_repository.dart';
import '../../shared/widgets/connectivity_banner.dart';
import '../historial/history_page.dart';
import '../home/home_page.dart';
import '../mapa/map_page.dart';
import '../perfil/profile_page.dart';
import '../scanner/scanner_page.dart';
import '../tareo/tareo_page.dart';
import 'agro_drawer.dart';
import 'agro_tab.dart';

class AgroShell extends StatefulWidget {
  const AgroShell({super.key});

  @override
  State<AgroShell> createState() => _AgroShellState();
}

class _AgroShellState extends State<AgroShell> {
  AgroTab _tab = AgroTab.inicio;
  bool _syncing = false;

  @override
  Widget build(BuildContext context) {
    final pages = {
      AgroTab.inicio: HomePage(onOpen: _openTab),
      AgroTab.tareo: TareoPage(onScan: _openScanner),
      AgroTab.mapa: const MapPage(),
      AgroTab.historial: HistoryPage(onSync: _syncPending),
      AgroTab.perfil: const ProfilePage(),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(_tab.label),
        leading: Builder(
          builder: (context) {
            return IconButton(
              tooltip: 'Menu',
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        actions: [
          AnimatedBuilder(
            animation: OutboxRepository.instance,
            builder: (context, _) {
              final pending = OutboxRepository.instance.pendingCount;
              return IconButton(
                tooltip: 'Sincronizar',
                icon: _syncing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Badge.count(
                        count: pending,
                        isLabelVisible: pending > 0,
                        child: const Icon(Icons.cloud_sync_rounded),
                      ),
                onPressed: _syncing ? null : _syncPending,
              );
            },
          ),
        ],
      ),
      drawer: AgroDrawer(current: _tab, onSelect: _openTab),
      body: Column(
        children: [
          const ConnectivityBanner(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: KeyedSubtree(key: ValueKey(_tab), child: pages[_tab]!),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab.index,
        onDestinationSelected: (index) {
          setState(() => _tab = AgroTab.values[index]);
        },
        destinations: [
          for (final tab in AgroTab.values)
            NavigationDestination(icon: Icon(tab.icon), label: tab.label),
        ],
      ),
    );
  }

  void _openTab(AgroTab tab) {
    Navigator.of(context).maybePop();
    setState(() => _tab = tab);
  }

  void _openScanner() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ScannerPage()),
    );
  }

  Future<void> _syncPending() async {
    if (_syncing) return;
    setState(() => _syncing = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final inserted = await OutboxRepository.instance.syncPending(AppServices.instance.api);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            inserted > 0
                ? '$inserted tickaje(s) enviados correctamente al servidor.'
                : 'No hay eventos pendientes por enviar.',
          ),
        ),
      );
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error al sincronizar: $e')));
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }
}
