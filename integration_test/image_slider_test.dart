import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
// import 'package:mi_app/test_image_slider_app.dart'; // Importa el widget de prueba
import 'package:app_movil/componentes/image_slider.dart';
import 'ImageSlider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Prueba de funcionalidad básica de ImageSlider',
      (WidgetTester tester) async {
    // Renderiza el widget de prueba
    await tester.pumpWidget(TestImageSliderApp());
    await tester.pumpAndSettle();

    // Encuentra el ImageSlider
    final imageSliderFinder = find.byType(ImageSlider);
    expect(imageSliderFinder, findsOneWidget);

    // Verifica que la primera imagen está presente
    final firstImageFinder = find.byKey(const ValueKey('image_0'));
    expect(firstImageFinder, findsOneWidget);

    // Desliza hacia la izquierda para cambiar de imagen
    await tester.fling(imageSliderFinder, const Offset(-300, 0), 1000);
    await tester.pumpAndSettle();

    // Verifica que la segunda imagen aparece
    final secondImageFinder = find.byKey(const ValueKey('image_1'));
    expect(secondImageFinder, findsOneWidget);

    // Verifica el estado del indicador
    final activeIndicatorFinder = find.descendant(
      of: find.byType(Row),
      matching: find.byWidgetPredicate((widget) =>
          widget is AnimatedContainer &&
          (widget.decoration as BoxDecoration?)?.shape == BoxShape.circle &&
          (widget.constraints?.maxWidth ==
              12.0)), // Indica el ancho del indicador activo
    );

    expect(activeIndicatorFinder, findsOneWidget);
  });
}
