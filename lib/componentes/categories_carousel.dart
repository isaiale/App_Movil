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
  final List<Color> categoryColors = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.brown,
  ];

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
        // Agregar manualmente la categoría Accesorios
        categories.add({
          '_id': '660e8da897d41d20a385ee4f',
          'name': 'Accesorios',
          'icon': Icons.shopping_bag,
        });
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
        height: 60.0, // Altura ajustada para mayor visibilidad
        child: categories.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              )
            : ListView.builder(
                scrollDirection: Axis.horizontal, // Desplazamiento horizontal
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final color =
                      categoryColors[index % categoryColors.length]; // Ciclo de colores
                  return GestureDetector(
                    onTap: () {
                      String categoriaId = category['_id'] ?? '';
                      String nombreCategoria = category['name'] ?? '';
                      if (categoriaId.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductosCategoria(
                                categoriaId: categoriaId,
                                nombreCategoria: nombreCategoria),
                          ),
                        );
                      } else {
                        print("ID de categoría nulo o vacío");
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 1,
                            offset: Offset(0, 2), // Sombra hacia abajo
                          ),
                        ],
                      ),
                      child: Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              category['icon'],
                              color: Colors.white,
                              size: 20.0,
                            ),
                            const SizedBox(width: 8.0),
                            Flexible(
                              child: Text(
                                category['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: color, // Color de fondo de la categoría
                        elevation: 0, // Elevación del chip desactivada
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
