import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../servicios/UserService.dart';
import '../componentes/CustomElevatedButton.dart';
import '../componentes/ConfirmationDialog.dart';
import '../componentes/AlertMessage.dart';

class CarritoCompras extends StatefulWidget {
  @override
  _CarritoComprasState createState() => _CarritoComprasState();
}

class _CarritoComprasState extends State<CarritoCompras> {
  List<dynamic> productos = []; // Aquí se almacenarán los productos
  bool isLoading = true; // Indicador de carga
  double total = 0.0; // Total inicial
  String? userId; // Para almacenar el ID del usuario

  @override
  void initState() {
    super.initState();
    fetchCarrito(); // Llama a la API cuando se inicia la pantalla
  }

  // Función para hacer la solicitud a la API y obtener los productos del carrito
  Future<void> fetchCarrito() async {
    await UserService().loadToken(); // Cargar el token al inicio
    userId = UserService().userId;

    if (userId != null) {
      final url = 'https://back-end-enfermera.vercel.app/api/carrito/$userId';
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          // print(data);

          // Verificar si 'productos' es una lista
          if (data is List) {
            setState(() {
              productos = List<dynamic>.from(data);
              total = productos.fold(0.0, (sum, item) {
                // Validar que los valores no sean nulos
                double cantidad =
                    double.tryParse(item['cantidad']?.toString() ?? '0.0') ??
                        0.0;
                double precio =
                    double.tryParse(item['precio']?.toString() ?? '0.0') ?? 0.0;
                double descuento =
                    double.tryParse(item['descuento']?.toString() ?? '0.0') ??
                        0.0;

                // Cálculo seguro del subtotal con descuento
                double precioConDescuento =
                    descuento > 0 ? precio * (1 - descuento / 100) : precio;

                // Verificar si los valores son válidos y finitos
                if (cantidad.isFinite && precioConDescuento.isFinite) {
                  return sum + (cantidad * precioConDescuento);
                } else {
                  print('Valores no válidos para: $item');
                  return sum;
                }
              });
              isLoading = false;
            });
          } else {
            print('Error: El campo "productos" no es una lista.');
            setState(() {
              isLoading = false;
            });
          }
        } else {
          print('Error en la solicitud: ${response.statusCode}');
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error al obtener los datos: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('No se pudo obtener el ID del usuario');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Función para actualizar la cantidad de un producto en la API
  Future<void> actualizarCantidadProducto(int index) async {
    final producto = productos[index];
    final idProducto = producto['idProducto'];
    final cantidad = producto['cantidad'];

    if (userId != null) {
      final url =
          'https://back-end-enfermera.vercel.app/api/carrito/$userId/$idProducto';
      try {
        final response = await http.put(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body:
              jsonEncode({'cantidad': cantidad}), // Enviamos la nueva cantidad
        );

        if (response.statusCode == 200) {
          print('Cantidad actualizada correctamente');
        } else {
          print('Error al actualizar cantidad: ${response.statusCode}');
        }
      } catch (e) {
        print('Error al actualizar cantidad: $e');
      }
    }
  }

  // Mostrar el diálogo de confirmación antes de eliminar un producto
  Future<void> _confirmarEliminarProducto(int index) async {
    bool confirmDelete = await showConfirmationDialog(
      context: context,
      title: 'Eliminar producto',
      content:
          '¿Estás seguro de que deseas eliminar este producto del carrito?',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
    );

    if (confirmDelete) {
      eliminarProducto(index); // Llamar a la función para eliminar el producto
    }
  }

  // Función para eliminar un producto de la API
  Future<void> eliminarProducto(int index) async {
    final producto = productos[index];
    final idProducto = producto['idProducto'];

    if (userId != null) {
      final url =
          'https://back-end-enfermera.vercel.app/api/carrito/$userId/$idProducto';
      try {
        final response = await http.delete(Uri.parse(url));

        if (response.statusCode == 200) {
          setState(() {
            productos.removeAt(index); // Eliminar el producto localmente
            recalcularTotal();
          });
          print('Producto eliminado correctamente');
          // Mostrar mensaje de eliminación exitosa
          // AlertMessage.show(
          //   context: context,
          //   message: 'Producto eliminado del carrito',
          //   backgroundColor: Colors.green,
          //   icon: Icons.check_circle,
          // );
          AlertMessage.show(
            context: context,
            message: 'Producto eliminado del carrito',
            type: MessageType.success, // Aquí defines el tipo de mensaje
          );
        } else {
          print('Error al eliminar producto: ${response.statusCode}');
        }
      } catch (e) {
        print('Error al eliminar producto: $e');
      }
    }
  }

  // Función para incrementar la cantidad de un producto
  void incrementarCantidad(int index) {
    setState(() {
      productos[index]['cantidad']++;
      recalcularTotal();
    });
    actualizarCantidadProducto(
        index); // Llamar a la API para actualizar la cantidad
  }

  // Función para disminuir la cantidad de un producto
  void disminuirCantidad(int index) {
    setState(() {
      if (productos[index]['cantidad'] > 1) {
        productos[index]['cantidad']--;
        recalcularTotal();
      }
    });
    actualizarCantidadProducto(
        index); // Llamar a la API para actualizar la cantidad
  }

  // Función para recalcular el total cuando se cambian las cantidades
  void recalcularTotal() {
    total = productos.fold(0.0, (sum, item) {
      double cantidad =
          double.tryParse(item['cantidad']?.toString() ?? '0.0') ?? 0.0;
      double precio =
          double.tryParse(item['precio']?.toString() ?? '0.0') ?? 0.0;
      double descuento =
          double.tryParse(item['descuento']?.toString() ?? '0.0') ?? 0.0;

      double precioConDescuento =
          descuento > 0 ? precio * (1 - descuento / 100) : precio;

      // Validar valores
      return (cantidad.isFinite && precioConDescuento.isFinite)
          ? sum + (cantidad * precioConDescuento)
          : sum;
    });
  }

  void _mostrarDetallesProducto(BuildContext context, dynamic producto) {
    // Calcular el precio con descuento, si aplica
    double precio = double.tryParse(producto['precio'].toString()) ?? 0.0;
    double descuento = double.tryParse(producto['descuento'].toString()) ?? 0.0;
    double precioConDescuento =
        descuento > 0 ? precio * (1 - descuento / 100) : precio;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              producto['nombre'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Alineación centrada
                children: [
                  if (producto['imagenes'] != null &&
                      producto['imagenes'].isNotEmpty)
                    Image.network(
                      producto['imagenes'][0]['url'],
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(height: 10),
                  if (descuento > 0) ...[
                    Text(
                      'Precio Original: \$${producto['precio']}',
                      style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.red, // Color del tachado
                        color: Colors.black, // Color del texto
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Precio con Descuento: \$${precioConDescuento.toStringAsFixed(2)}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ] else
                    Text(
                      'Precio: \$${producto['precio']}',
                      style: TextStyle(fontSize: 18),
                    ),
                  SizedBox(height: 10),
                  Text(
                    'Cantidad: ${producto['cantidad']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  if (producto['talla'] != 'No aplica' &&
                      producto['talla'] != null)
                    Text(
                      'Talla: ${producto['talla']}',
                      style: TextStyle(fontSize: 18),
                    ),
                  if (producto['sexo'] != 'No aplica' &&
                      producto['sexo'] != null)
                    Text(
                      'Sexo: ${producto['sexo']}',
                      style: TextStyle(fontSize: 18),
                    ),
                  if (descuento > 0)
                    Text(
                      'Descuento: ${producto['descuento']}%',
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                child: Text('Cerrar', style: TextStyle(fontSize: 18)),
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

  // Función para mostrar el modal con las opciones de pago
  void _mostrarOpcionesPago(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Con tarjeta'),
                onTap: () {
                  // Lógica para pago con tarjeta
                  Navigator.pop(context); // Cierra el modal
                },
              ),
              ListTile(
                leading: Icon(Icons.paypal),
                title: Text('PayPal'),
                onTap: () {
                  // Lógica para pago con PayPal
                  Navigator.pop(context); // Cierra el modal
                },
              ),
              Divider(),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Color gris para el botón
                    minimumSize: Size.fromHeight(50), // Tamaño mínimo del botón
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Cierra el modal
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : productos.isEmpty
              ? Center(child: Text('No hay productos en el carrito.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: productos.length,
                          itemBuilder: (context, index) {
                            final producto = productos[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Card(
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.info,
                                            color: Colors.black),
                                        onPressed: () {
                                          // Llamar al modal para mostrar los detalles del producto
                                          _mostrarDetallesProducto(
                                              context, producto);
                                        },
                                      ),
                                      Image.network(
                                        producto['imagenes'][0]['url'],
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              producto['nombre'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Cantidad: ${producto['cantidad']}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                                Icons.remove_circle_outline),
                                            onPressed: () {
                                              disminuirCantidad(index);
                                            },
                                          ),
                                          Text(
                                            '${producto['cantidad']}',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          IconButton(
                                            icon:
                                                Icon(Icons.add_circle_outline),
                                            onPressed: () {
                                              incrementarCantidad(index);
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '\$${producto['precio']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          _confirmarEliminarProducto(
                                              index); // Preguntar antes de eliminar
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$$total',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      CustomElevatedButton(
                        text: "Pagar",
                        onPressed: () {
                          _mostrarOpcionesPago(context);
                        },
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          'La entrega del producto será en la tienda.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
