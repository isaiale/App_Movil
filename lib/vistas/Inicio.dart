import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), _checkLoginStatus); // Verificar después de 3 segundos
  }

  // Verificar si el usuario ya ha iniciado sesión
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');  // Recuperar el token

    // Si el token es válido, redirigir a la pantalla principal
    if (token != null && !JwtDecoder.isExpired(token)) {
      Navigator.pushReplacementNamed(context, '/tabs');  // Navegar a la pantalla principal
    } else {
      Navigator.pushReplacementNamed(context, '/login');  // Navegar a la pantalla de Login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: Center(
        child: Image.asset(
          'imagenes/Logo de mi enfermera favorita.jpg',  // Coloca tu logo aquí
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
