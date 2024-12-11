import 'package:flutter/material.dart';

class TestComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Component')),
      body: Center(
        child: ElevatedButton(
          key: const ValueKey('error_button'),
          onPressed: () {
            throw Exception('Error simulado en el TestComponent');
          },
          child: const Text('Generar Error'),
        ),
      ),
    );
  }
}
