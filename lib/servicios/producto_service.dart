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
