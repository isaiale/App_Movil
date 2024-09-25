import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_movil/componentes/drawer.dart';
import 'package:app_movil/componentes/custom_app_bar.dart';
import 'package:app_movil/componentes/productos_categoria.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  final List<String> imageList = [
    'imagenes/slider1.jpg', // Asegúrate de que coincida con la ruta en pubspec.yaml
    'imagenes/slider2.png',
  ];

  List<Map<String, dynamic>> categories = [];

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Producto 1',
      'price': 9.99,
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Producto 2',
      'price': 14.99,
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Producto 3',
      'price': 7.99,
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Producto 4',
      'price': 12.99,
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Producto 5',
      'price': 5.99,
      'imageUrl': 'https://via.placeholder.com/150',
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Llama a la función para obtener las categorías desde la API
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
                  'icon': Icons.category, // Puedes ajustar el icono que desees
                })
            .toList();
      });
    } else {
      // Manejo de error
      print("Error al cargar las categorías: ${response.statusCode}");
    }
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Inicio'),
      drawer: DrawerUser(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slider de imágenes usando PageView con margen, sombra y bordes redondeados
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0), // Agrega margen a los lados y arriba/abajo
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.2), // Color de la sombra con opacidad
                    spreadRadius: 2, // Extiende el área de la sombra
                    blurRadius: 8, // Desenfoque de la sombra
                    offset: Offset(0, 4), // Desplazamiento de la sombra (x, y)
                  ),
                ],
                borderRadius: BorderRadius.circular(20.0), // Bordes redondeados
              ),
              child: ClipRRect(
                // Clip para que las imágenes también tengan bordes redondeados
                borderRadius: BorderRadius.circular(
                    20.0), // Aplica el mismo radio que el del contenedor
                child: SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemCount: imageList.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            imageList[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: imageList.map((imageUrl) {
                            int index = imageList.indexOf(imageUrl);
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: _currentIndex == index ? 12.0 : 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Carrusel de categorías usando Chips
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                height: 50.0, // Altura para los Chips
                child: categories.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Center(
                        child: Wrap(
                          spacing: 8.0, // Espacio entre los Chips
                          alignment: WrapAlignment.center, // Centrar los Chips
                          children: categories.map((category) {
                            return GestureDetector(
                              onTap: () {
                                // Verifica si el _id no es null antes de usarlo
                                String categoriaId = category['_id'] ?? '';
                                if (categoriaId.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductosCategoria(
                                          categoriaId: categoriaId),
                                    ),
                                  );
                                } else {
                                  // Manejar caso de ID nulo o vacío
                                  print("ID de categoría nulo o vacío");
                                }
                              },
                              child: Chip(
                                label: Text(category['name']), // Texto de la categoría
                                backgroundColor:
                                   Colors.green, // Fondo verde del Chip
                                labelStyle: TextStyle(
                                    color: Colors
                                        .white), // Texto blanco en el Chip
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              ),
            ),

            // Lista de productos (puedes dejarlo igual si no necesita cambios)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Número de productos por fila
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio:
                      0.75, // Relación de aspecto de los productos
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    name: products[index]['name'],
                    price: products[index]['price'],
                    imageUrl: products[index]['imageUrl'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String imageUrl;

  ProductCard({
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  '\$$price',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
