import '../componentes/AlertMessage.dart';
import 'package:flutter/material.dart';

class DetalleProducto extends StatefulWidget {
  final String id;
  final String title;
  final String descripcion;
  final double price;
  final String imageUrl;
  final int inventario;
  final List<dynamic> categoria;
  final int? descuento;
  final List<dynamic> talla;
  final String sexo;

  DetalleProducto({
    required this.id,
    required this.title,
    required this.descripcion,
    required this.price,
    required this.imageUrl,
    required this.inventario,
    required this.categoria,
    required this.descuento,
    required this.talla,
    required this.sexo,
  });

  @override
  _DetalleProductoState createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  int cantidad = 1;
  String? tallaSeleccionada; // Para almacenar la talla seleccionada

  @override
  Widget build(BuildContext context) {
    // Cálculo del precio con descuento si existe
    double precioConDescuento =
        widget.descuento != null && widget.descuento! > 0
            ? widget.price * (1 - widget.descuento! / 100)
            : widget.price;

    // Verificar la categoría para determinar el tipo de tallas a mostrar
    List<String> tallas = [];
    if (widget.categoria.any((c) => c["nombre"] == "Zapatos")) {
      tallas = ["23", "24", "25", "26"];
    } else if (widget.categoria
        .any((c) => c["nombre"] == "Chalecos" || c["nombre"] == "Filipinas")) {
      tallas = ['Ch', 'M', 'G', 'XL'];
    } else if (widget.categoria.any((c) => c["nombre"] == "Pantalones")) {
      tallas = ['28', '30', '32', '34', '36', '38'];
    }

    return Scaffold(
      body: Column(
        children: [
          // Imagen del producto
          Stack(
            children: [
              // Icono de retroceso
              Positioned(
                top: 40.0,
                left: 20.0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),

              // Imagen del producto
              Padding(
                padding: const EdgeInsets.only(
                  top:
                      80.0, // Ajusta el padding superior para que la imagen esté debajo del ícono
                ),
                child: Container(
                  height: 400.0, // Altura fija para todas las imágenes
                  width: double.infinity, // Ocupa todo el ancho disponible
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit
                        .contain, // Hace que la imagen ocupe todo el contenedor sin deformarse
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mostrar el título del producto
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.descuento != null && widget.descuento! > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            '${widget.descuento}% OFF',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Mostrar la descripción del producto
                  Text(
                    widget.descripcion,
                    style: TextStyle(color: Colors.grey, fontSize: 16.0),
                  ),
                  SizedBox(height: 20.0),

                  // Mostrar Selector de Tallas
                  if (tallas.isNotEmpty) ...[
                    Text(
                      'Selecciona una talla:',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Wrap(
                      spacing: 8.0, // Espacio entre los botones de talla
                      children: tallas.map((talla) {
                        return _buildSizeOption(
                            talla, widget.talla.contains(talla));
                      }).toList(),
                    ),
                  ],

                  SizedBox(height: 20.0),

                  // Mostrar Precio Original y Precio con Descuento si existe descuento
                  if (widget.descuento != null && widget.descuento! > 0)
                    Row(
                      children: [
                        // Precio original tachado
                        Text(
                          '\$${widget.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                            decoration:
                                TextDecoration.lineThrough, // Precio tachado
                          ),
                        ),
                        SizedBox(width: 10.0),
                        // Precio con descuento resaltado
                        Text(
                          '\$${precioConDescuento.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    )
                  else
                    // Mostrar solo el precio original si no hay descuento
                    Text(
                      '\$${widget.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  SizedBox(height: 20.0),

                  // Selector de cantidad
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cantidad',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.remove_circle_outline,
                            ),
                            onPressed: () {
                              setState(() {
                                if (cantidad > 1) cantidad--;
                              });
                            },
                          ),
                          Text(
                            '$cantidad',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() {
                                if (cantidad < widget.inventario) {
                                  cantidad++;
                                } else {
                                  // Mostrar la alerta de advertencia cuando el usuario intenta exceder el inventario
                                  AlertMessage.show(
                                    context: context,
                                    message:
                                        'La cantidad que seleccionaste supera la existencia actual del producto.',
                                    type: MessageType.warning,
                                  );
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),

                  // Precio total y botón de agregar al carrito
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Precio Total',
                              style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 5.0),
                          Text(
                            '\$${(precioConDescuento * cantidad).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Acción para agregar al carrito
                          if (cantidad <= widget.inventario) {
                            // Lógica para añadir al carrito
                          } else {
                            // Mostrar la alerta si la cantidad excede el inventario
                            AlertMessage.show(
                              context: context,
                              message:
                                  'La cantidad que seleccionaste supera la existencia actual del producto.',
                              type: MessageType.warning,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          'Añadir al carrito',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
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
    );
  }

  // Construir el botón de selección de tallas
  Widget _buildSizeOption(String size, bool isAvailable) {
    return GestureDetector(
      onTap: isAvailable
          ? () {
              setState(() {
                tallaSeleccionada = size;
              });
            }
          : null, // Si no está disponible, no hace nada al hacer click
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: tallaSeleccionada == size
              ? Colors.green
              : isAvailable
                  ? Colors.white
                  : Colors.grey[300], // Si no está disponible, usar gris
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: tallaSeleccionada == size
                ? Colors.green
                : isAvailable
                    ? Colors.grey
                    : Colors
                        .grey[400]!, // Si no está disponible, usar gris claro
          ),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: tallaSeleccionada == size
                ? Colors.white
                : isAvailable
                    ? Colors.black
                    : Colors.grey, // Texto gris si no está disponible
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
