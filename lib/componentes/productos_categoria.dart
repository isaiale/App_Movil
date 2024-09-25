import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductosCategoria extends StatefulWidget {
  final String categoriaId;

  ProductosCategoria({required this.categoriaId});

  @override
  _ProductosCategoriaState createState() => _ProductosCategoriaState();
}

class _ProductosCategoriaState extends State<ProductosCategoria> {
  List<dynamic> productos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductosByCategoria();
  }

  Future<void> fetchProductosByCategoria() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://back-end-enfermera.vercel.app/api/productos/productos/categoria/${widget.categoriaId}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data); // Imprime la respuesta para verificar su estructura

        // Verificamos si data es un Map y contiene la clave 'productos'
        if (data is Map<String, dynamic> && data.containsKey('productos')) {
          setState(() {
            productos = data['productos']; // Accedemos a la lista de productos
            isLoading = false;
          });
        } else {
          setState(() {
            productos = []; // Si no hay productos, dejamos la lista vacía
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos por Categoría'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : productos.isEmpty
              ? Center(child: Text("No hay productos en esta categoría"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Número de productos por fila
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio:
                          0.75, // Relación de aspecto de los productos
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
  final int descuento;
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
                          // Lógica para manejar la acción cuando se presiona el botón
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
