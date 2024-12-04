import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';// Pantalla de inicio (Splash) */
import 'vistas/Inicio.dart';
import 'vistas/Login.dart'; // Pantalla de login
// import 'vistas/tabs.dart'; // Pantalla principal (con pestañas)
import 'vistas/Registrarse.dart'; // Pantalla de registro
import 'vistas/RecuperacionContra.dart'; // Recuperación de contraseña
import 'vistas/perfil.dart'; // Perfil
import 'vistas/carrito.dart'; // Carrito de compras
import 'vistas/Productos.dart';
import 'vistas/compras.dart';
import 'vistas/Home.dart';


Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://bcac6d0c2038cbcab9987b7b65cda011@o4508372929609728.ingest.us.sentry.io/4508408492523520';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );
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
        '/home': (context)=> Home(),
        // '/tabs': (context) => TabsScreen(), // Pantalla principal
        '/register': (context) => Register(), // Pantalla de registro
        '/recuperar': (context) => PasswordRecoveryScreen(), // Recuperación de contraseña
        '/perfil': (context) => Perfil(), // Perfil del usuario
        '/carrito': (context) => CarritoCompras(), // Carrito de compras
        '/productos': (context)=> Productos(),
        '/compras': (context)=> Compras(),
      },
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
    );
  }
}
