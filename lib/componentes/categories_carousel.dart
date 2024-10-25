import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_movil/componentes/productos_categoria.dart';

class CategoriesCarousel extends StatefulWidget {
  @override
  _CategoriesCarouselState createState() => _CategoriesCarouselState();
}

class _CategoriesCarouselState extends State<CategoriesCarousel> {
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse(
        'https://back-end-enfermera.vercel.app/api/categorias/categoria'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      setState(() {
        categories = data
            .map((category) => {
                  '_id': category['_id'],
                  'name': category['nombre'],
                  'icon': Icons.category,
                })
            .toList();
      });
    } else {
      print("Error al cargar las categorías: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        height: 50.0,
        child: categories.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Wrap(
                  spacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: categories.map((category) {
                    return GestureDetector(
                      onTap: () {
                        String categoriaId = category['_id'] ?? '';
                        if (categoriaId.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductosCategoria(categoriaId: categoriaId),
                            ),
                          );
                        } else {
                          print("ID de categoría nulo o vacío");
                        }
                      },
                      child: Chip(
                        label: Text(category['name']),
                        backgroundColor: Colors.green,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }
}
