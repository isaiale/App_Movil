import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:app_movil/servicios/UrlService.dart';

void main() {
  group('ProductoService', () {
    test('should return a list of products when the http call is successful', () async {
      // Configura el cliente Dio con el adaptador mock
      final dio = Dio();
      final dioAdapter = DioAdapter(dio: dio);
      final service = ProductoService(dio: dio);

      // Define el endpoint y la respuesta simulada
      dioAdapter.onGet(
        'https://back-end-enfermera.vercel.app/api/productos/productos',
        (server) => server.reply(200, '[{"id":1, "nombre":"Producto 1"}]'),
      );

      // Ejecuta la función
      final productos = await service.fetchProductos();

      // Verifica que la respuesta sea la esperada
      expect(productos, isA<List<dynamic>>());
      expect(productos[0]['nombre'], 'Producto 1');
    });

    test('should throw an exception when the http call fails', () async {
      // Configura el cliente Dio con el adaptador mock
      final dio = Dio();
      final dioAdapter = DioAdapter(dio: dio);
      final service = ProductoService(dio: dio);

      // Define el endpoint con un error HTTP
      dioAdapter.onGet(
        'https://back-end-enfermera.vercel.app/api/productos/productos',
        (server) => server.reply(500, 'Error'),
      );

      // Verifica que se lance una excepción
      expect(() async => await service.fetchProductos(), throwsException);
    });
  });
}
