import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_movil/componentes/TestComponent.dart';

void main() {
  testWidgets('', (WidgetTester tester) async {
    // Configura el manejador para ignorar excepciones.
    FlutterError.onError = (FlutterErrorDetails details) {
      // Silencia las excepciones durante la prueba.
      if (!details.exceptionAsString().contains('Error simulado en el TestComponent')) {
        FlutterError.presentError(details);
      }
    };

    // Construye el widget TestComponent.
    await tester.pumpWidget(
      MaterialApp(
        home: TestComponent(),
      ),
    );

    // Verifica que el texto del botón está presente.
    expect(find.text('Generar Error'), findsOneWidget);

    // Intenta presionar el botón para simular interacción.
    await tester.tap(find.byKey(const ValueKey('error_button')));
    await tester.pump(); // Permite procesar los eventos.

    // Asegura que el botón existe después del error.
    expect(find.text('Generar Error'), findsOneWidget);    
  });
}
