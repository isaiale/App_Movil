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
      options.dsn = 'https://3c00a4d9f334ee73c9d350fcd1dc90bd@o4508372929609728.ingest.us.sentry.io/4508373476507648';
      options.tracesSampleRate = 1.0;
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
      navigatorObservers: [
        SentryNavigatorObserver(), // Rastrear navegación
      ],
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
