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
                  'icon': Icons.category, // Se puede cambiar el icono aquí
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
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 40.0, // Altura del carrusel de categorías
        child: categories.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                scrollDirection: Axis.horizontal, // Desplazamiento horizontal
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
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
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              category['icon'],
                              color: Colors.white,
                              size: 20.0,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              category['name'],
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
