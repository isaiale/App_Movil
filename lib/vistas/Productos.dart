import 'package:flutter/material.dart';
import '../servicios/producto_service.dart';
import '../componentes/drawer.dart'; // Importa el nuevo componente Hamburguesa para el AppBar y Drawer
import '../vistas/detalle_producto.dart';
import '../componentes/custom_app_bar.dart'; // Importa el CustomAppBar

class Productos extends StatefulWidget {
  @override
  _ProductosState createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  final ProductoService _productoService = ProductoService();
  List<dynamic> productos = [];

  @override
  void initState() {
    super.initState();
    fetchProductos();
  }

  Future<void> fetchProductos() async {
    try {
      List<dynamic> data = await _productoService.fetchProductos();
      setState(() {
        productos = data;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Productos'),
      drawer: DrawerUser(), // Usa el componente CustomDrawer
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar producto...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('Hot Coffee'),
                  _buildCategoryChip('Cold Brew'),
                  _buildCategoryChip('Espresso'),
                  _buildCategoryChip('Milk Tea'),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: productos.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.73,
                      ),
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          id: productos[index]['_id'],
                          title: productos[index]['nombre'],
                          price: productos[index]['precio'].toDouble(),
                          imageUrl: productos[index]['imagenes'][0]['url'],
                          inventario: productos[index]['inventario'],
                          categoria: productos[index]['categoria'] ?? [],
                          descuento: productos[index]['descuento'] ?? 0,
                          talla: productos[index]['talla'] ?? [],
                          sexo: productos[index]['sexo'] ?? 'Desconocido',
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.green,
        labelStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final int inventario;
  final List<dynamic> categoria;
  final int? descuento;
  final List<dynamic> talla;
  final String sexo;

  ProductCard({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.inventario,
    required this.categoria,
    required this.descuento,
    required this.talla,
    required this.sexo,
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
            aspectRatio: 1,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$$price',
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleProducto(
                                title: title,
                                price: price,
                                imageUrl: imageUrl,
                                inventario: inventario,
                                categoria: categoria,
                                descuento: descuento,
                                talla: talla,
                                sexo: sexo,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: Size(40, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Icon(Icons.add_shopping_cart, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
