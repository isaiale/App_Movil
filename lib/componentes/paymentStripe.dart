import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final List<dynamic> productosCarrito;
  final Map<String, dynamic> user;
  final double total;

  const PaymentPage({
    Key? key,
    required this.productosCarrito,
    required this.user,
    required this.total,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late WebViewController controller;
  bool _isLoading = true;
  String? _sessionUrl;
  final String _stripeEndpoint =
      'https://back-end-enfermera.vercel.app/api/stripe/create-checkout-session'; // Reemplaza con tu URL real

  @override
  void initState() {
    super.initState();
    _handlePayment(); // Procesar el pago y obtener la sesión
  }

  Future<void> _handlePayment() async {
    try {
      final data = {
        "tipoEntrega": "delivery",
        "dateselect": DateTime.now().toIso8601String().split('T')[0],
        "productos": widget.productosCarrito,
        "datoscliente": {
          "name": widget.user['nombre'],
          "paternalLastname": widget.user['apellido'],
          "email": widget.user['correo'],
          "idUser": widget.user['_id'],
        },
        "instruction": "El producto se recoge en la tienda",
        "total": widget.total,
      };

      print('Enviando datos de pago: $data');

      final response = await http.post(
        Uri.parse(_stripeEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Error al procesar el pago (Status Code: ${response.statusCode})');
      }

      final responseData = jsonDecode(response.body);

      if (!responseData.containsKey('sessionUrl') ||
          responseData['sessionUrl'] == null) {
        throw Exception('URL de sesión no encontrada en la respuesta.');
      }

      setState(() {
        _sessionUrl = responseData['sessionUrl'];
        _isLoading = false;

        // Configurar el WebViewController con JavaScript habilitado
        controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted) // Habilitar JavaScript
          ..loadRequest(Uri.parse(_sessionUrl!));
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error al procesar el pago: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Procesar Pago'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sessionUrl != null
              ? WebViewWidget(controller: controller)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Error al procesar el pago.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _handlePayment,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
