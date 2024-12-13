import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Pruebas de ProductosCategoria', () {
    late FlutterDriver driver;

    // Configuración inicial
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Cierre de conexión
    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('Verificar carga inicial de productos', () async {
      // Espera a que termine de cargar el indicador de progreso
      await driver.waitForAbsent(find.byValueKey('loadingIndicator'));

      // Verifica que los productos están cargados
      final grid = find.byValueKey('productGrid');
      await driver.waitFor(grid);

      // Verifica que existe al menos un producto
      final firstProduct = find.byValueKey('product_0');
      expect(await driver.getText(firstProduct), isNotEmpty);
    });

    test('Realizar una búsqueda de productos', () async {
      // Encuentra el campo de búsqueda
      final searchField = find.byValueKey('productSearch');

      // Escribe un término de búsqueda
      await driver.tap(searchField);
      await driver.enterText('Laptop');

      // Espera a que se muestren los resultados filtrados
      await driver.waitFor(find.byValueKey('product_0'));

      // Verifica que el producto contiene el término buscado
      final firstProduct = find.byValueKey('product_0');
      final firstProductText = await driver.getText(firstProduct);
      expect(firstProductText.toLowerCase(), contains('laptop'));
    });

    test('Limpiar filtros', () async {
      // Toca el botón para limpiar filtros
      final clearButton = find.byValueKey('clearButton');
      await driver.tap(clearButton);

      // Verifica que todos los productos se restauran
      final grid = find.byValueKey('productGrid');
      await driver.waitFor(grid);

      // Verifica que hay productos disponibles
      final firstProduct = find.byValueKey('product_0');
      expect(await driver.getText(firstProduct), isNotEmpty);
    });
  });
}

