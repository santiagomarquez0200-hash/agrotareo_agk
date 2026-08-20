import 'package:agrotareo_agk/app/agro_tareo_app.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});

    // flutter_secure_storage y connectivity_plus no tienen implementacion
    // nativa en el entorno de test: se simulan sin sesion/backup guardados
    // y con conectividad "wifi" para que el bootstrap resuelva sin colgarse.
    const secureStorageChannel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      secureStorageChannel,
      (call) async {
        if (call.method == 'read') return null;
        if (call.method == 'readAll') return <String, String>{};
        return null;
      },
    );

    const connectivityChannel = MethodChannel('dev.fluttercommunity.plus/connectivity');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      connectivityChannel,
      (call) async => ['wifi'],
    );
    const connectivityEventChannel = EventChannel('dev.fluttercommunity.plus/connectivity_status');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      connectivityEventChannel.name,
      (message) async => null,
    );
  });

  testWidgets('AgroTareo shows the login screen on start', (WidgetTester tester) async {
    await tester.pumpWidget(const AgroTareoApp());
    // Deja resolver el bootstrap (entorno + sesion cacheada, sin backend real).
    await tester.pumpAndSettle();

    expect(find.text('AgroTareo'), findsOneWidget);
    expect(find.text('Iniciar Sesion'), findsOneWidget);
    expect(find.text('INGRESAR'), findsOneWidget);

    // El campo de usuario esta vacio: enviar debe mostrar el error de
    // validacion en vez de intentar conectarse al backend.
    await tester.tap(find.text('INGRESAR'));
    await tester.pump();
    expect(find.text('Ingrese su usuario'), findsWidgets);
  });
}
