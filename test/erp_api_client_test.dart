import 'package:agrotareo_agk/core/network/erp_api_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErpApiClient.asTables', () {
    test('formato real del proxy: claves con nombre de tabla SQL', () {
      // Esto es lo que realmente devuelve WSRESTMovilidadERP para
      // CLI547_AGM_MOBILE_MASTER_SYNC: una clave por tabla de origen, en el
      // mismo orden que los SELECT del SP -- NO Table/Table1/Table2.
      final response = {
        'Tareo_activity': [
          {'Activity_Id': 1, 'Activity_Nombre': 'Cosecha'},
        ],
        'Tareo_productivitytype': [
          {'ProductivityType_Id': 10, 'ProductivityType_Nombre': 'Kilos'},
        ],
        'Accounts_employee': [
          {'Employee_Id': 100, 'CodigoTrabajador': 'T-1'},
          {'Employee_Id': 101, 'CodigoTrabajador': 'T-2'},
        ],
      };

      final tables = ErpApiClient.asTables(response);

      expect(tables.length, 3);
      expect(tables[0], [
        {'Activity_Id': 1, 'Activity_Nombre': 'Cosecha'},
      ]);
      expect(tables[1].single['ProductivityType_Nombre'], 'Kilos');
      expect(tables[2].length, 2);
    });

    test('formato clasico Table/Table1/Table2 sigue funcionando', () {
      final response = {
        'Table': [
          {'A': 1},
        ],
        'Table1': [
          {'B': 2},
        ],
        'Table2': [
          {'C': 3},
        ],
      };

      final tables = ErpApiClient.asTables(response);

      expect(tables.length, 3);
      expect(tables[0].single['A'], 1);
      expect(tables[1].single['B'], 2);
      expect(tables[2].single['C'], 3);
    });

    test('respuesta de una sola tabla (un solo SELECT) no se rompe', () {
      final response = {
        'Cultivos': [
          {'Id': 1},
          {'Id': 2},
        ],
      };

      final tables = ErpApiClient.asTables(response);

      expect(tables.length, 1);
      expect(tables[0].length, 2);
    });

    test('lista directa (sin envolver) se trata como una sola tabla', () {
      final response = [
        {'A': 1},
        {'A': 2},
      ];

      final tables = ErpApiClient.asTables(response);

      expect(tables.length, 1);
      expect(tables[0].length, 2);
    });
  });
}
