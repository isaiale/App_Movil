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
  return SizedBox(
    height: 320, // Ajustar la altura deseada
    child: Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del producto
              AspectRatio(
                aspectRatio: 1.0, // Cambiar este valor para ajustar el aspecto
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
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
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        descripcion,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            descuento > 0
                                ? '\$${(price - (price * descuento / 100)).toStringAsFixed(2)}'
                                : '\$$price',
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (descuento > 0)
                            Text(
                              '\$$price',
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
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
                              minimumSize: const Size(40, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Etiqueta de descuento
          if (descuento > 0)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  '-$descuento%',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

}
