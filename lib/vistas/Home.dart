import 'package:flutter/material.dart';
import 'package:app_movil/componentes/drawer.dart';
import 'package:app_movil/componentes/custom_app_bar.dart';
import 'package:app_movil/componentes/image_slider.dart';
import 'package:app_movil/componentes/categories_carousel.dart';
import 'package:app_movil/servicios/producto_service.dart';
import 'package:app_movil/componentes/ProductosCarousel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ProductoService _productoService = ProductoService();
  List<Map<String, dynamic>> productosPantalon = [];
  List<Map<String, dynamic>> productosFilipinas = [];

  @override
  void initState() {
    super.initState();
    fetchProductos();
  }

  Future<void> fetchProductos() async {
    try {
      List<dynamic> productos = await _productoService.fetchProductos();
      print('Productos recibidos: ${productos.length}');

      // Filtrar productos por categoría 'Pantalones'
      List<Map<String, dynamic>> pantalonesFiltrados = productos
          .where((producto) =>
              producto['categoria'].isNotEmpty &&
              producto['categoria'][0]['nombre'] == 'Pantalones')
          .map((producto) => {
                '_id': producto['_id'],
                'name': producto['nombre'] ?? 'Sin nombre',
                'price': producto['precio'] ?? 0.0,
                'imageUrl': producto['imagenes'].isNotEmpty
                    ? producto['imagenes'][0]['url']
                    : 'https://via.placeholder.com/150',
                'descripcion': producto['descripcion'] ?? '',
                'inventario': producto['inventario'] ?? 0,
                'categoria': producto['categoria'],
                'descuento': producto['descuento'] ?? 0,
                'talla': producto['talla'] ?? [],
                'sexo': producto['sexo'] ?? 'No aplica',
              })
          .toList();

      // Filtrar productos por categoría 'Filipinas'
      List<Map<String, dynamic>> filipinasFiltrados = productos
          .where((producto) =>
              producto['categoria'].isNotEmpty &&
              producto['categoria'][0]['nombre'] == 'Filipinas')
          .map((producto) => {
                '_id': producto['_id'],
                'name': producto['nombre'] ?? 'Sin nombre',
                'price': producto['precio'] ?? 0.0,
                'imageUrl': producto['imagenes'].isNotEmpty
                    ? producto['imagenes'][0]['url']
                    : 'https://via.placeholder.com/150',
                'descripcion': producto['descripcion'] ?? '',
                'inventario': producto['inventario'] ?? 0,
                'categoria': producto['categoria'],
                'descuento': producto['descuento'] ?? 0,
                'talla': producto['talla'] ?? [],
                'sexo': producto['sexo'] ?? 'No aplica',
              })
          .toList();

      setState(() {
        productosPantalon = pantalonesFiltrados;
        productosFilipinas = filipinasFiltrados;
      });

      print('Productos en Pantalones: ${productosPantalon.length}');
      print('Productos en Filipinas: ${productosFilipinas.length}');
    } catch (e) {
      print('Error al obtener los productos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Inicio'),
      drawer: DrawerUser(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),

            // Slider de Imágenes
            ImageSlider(),

            // Encabezado de Categorías
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Categorías',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Carrusel de Categorías usando Chips
            CategoriesCarousel(),

            SizedBox(height: 10.0),

            // Encabezado para Pantalones
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Pantalones',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Carrusel de Pantalones
            productosPantalon.isNotEmpty
                ? ProductCarousel(products: productosPantalon)
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No hay productos disponibles en la categoría "Pantalones".',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),

            SizedBox(height: 20.0),

            // Encabezado para Filipinas
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Filipinas',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Carrusel de Filipinas
            productosFilipinas.isNotEmpty
                ? ProductCarousel(products: productosFilipinas)
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No hay productos disponibles en la categoría "Filipinas".',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
