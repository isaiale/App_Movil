import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  group('API Endpoint Test', () {
    test('Verifica si el endpoint es accesible', () async {
      final url = Uri.parse('https://back-end-enfermera.vercel.app/api/productos/productos');

      try {
        final response = await http.get(url);

        // Verifica si el código de estado es 200
        if (response.statusCode == 200) {
          print('✅ El endpoint respondió correctamente.');
        } else {
          print('❌ Falló: El endpoint respondió con un código ${response.statusCode}');
        }

        // Assertion para que falle la prueba si el código no es 200
        expect(response.statusCode, 200);
      } catch (e) {
        // Manejo de errores en caso de que no se pueda acceder al servidor
        print('❌ Falló: No se pudo acceder al endpoint. Error: $e');
        fail('No se pudo acceder al endpoint.');
      }
    });
  });
}
