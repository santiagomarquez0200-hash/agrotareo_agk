import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;

import '../../core/errors/app_exceptions.dart';
import '../../core/services/app_services.dart';
import '../../core/theme/agro_theme.dart';
import '../../data/models/field_lot.dart';
import '../../data/repositories/master_data_repository.dart';

/// Mapa satelital de sublotes ERP: capa Esri World Imagery + poligonos
/// reales parseados de `GeometriaWKT`, con filtro por cultivo/variedad y
/// ficha de detalle al tocar un lote.
///
/// Nota: la capa satelital usa el servicio publico Esri World Imagery (sin
/// API key). Si mas adelante hay una cuenta de Google Maps / Mapbox, solo
/// hay que cambiar `_tileUrlTemplate` mas abajo.
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

const _tileUrlTemplate =
    'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

class _MapPageState extends State<MapPage> {
  final _mapController = MapController();
  bool _requestedAutoLoad = false;
  bool _boundsFitted = false;
  final Set<String> _selectedCrops = {};
  final Set<String> _selectedVarieties = {};
  bool _filtersExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: MasterDataRepository.instance,
      builder: (context, _) {
        final master = MasterDataRepository.instance;
        final lots = master.lots;
        final idSede = AppServices.instance.currentUser?.idSede;

        if (!_requestedAutoLoad && idSede != null && lots.isEmpty && !master.isSyncing) {
          _requestedAutoLoad = true;
          WidgetsBinding.instance.addPostFrameCallback((_) => _actualizar(context));
        }

        final crops = {for (final l in lots) l.crop}.where((c) => c.isNotEmpty).toList()..sort();
        if (_selectedCrops.isEmpty && crops.isNotEmpty) _selectedCrops.addAll(crops);

        final varieties = {
          for (final l in lots)
            if (_selectedCrops.contains(l.crop) && (l.variety ?? '').isNotEmpty) l.variety!,
        }.toList()
          ..sort();
        if (_selectedVarieties.isEmpty && varieties.isNotEmpty) _selectedVarieties.addAll(varieties);

        final visibleLots = lots.where((l) {
          if (!_selectedCrops.contains(l.crop)) return false;
          if ((l.variety ?? '').isNotEmpty && !_selectedVarieties.contains(l.variety)) return false;
          return true;
        }).toList();

        if (idSede == null) {
          return const _MissingSedeNotice();
        }

        if (lots.isEmpty) {
          return _EmptyMap(loading: master.isSyncing, onRetry: () => _actualizar(context));
        }

        final polygons = <_LotPolygon>[
          for (final lot in visibleLots)
            for (final ring in parseWktPolygons(lot.wkt))
              _LotPolygon(lot: lot, points: ring.map((o) => ll.LatLng(o.dy, o.dx)).toList()),
        ];

        if (!_boundsFitted && polygons.isNotEmpty) {
          _boundsFitted = true;
          WidgetsBinding.instance.addPostFrameCallback((_) => _fitBounds(polygons));
        }

        return Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _initialCenter(visibleLots),
                initialZoom: 15,
                minZoom: 3,
                maxZoom: 19,
                onTap: (tapPosition, point) => _handleTap(point, polygons),
              ),
              children: [
                TileLayer(
                  urlTemplate: _tileUrlTemplate,
                  userAgentPackageName: 'pe.agrokasa.agrotareo_agk',
                  maxZoom: 19,
                ),
                if (polygons.isNotEmpty)
                  PolygonLayer(
                    polygons: [
                      for (final p in polygons)
                        Polygon(
                          points: p.points,
                          color: p.lot.color.withValues(alpha: 0.38),
                          borderColor: p.lot.color,
                          borderStrokeWidth: 2,
                        ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    for (final lot in visibleLots)
                      if (lot.lat != null && lot.long != null)
                        Marker(
                          point: ll.LatLng(lot.lat!, lot.long!),
                          width: 26,
                          height: 26,
                          child: GestureDetector(
                            onTap: () => _showLotDetail(context, lot),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: lot.color,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
                const RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution('Esri World Imagery'),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: _TopBar(
                sede: AppServices.instance.currentUser?.sede ?? idSede.toString(),
                lotCount: visibleLots.length,
                syncing: master.isSyncing,
                onSync: () => _actualizar(context),
                expanded: _filtersExpanded,
                onToggleFilters: () => setState(() => _filtersExpanded = !_filtersExpanded),
              ),
            ),
            if (_filtersExpanded)
              Positioned(
                top: 66,
                left: 12,
                right: 12,
                child: _FiltersPanel(
                  crops: crops,
                  selectedCrops: _selectedCrops,
                  varieties: varieties,
                  selectedVarieties: _selectedVarieties,
                  colorFor: (crop) => lots.firstWhere((l) => l.crop == crop, orElse: () => lots.first).color,
                  onToggleCrop: (crop, value) => setState(() {
                    if (value) {
                      _selectedCrops.add(crop);
                    } else {
                      _selectedCrops.remove(crop);
                    }
                  }),
                  onToggleVariety: (v, value) => setState(() {
                    if (value) {
                      _selectedVarieties.add(v);
                    } else {
                      _selectedVarieties.remove(v);
                    }
                  }),
                ),
              ),
            Positioned(
              right: 12,
              bottom: 12,
              child: Column(
                children: [
                  _MapFab(icon: Icons.add_rounded, onTap: () => _zoomBy(1)),
                  const SizedBox(height: 8),
                  _MapFab(icon: Icons.remove_rounded, onTap: () => _zoomBy(-1)),
                  const SizedBox(height: 8),
                  _MapFab(
                    icon: Icons.center_focus_strong_rounded,
                    onTap: () => polygons.isNotEmpty ? _fitBounds(polygons) : null,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  ll.LatLng _initialCenter(List<FieldLot> lots) {
    final withCoords = lots.where((l) => l.lat != null && l.long != null).toList();
    if (withCoords.isEmpty) return const ll.LatLng(-9.19, -75.02); // centro aprox. Peru
    return ll.LatLng(withCoords.first.lat!, withCoords.first.long!);
  }

  void _zoomBy(double delta) {
    final camera = _mapController.camera;
    _mapController.move(camera.center, (camera.zoom + delta).clamp(3, 19));
  }

  void _fitBounds(List<_LotPolygon> polygons) {
    final points = polygons.expand((p) => p.points).toList();
    if (points.isEmpty) return;
    final bounds = LatLngBounds.fromPoints(points);
    _mapController.fitCamera(CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(48)));
  }

  void _handleTap(ll.LatLng point, List<_LotPolygon> polygons) {
    for (final polygon in polygons) {
      if (_pointInPolygon(point, polygon.points)) {
        _showLotDetail(context, polygon.lot);
        return;
      }
    }
  }

  bool _pointInPolygon(ll.LatLng point, List<ll.LatLng> polygon) {
    var inside = false;
    for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      final xi = polygon[i].longitude, yi = polygon[i].latitude;
      final xj = polygon[j].longitude, yj = polygon[j].latitude;
      final intersects = ((yi > point.latitude) != (yj > point.latitude)) &&
          (point.longitude < (xj - xi) * (point.latitude - yi) / (yj - yi) + xi);
      if (intersects) inside = !inside;
    }
    return inside;
  }

  void _showLotDetail(BuildContext context, FieldLot lot) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(backgroundColor: lot.color, radius: 12),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      lot.name.isEmpty ? '(sin nombre)' : lot.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _detailRow('Cultivo', lot.crop.isEmpty ? '-' : lot.crop),
              _detailRow('Variedad', lot.variety ?? '-'),
              _detailRow('Sede', lot.location.isEmpty ? '-' : lot.location),
              _detailRow('Hectareas', lot.hectares.toStringAsFixed(2)),
              _detailRow('Version ERP', 'v${lot.version}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(color: AgroTheme.textDim))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  Future<void> _actualizar(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      _boundsFitted = false;
      await AppServices.instance.syncMasterCatalogs();
      if (MasterDataRepository.instance.lots.isEmpty) {
        messenger.showSnackBar(const SnackBar(content: Text('No se encontraron sublotes para tu sede.')));
      }
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('No se pudo cargar el mapa: $e')));
    }
  }
}

class _LotPolygon {
  const _LotPolygon({required this.lot, required this.points});
  final FieldLot lot;
  final List<ll.LatLng> points;
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.sede,
    required this.lotCount,
    required this.syncing,
    required this.onSync,
    required this.expanded,
    required this.onToggleFilters,
  });

  final String sede;
  final int lotCount;
  final bool syncing;
  final VoidCallback onSync;
  final bool expanded;
  final VoidCallback onToggleFilters;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AgroTheme.card.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AgroTheme.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.satellite_alt_rounded, color: AgroTheme.lime, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Sede $sede - $lotCount sublote(s)',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            tooltip: 'Filtros',
            onPressed: onToggleFilters,
            icon: Icon(
              expanded ? Icons.filter_alt_rounded : Icons.filter_alt_outlined,
              color: AgroTheme.lime,
              size: 20,
            ),
          ),
          IconButton(
            tooltip: 'Actualizar',
            onPressed: syncing ? null : onSync,
            icon: syncing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AgroTheme.lime),
                  )
                : const Icon(Icons.refresh_rounded, color: AgroTheme.lime, size: 20),
          ),
        ],
      ),
    );
  }
}

class _FiltersPanel extends StatelessWidget {
  const _FiltersPanel({
    required this.crops,
    required this.selectedCrops,
    required this.varieties,
    required this.selectedVarieties,
    required this.colorFor,
    required this.onToggleCrop,
    required this.onToggleVariety,
  });

  final List<String> crops;
  final Set<String> selectedCrops;
  final List<String> varieties;
  final Set<String> selectedVarieties;
  final Color Function(String crop) colorFor;
  final void Function(String crop, bool value) onToggleCrop;
  final void Function(String variety, bool value) onToggleVariety;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AgroTheme.card.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AgroTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cultivo', style: TextStyle(color: AgroTheme.textDim, fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final crop in crops)
                FilterChip(
                  label: Text(crop),
                  selected: selectedCrops.contains(crop),
                  avatar: CircleAvatar(backgroundColor: colorFor(crop), radius: 6),
                  onSelected: (v) => onToggleCrop(crop, v),
                ),
            ],
          ),
          if (varieties.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('Variedad', style: TextStyle(color: AgroTheme.textDim, fontSize: 11, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final variety in varieties)
                  FilterChip(
                    label: Text(variety),
                    selected: selectedVarieties.contains(variety),
                    onSelected: (v) => onToggleVariety(variety, v),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MapFab extends StatelessWidget {
  const _MapFab({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AgroTheme.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AgroTheme.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: SizedBox(width: 40, height: 40, child: Icon(icon, color: AgroTheme.lime, size: 20)),
      ),
    );
  }
}

class _MissingSedeNotice extends StatelessWidget {
  const _MissingSedeNotice();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'No se pudo determinar tu sede al iniciar sesion, asi que el mapa no puede '
          'cargarse automaticamente. Vuelve a iniciar sesion o contacta a soporte.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AgroTheme.textDim),
        ),
      ),
    );
  }
}

class _EmptyMap extends StatelessWidget {
  const _EmptyMap({required this.loading, required this.onRetry});

  final bool loading;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(loading ? Icons.satellite_alt_rounded : Icons.map_outlined, color: AgroTheme.textDim, size: 40),
            const SizedBox(height: 12),
            Text(
              loading ? 'Cargando sublotes de tu sede...' : 'Aun no hay sublotes para tu sede en el ERP.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AgroTheme.textDim),
            ),
            if (!loading) ...[
              const SizedBox(height: 12),
              FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('Reintentar')),
            ],
          ],
        ),
      ),
    );
  }
}
