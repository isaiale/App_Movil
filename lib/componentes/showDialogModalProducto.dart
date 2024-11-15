import 'package:flutter/material.dart';

class ProductDetailsDialog {
  static void show(
    BuildContext context, {
    required dynamic producto,
  }) {
    // Calcular el precio con descuento, si aplica
    double precio = double.tryParse(producto['precio'].toString()) ?? 0.0;
    double descuento = double.tryParse(producto['descuento'].toString()) ?? 0.0;
    double precioConDescuento =
        descuento > 0 ? precio * (1 - descuento / 100) : precio;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Center(
            child: Text(
              producto['nombre'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black, // Color principal
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (producto['imagenes'] != null &&
                      producto['imagenes'].isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        producto['imagenes'][0]['url'],
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (descuento > 0) ...[
                    Text(
                      'Precio Original: \$${producto['precio']}',
                      style: const TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.red, // Color del tachado
                        color: Colors.grey, // Color del texto original
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Precio con Descuento: \$${precioConDescuento.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // Color del precio con descuento
                      ),
                    ),
                  ] else
                    Text(
                      'Precio: \$${producto['precio']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.production_quantity_limits,
                          color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Cantidad: ${producto['cantidad']}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (producto['talla'] != 'No aplica' &&
                      producto['talla'] != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.straighten, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Talla: ${producto['talla']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  if (producto['sexo'] != 'No aplica' &&
                      producto['sexo'] != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wc, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Sexo: ${producto['sexo']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  if (descuento > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_offer, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'Descuento: ${producto['descuento']}%',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'Cerrar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el modal
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
