import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../servicios/UserService.dart';
import '../componentes/CustomElevatedButton.dart';
import '../componentes/ConfirmationDialog.dart';
import '../componentes/AlertMessage.dart';
import '../componentes/productlistview.dart';
import '../componentes/showDialogModalProducto.dart';
import '../componentes/paymentStripe.dart';
import 'package:app_movil/componentes/drawer.dart';
import '../componentes/custom_app_bar.dart';

class CarritoCompras extends StatefulWidget {
  @override
  _CarritoComprasState createState() => _CarritoComprasState();
}

class _CarritoComprasState extends State<CarritoCompras> {
  List<dynamic> productos = []; // Aquí se almacenarán los productos
  Map<String, dynamic>? userInfo;
  bool isLoading = true; // Indicador de carga
  double total = 0.0; // Total inicial
  String? userId; // Para almacenar el ID del usuario
  String? nombre;
  String? apellido;
  String? correo;

  @override
  void initState() {
    super.initState();
    fetchCarrito(); // Llama a la API cuando se inicia la pantalla
  }

  // Función para hacer la solicitud a la API y obtener los productos del carrito
  Future<void> fetchCarrito() async {
    await UserService().loadToken(); // Cargar el token al inicio
    userId = UserService().userId;
    userInfo = UserService().decodedToken;
    nombre = userInfo!['nombre'];
    apellido = userInfo!['apellido'];
    correo = userInfo!['correo'];
    print(
        'Este es el nombre del usuario $nombre, $apellido, con el correo $correo');

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
    ProductDetailsDialog.show(
      context,
      producto: producto,
    );
  }

  // Función para mostrar el modal con las opciones de pago
  void _mostrarOpcionesPago(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selecciona tu método de pago',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10.0),
              Divider(
                thickness: 1,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 10.0),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent.withOpacity(0.2),
                  ),
                  child:
                      const Icon(Icons.credit_card, color: Colors.blueAccent),
                ),
                title: const Text(
                  'Con tarjeta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Cierra el modal
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        productosCarrito: productos,
                        user: {
                          "nombre": nombre,
                          "apellido": apellido,
                          "correo": correo,
                          "_id": userId,
                        },
                        total: total,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10.0),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber.withOpacity(0.2),
                  ),
                  child: const Icon(Icons.paypal, color: Colors.amber),
                ),
                title: const Text(
                  'PayPal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Cierra el modal
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pago con PayPal no implementado.'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10.0),
              Divider(
                thickness: 1,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.pop(context); // Cierra el modal
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
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
        appBar: CustomAppBar(title: 'Carrito de Compras'),
        drawer: DrawerUser(),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : productos.isEmpty
                ? Center(child: Text('No hay productos en el carrito.'))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        // Lista de productos con diseño mejorado
                        Expanded(
                          child: ProductListView(
                            productos: productos,
                            disminuirCantidad: disminuirCantidad,
                            incrementarCantidad: incrementarCantidad,
                            mostrarDetallesProducto: _mostrarDetallesProducto,
                            confirmarEliminarProducto:
                                _confirmarEliminarProducto,
                          ),
                        ),
                        const Divider(thickness: 1.5, color: Colors.grey),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '\$$total',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomElevatedButton(
                          text: "Pagar",
                          onPressed: () {
                            _mostrarOpcionesPago(context);
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            '📍 La entrega del producto será en la tienda.',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
  }
}
