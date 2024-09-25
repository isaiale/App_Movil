import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart'; // Importamos la pantalla de Login

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  void initState() {
    super.initState();
    // Redirige a la pantalla de login después de 3 segundos
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: Center(
        child: Image.asset(
          'imagenes/Logo de mi enfermera favorita.jpg',  // Coloca tu imagen aquí (por ejemplo, logo)
          width: 150,          // Ajusta el tamaño según lo necesites
          height: 150,
        ),
      ),
    );
  }
}
