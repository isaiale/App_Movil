import 'package:flutter/material.dart';
import 'vistas/inicio.dart'; // Pantalla de inicio (Splash)
import 'vistas/login.dart'; // Pantalla de login
import 'vistas/tabs.dart'; // Pantalla principal (con pestañas)
import 'vistas/registrarse.dart'; // Pantalla de registro
import 'vistas/RecuperacionContra.dart'; // Recuperación de contraseña
import 'vistas/perfil.dart'; // Perfil
import 'vistas/carrito.dart'; // Carrito de compras
import 'vistas/Productos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Móvil',
      initialRoute: '/inicio', // Ruta inicial
      routes: {
        '/inicio': (context) => Inicio(), // Splash Screen
        '/login': (context) => Login(), // Pantalla de login
        '/tabs': (context) => TabsScreen(), // Pantalla principal
        '/register': (context) => Register(), // Pantalla de registro
        '/recuperar': (context) => PasswordRecoveryScreen(), // Recuperación de contraseña
        '/perfil': (context) => Perfil(), // Perfil del usuario
        '/carrito': (context) => CarritoCompras(), // Carrito de compras
        '/productos': (context)=> Productos(),
      },
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
    );
  }
}
