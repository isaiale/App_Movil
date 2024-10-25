import 'dart:convert';
import 'package:http/http.dart' as http;
import '../componentes/AlertMessage.dart';
import 'package:flutter/material.dart';
import '../servicios/UserService.dart';

class DetalleProducto extends StatefulWidget {
  final String id;
  final String title;
  final String descripcion;
  final double price;
  final String imageUrl;
  final int inventario;
  final dynamic categoria;
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
  final userInfo = UserService().decodedToken;
  String? idUsuario;
  int cantidad = 1;
  String? tallaSeleccionada; // Para almacenar la talla seleccionada

  @override
  void initState() {
    super.initState();

    // Verificar si userInfo no es nulo y contiene el campo '_id'
    if (userInfo != null && userInfo?['_id'] != null) {
      idUsuario = userInfo!['_id']; // Guardar el ID del usuario
      print('ID del usuario: $idUsuario'); // Mostrar en la terminal
    }
  }

  Future<void> _agregarAlCarrito() async {
    // Verificar si hay un usuario logueado
    if (idUsuario == null) {
      AlertMessage.show(
        context: context,
        message: 'Debes iniciar sesión para añadir productos al carrito.',
        type: MessageType.warning,
      );
      return;
    }

    // Preparar los datos para enviar a la API
    final data = {
      'usuario': idUsuario,
      'producto': widget.id,
      'cantidad': cantidad,
      'talla': tallaSeleccionada ?? 'No aplica', // Si no hay talla, "No aplica"
      'sexo': widget.sexo.isNotEmpty
          ? widget.sexo
          : 'No aplica', // Si no tiene sexo, "No aplica"
    };

    try {
      // Realizar la solicitud POST a la API
      final response = await http.post(
        Uri.parse(
            'https://back-end-enfermera.vercel.app/api/carrito'), // Reemplaza con tu URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        // Éxito: Mostrar mensaje de confirmación
        AlertMessage.show(
          context: context,
          message: 'Producto añadido al carrito con éxito.',
          type: MessageType.success,
        );
      } else {
        // Error en la respuesta de la API
        AlertMessage.show(
          context: context,
          message: 'Error al añadir el producto al carrito.',
          type: MessageType.error,
        );
      }
    } catch (error) {
      // Error en la conexión
      AlertMessage.show(
        context: context,
        message: 'No se pudo conectar con el servidor.',
        type: MessageType.error,
      );
      print('Error al enviar solicitud: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        'Mostrando producto: ${widget.title}, Precio: ${widget.price}, Inventario: ${widget.inventario}, talla:${widget.talla}, sexo:${widget.sexo}');

    // Cálculo del precio con descuento si existe
    double precioConDescuento =
        widget.descuento != null && widget.descuento! > 0
            ? widget.price * (1 - widget.descuento! / 100)
            : widget.price;

    // Verificar la categoría para determinar el tipo de tallas a mostrar
    List<String> tallas = [];

    if (widget.categoria is List) {
      // Si es una lista, aplicar la lógica con any
      if (widget.categoria.any((c) => c["nombre"] == "Zapatos")) {
        tallas = ["23", "24", "25", "26"];
      } else if (widget.categoria.any(
          (c) => c["nombre"] == "Chalecos" || c["nombre"] == "Filipinas")) {
        tallas = ['Ch', 'M', 'G', 'XL'];
      } else if (widget.categoria.any((c) => c["nombre"] == "Pantalones")) {
        tallas = ['28', '30', '32', '34', '36', '38'];
      }
    } else if (widget.categoria is String) {
      // Si es un String, compararlo directamente
      if (widget.categoria == "Zapatos") {
        tallas = ["23", "24", "25", "26"];
      } else if (widget.categoria == "Chalecos" ||
          widget.categoria == "Filipinas") {
        tallas = ['Ch', 'M', 'G', 'XL'];
      } else if (widget.categoria == "Pantalones") {
        tallas = ['28', '30', '32', '34', '36', '38'];
      }
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
                            fontSize: 20.0,
                            color: Colors.red,
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
                  if (widget.inventario == 0)
                    Text(
                      '📍Producto Agotado',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

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
                                if (widget.inventario == 0) {
                                  // Mostrar alerta cuando el producto está agotado
                                  AlertMessage.show(
                                    context: context,
                                    message: 'El producto está agotado.',
                                    type: MessageType.error,
                                  );
                                } else if (cantidad < widget.inventario) {
                                  // Incrementar la cantidad si no supera el inventario
                                  cantidad++;
                                } else {
                                  // Mostrar alerta si la cantidad supera el inventario disponible
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
                              style: TextStyle(
                                  color: Colors.black, fontSize: 17.0)),
                          SizedBox(height: 4.0),
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
                        onPressed: widget.inventario > 0
                            ? () {
                                if (tallas.isNotEmpty &&
                                    tallaSeleccionada == null) {
                                  AlertMessage.show(
                                    context: context,
                                    message:
                                        'Por favor, selecciona una talla antes de añadir al carrito.',
                                    type: MessageType.warning,
                                  );
                                  return; // Detener la ejecución si no se selecciona talla
                                }
                                _agregarAlCarrito(); // Lógica para añadir al carrito
                              }
                            : null, // Deshabilitar botón si inventario es 0
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
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
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
