import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Términos y Condiciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Términos y Condiciones',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '1. Introducción\n\n'
                'Estos términos y condiciones establecen las reglas para el uso de nuestro servicio.\n\n'
                '2. Uso del Servicio\n\n'
                'El usuario se compromete a utilizar el servicio de acuerdo con la ley y las normativas aplicables.\n\n'
                '3. Modificaciones\n\n'
                'Nos reservamos el derecho a modificar estos términos en cualquier momento.\n\n'
                '4. Contacto\n\n'
                'Si tienes preguntas sobre estos términos, contáctanos a través de nuestra página de contacto.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Regresar a la pantalla anterior
                },
                child: Text('Cerrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
