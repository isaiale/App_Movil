import 'package:flutter/material.dart';

class ProductListView extends StatelessWidget {
  final List<dynamic> productos;
  final Function(int index) disminuirCantidad;
  final Function(int index) incrementarCantidad;
  final Function(BuildContext context, Map<String, dynamic> producto)
      mostrarDetallesProducto;
  final Function(int index) confirmarEliminarProducto;

  const ProductListView({
    Key? key,
    required this.productos,
    required this.disminuirCantidad,
    required this.incrementarCantidad,
    required this.mostrarDetallesProducto,
    required this.confirmarEliminarProducto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Sombra ligera
                    blurRadius: 10.0,
                    offset: const Offset(0, 4), // Posición de la sombra
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Botón de información
                    IconButton(
                      icon: const Icon(Icons.info, color: Colors.blueAccent),
                      onPressed: () {
                        mostrarDetallesProducto(context, producto);
                      },
                    ),

                    // Imagen del producto
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        producto['imagenes'][0]['url'],
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Detalles del producto
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            producto['nombre'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Cantidad: ${producto['cantidad']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Controles de cantidad
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            disminuirCantidad(index);
                          },
                        ),
                        Text(
                          '${producto['cantidad']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            incrementarCantidad(index);
                          },
                        ),
                      ],
                    ),

                    // Precio del producto
                    const SizedBox(width: 10),
                    Text(
                      '\$${producto['precio']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    // Botón de eliminar
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        confirmarEliminarProducto(index);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
