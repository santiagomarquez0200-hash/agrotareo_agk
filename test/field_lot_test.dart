import 'package:agrotareo_agk/data/models/employee.dart';
import 'package:agrotareo_agk/data/models/field_lot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseWktPolygons', () {
    test('parsea un POLYGON simple', () {
      const wkt = 'POLYGON ((-76.1 -12.1, -76.2 -12.1, -76.2 -12.2, -76.1 -12.2, -76.1 -12.1))';
      final rings = parseWktPolygons(wkt);
      expect(rings.length, 1);
      expect(rings.first.length, 5);
      expect(rings.first.first.dx, closeTo(-76.1, 0.0001));
      expect(rings.first.first.dy, closeTo(-12.1, 0.0001));
    });

    test('parsea un MULTIPOLYGON con 2 poligonos', () {
      const wkt = 'MULTIPOLYGON ('
          '((-76.1 -12.1, -76.2 -12.1, -76.2 -12.2, -76.1 -12.1)), '
          '((-75.1 -11.1, -75.2 -11.1, -75.2 -11.2, -75.1 -11.1))'
          ')';
      final rings = parseWktPolygons(wkt);
      expect(rings.length, 2);
      expect(rings[0].length, 4);
      expect(rings[1].length, 4);
    });

    test('WKT nulo o vacio devuelve lista vacia', () {
      expect(parseWktPolygons(null), isEmpty);
      expect(parseWktPolygons(''), isEmpty);
      expect(parseWktPolygons('  '), isEmpty);
    });
  });

  group('ProductivityTypeCatalog.validar', () {
    const tipo = ProductivityTypeCatalog(id: 1, nombre: 'Kilos', minimo: 5, maximo: 100);

    test('rechaza por debajo del minimo', () {
      expect(tipo.validar(1), isNotNull);
    });

    test('rechaza por encima del maximo', () {
      expect(tipo.validar(150), isNotNull);
    });

    test('acepta dentro del rango', () {
      expect(tipo.validar(50), isNull);
    });

    test('sin rango definido, todo es valido', () {
      const sinRango = ProductivityTypeCatalog(id: 2, nombre: 'Unidades');
      expect(sinRango.validar(-5), isNull);
      expect(sinRango.validar(99999), isNull);
    });
  });
}
