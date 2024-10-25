import 'package:flutter/material.dart';
import 'package:app_movil/vistas/detalle_producto.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final String descripcion;
  final int inventario;
  final int descuento;
  final List<dynamic> talla;
  final String sexo;
  final dynamic categoria;
  final String imageUrl;

  ProductCard({
    required this.id,
    required this.title,
    required this.price,
    required this.descripcion,
    required this.inventario,
    required this.descuento,
    required this.talla,
    required this.sexo,
    required this.categoria,
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
          // Imagen del producto
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
          // Detalles del producto
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
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
                      // Precio del producto
                      Text(
                        '\$$price',
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Botón de añadir al carrito
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleProducto(
                                id: id,
                                title: title,
                                descripcion: descripcion,
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
