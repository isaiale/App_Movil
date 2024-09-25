import 'package:flutter/material.dart';
import 'vistas/inicio.dart'; // Importa la pantalla de inicio

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Móvil',
      home: Inicio(),  // Empieza con la pantalla de inicio (Splash Screen)
    );
  }
}
