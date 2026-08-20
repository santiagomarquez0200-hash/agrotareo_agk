import 'package:flutter/material.dart';

/// Sublote ERP (resultset de sublotes de CLI547_AGM_MOBILE_MASTER_SYNC,
/// solo presente cuando se envian @IdSede y @IdCultivo).
class FieldLot {
  const FieldLot({
    required this.id,
    required this.name,
    required this.crop,
    required this.location,
    required this.color,
    required this.hectares,
    required this.version,
    required this.center,
    this.lat,
    this.long,
    this.wkt,
    this.variety,
  });

  final int id;
  final String name;
  final String crop;
  final String location;
  final Color color;
  final double hectares;
  final int version;

  /// Posicion normalizada 0..1 dentro del mapa (ver [normalizeLots]).
  final Offset center;
  final double? lat;
  final double? long;
  final String? wkt;
  final String? variety;

  factory FieldLot.fromRow(Map<String, dynamic> row) {
    final colorHex = (row['ColorCultivo'] ?? '#95A5A6').toString();
    return FieldLot(
      id: _toInt(row['Id']) ?? _toInt(row['Id_Sublote']) ?? 0,
      name: (row['NombreSublote'] ?? row['Nombre_Lote'] ?? '').toString(),
      crop: (row['NombreCultivo'] ?? '').toString(),
      location: (row['NombreSede'] ?? row['Nombre_Lote'] ?? '').toString(),
      color: _colorFromHex(colorHex),
      hectares: _toDouble(row['HectareasLote']) ?? 0,
      version: _toInt(row['Version']) ?? 0,
      center: Offset.zero,
      lat: _toDouble(row['LatitudCentro']),
      long: _toDouble(row['LongitudCentro']),
      wkt: row['GeometriaWKT']?.toString(),
      variety: row['NombreVariedad']?.toString(),
    );
  }

  FieldLot withCenter(Offset center) => FieldLot(
        id: id,
        name: name,
        crop: crop,
        location: location,
        color: color,
        hectares: hectares,
        version: version,
        center: center,
        lat: lat,
        long: long,
        wkt: wkt,
        variety: variety,
      );

  Map<String, dynamic> toRow() => {
        'Id': id,
        'Id_Sublote': id,
        'NombreSublote': name,
        'NombreCultivo': crop,
        'NombreSede': location,
        'ColorCultivo': '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}',
        'HectareasLote': hectares,
        'Version': version,
        'LatitudCentro': lat,
        'LongitudCentro': long,
        'GeometriaWKT': wkt,
        'NombreVariedad': variety,
      };
}

/// Parsea el WKT que devuelve `STAsText()` (POLYGON / MULTIPOLYGON, con
/// orden `X Y` = `Longitud Latitud`) a anillos de puntos `(lon, lat)`.
/// Solo se usa el anillo exterior de cada poligono; se ignoran los huecos
/// (no aplica a lotes agricolas simples).
List<List<Offset>> parseWktPolygons(String? wkt) {
  if (wkt == null || wkt.trim().isEmpty) return [];
  final clean = wkt.trim().toUpperCase();
  final isMulti = clean.startsWith('MULTIPOLYGON');
  // Cada anillo esta entre parentesis y es una lista "x y, x y, ...".
  final ringPattern = RegExp(r'\(([^()]+)\)');
  final matches = ringPattern.allMatches(wkt).map((m) => m.group(1)!).toList();
  if (matches.isEmpty) return [];

  // Para POLYGON, el primer grupo es el anillo exterior. Para MULTIPOLYGON,
  // cada poligono aporta (al menos) un anillo exterior; se toma 1 de cada 1
  // (se ignoran huecos) tomando el primer anillo de cada bloque "((...))".
  final rings = isMulti ? _outerRingsOfMulti(wkt) : [matches.first];

  return rings
      .map((ring) => ring
          .split(',')
          .map((pair) {
            final parts = pair.trim().split(RegExp(r'\s+'));
            if (parts.length < 2) return null;
            final x = double.tryParse(parts[0]);
            final y = double.tryParse(parts[1]);
            if (x == null || y == null) return null;
            return Offset(x, y); // dx=longitud, dy=latitud
          })
          .whereType<Offset>()
          .toList())
      .where((ring) => ring.length >= 3)
      .toList();
}

List<String> _outerRingsOfMulti(String wkt) {
  // MULTIPOLYGON(((x y, x y, ...)), ((x y, ...)), ...) -- se toma el primer
  // anillo "(x y, ...)" de cada bloque de poligono "((...))".
  final polyPattern = RegExp(r'\(\(([^()]+(?:\)[^()]*\([^()]*)*)\)\)');
  final outer = <String>[];
  for (final block in RegExp(r'\(\((.*?)\)\)', dotAll: true).allMatches(wkt)) {
    final content = block.group(1);
    if (content == null) continue;
    final firstRing = content.split('),').first.replaceAll('(', '').replaceAll(')', '');
    outer.add(firstRing);
  }
  if (outer.isNotEmpty) return outer;
  return polyPattern.allMatches(wkt).map((m) => m.group(1) ?? '').toList();
}

/// Calcula posiciones normalizadas (0..1) para pintar los lotes dentro del
/// bounding box de sus coordenadas reales. Si un lote no tiene lat/long,
/// se distribuye en una cuadricula de respaldo.
List<FieldLot> normalizeLots(List<FieldLot> lots) {
  final withCoords = lots.where((l) => l.lat != null && l.long != null).toList();
  if (withCoords.length < 2) {
    return [
      for (var i = 0; i < lots.length; i++)
        lots[i].withCenter(Offset(0.2 + (i % 3) * 0.3, 0.2 + (i ~/ 3) * 0.3)),
    ];
  }

  final minLat = withCoords.map((l) => l.lat!).reduce((a, b) => a < b ? a : b);
  final maxLat = withCoords.map((l) => l.lat!).reduce((a, b) => a > b ? a : b);
  final minLong = withCoords.map((l) => l.long!).reduce((a, b) => a < b ? a : b);
  final maxLong = withCoords.map((l) => l.long!).reduce((a, b) => a > b ? a : b);
  final latSpan = (maxLat - minLat).abs() < 1e-9 ? 1 : (maxLat - minLat);
  final longSpan = (maxLong - minLong).abs() < 1e-9 ? 1 : (maxLong - minLong);

  return lots.map((lot) {
    if (lot.lat == null || lot.long == null) {
      return lot.withCenter(const Offset(0.5, 0.5));
    }
    final dx = 0.1 + 0.8 * ((lot.long! - minLong) / longSpan);
    final dy = 0.1 + 0.8 * (1 - (lot.lat! - minLat) / latSpan);
    return lot.withCenter(Offset(dx, dy));
  }).toList();
}

Color _colorFromHex(String hex) {
  var value = hex.trim();
  if (value.startsWith('#')) value = value.substring(1);
  if (value.length == 6) value = 'FF$value';
  final parsed = int.tryParse(value, radix: 16);
  if (parsed == null) return const Color(0xFF95A5A6);
  return Color(parsed);
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString());
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString());
}
