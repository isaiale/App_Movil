// lib/services/producto_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductoService {
  final String baseUrl = 'https://back-end-enfermera.vercel.app/api/productos/productos';

  Future<List<dynamic>> fetchProductos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar los productos');
    }
  }
}

class ProductosCategoriaService {
  final String baseUrl = 'https://back-end-enfermera.vercel.app/api/productos/productos/categoria';

  Future<List<dynamic>> fetchProductosByCategoria(String categoriaId) async {
    final response = await http.get(Uri.parse('$baseUrl/$categoriaId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Asegúrate de que 'data' sea una lista
      if (data is List) {
        return data;
      } else {
        throw Exception('El formato de la respuesta no es válido');
      }
    } else {
      throw Exception('Error al cargar los productos');
    }
  }
}