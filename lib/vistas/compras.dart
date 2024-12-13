import 'package:flutter/material.dart';
import '../componentes/custom_app_bar.dart';
import 'package:app_movil/componentes/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../servicios/UserService.dart'; // Importa el UserService
import 'package:intl/intl.dart'; // Para formatear fechas

class Compras extends StatefulWidget {
  @override
  _ComprasState createState() => _ComprasState();
}

class _ComprasState extends State<Compras> {
  List<dynamic> _compras = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedOrder = 'Recientes'; // Valor por defecto del filtro

  @override
  void initState() {
    super.initState();
    _fetchCompras();
  }

  // Método para consumir la API y filtrar las compras con estado "completado"
  Future<void> _fetchCompras() async {
    final userId = UserService().userId;

    if (userId == null) {
      print('Error: userId es nulo.');
      setState(() {
        _isLoading = false;
        _errorMessage = 'No se encontró el ID de usuario.';
      });
      return;
    }

    print('User ID obtenido: $userId');

    final url =
        Uri.parse('https://back-end-enfermera.vercel.app/api/detalle/$userId');
    print('Llamando a la API: $url');

    try {
      final response = await http.get(url);
      // print('Estado de la respuesta: ${response.statusCode}');

      if (response.statusCode == 200) {
        // print('Respuesta completa: ${response.body}');
        final List<dynamic> compras = jsonDecode(response.body);

        if (compras.isEmpty) {
          print('No se encontraron compras para este usuario.');
        }

        final pagadas = compras
            .where((compra) => compra['estado'] == 'completado')
            .toList();

        setState(() {
          _compras = pagadas;
          _sortCompras(); // Ordenar según el criterio seleccionado
          _isLoading = false;
        });
      } else {
        throw Exception('Error al obtener las compras: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al consumir la API: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al obtener las compras.';
      });
    }
  }

  // Método para ordenar la lista de compras según la fecha
  void _sortCompras() {
    setState(() {
      _compras.sort((a, b) {
        final dateA = DateTime.parse(a['fechaCompra']);
        final dateB = DateTime.parse(b['fechaCompra']);

        if (_selectedOrder == 'Recientes') {
          return dateB.compareTo(dateA); // Ordenar por más recientes
        } else {
          return dateA.compareTo(dateB); // Ordenar por más antiguas
        }
      });
    });
  }

  String _formatDate(String fecha) {
    final DateTime parsedDate = DateTime.parse(fecha);
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Compras'),
      drawer: DrawerUser(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        value: _selectedOrder,
                        items: <String>['Recientes', 'Antiguas']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text('Ordenar por: $value'),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedOrder = newValue!;
                            _sortCompras(); // Ordenar cuando se cambia el filtro
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _compras.length,
                        itemBuilder: (context, index) {
                          final compra = _compras[index];
                          final productos =
                              compra['productos'] as List<dynamic>;
                          final String fechaCompra =
                              _formatDate(compra['fechaCompra']);

                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.1), // Sombra ligera
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(0, 4), // Posición de la sombra
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Fecha de la compra
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Fecha:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        fechaCompra,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.0),

                                  // Total de la compra
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        '\$${compra['total']}',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.0),

                                  // Estado de la compra
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Estado:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        compra['estado'],
                                        style: TextStyle(
                                          color:
                                              compra['estado'] == 'Completado'
                                                  ? Colors.green
                                                  : Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),

                                  // Lista de productos
                                  Text(
                                    'Productos:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),

                                  ...productos.map((producto) {
                                    final prod = producto['producto'];
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 10.0),
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        children: [
                                          // Imagen del producto
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              prod['imagenes'][0]['url'],
                                              width: 50.0,
                                              height: 50.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(width: 10.0),

                                          // Detalles del producto
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  prod['nombre'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                                SizedBox(height: 5.0),
                                                Text(
                                                  'Cantidad: ${producto['cantidad']}',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Precio del producto
                                          Text(
                                            '\$${producto['precioUnitario']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
