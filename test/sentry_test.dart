import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/componentes/TestComponent.dart';

void main() {
  testWidgets('Prueba de Sentry: Captura de errores en TestComponent', (WidgetTester tester) async {
    // Inicializa Sentry
    await SentryFlutter.init(
      (options) {
        options.dsn = 'https://3c00a4d9f334ee73c9d350fcd1dc90bd@o4508372929609728.ingest.us.sentry.io/4508373476507648';
        options.environment = 'testing'; // Indica que es un entorno de pruebas
        options.tracesSampleRate = 1.0; // Captura transacciones
        options.debug = false; // Desactiva logs de depuración
      },
      appRunner: () => tester.pumpWidget(MaterialApp(home: TestComponent())),
    );

    // Verifica que el botón esté presente
    final buttonFinder = find.byKey(const ValueKey('error_button'));
    expect(buttonFinder, findsOneWidget);

    // Simula el clic en el botón para generar un error
    try {
      await tester.tap(buttonFinder);
      await tester.pump(); // Procesa el evento
    } catch (e, stackTrace) {
      // Captura el error usando Sentry y proporciona un Hint
      final hint = Hint.withMap({'context': 'Error generado al probar TestComponent'});
      
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: hint, // Usa el Hint con más contexto
      );
    }

    // Verifica que el test continúe ejecutándose
    expect(find.text('Generar Error'), findsOneWidget);
  });
}
