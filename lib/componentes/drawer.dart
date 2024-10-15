import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../componentes/ConfirmationDialog.dart'; // Importa el componente de diálogo
import '../servicios/UserService.dart'; // Importa el servicio de usuario para obtener los datos

class DrawerUser extends StatefulWidget {
  @override
  _DrawerUserState createState() => _DrawerUserState();
}

class _DrawerUserState extends State<DrawerUser> {
  Map<String, dynamic>? userInfo; // Información del usuario
  bool isLoading = true; // Estado de carga

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // Cargar información del usuario al iniciar
  }

  // Función para cargar el token y decodificarlo
  Future<void> _loadUserInfo() async {
    await UserService().loadToken();
    setState(() {
      userInfo =
          UserService().decodedToken; // Asignar la información del usuario
      isLoading = false; // Detener la carga
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar un indicador de carga si la información del usuario aún se está obteniendo
    if (isLoading) {
      return Drawer(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Si no hay información del usuario (usuario no logueado), redirigir a login
    if (userInfo == null) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
              child: Text(
                'No se pudo cargar la información del usuario.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Extraer nombre y apellido del usuario
    String nombre = userInfo!['nombre'] ?? 'Nombre no disponible';
    String apellido = userInfo!['apellido'] ?? 'Apellido no disponible';

    // Obtener las iniciales del nombre y apellido
    String iniciales = '${nombre[0]}${apellido[0]}'.toUpperCase();

    // Construir el Drawer con la información del usuario
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.pink,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Text(
                    iniciales,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ), // Muestra las iniciales en lugar de la imagen
                ),
                SizedBox(height: 10),
                Text(
                  '$nombre $apellido', // Mostrar nombre y apellido
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              Navigator.pushReplacementNamed(
                  context, '/tabs'); // Navegar a la pantalla de inicio (o tabs)
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Perfil'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              Navigator.pushNamed(
                  context, '/perfil'); // Navega a la página de perfil
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Carrito de Compras'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              Navigator.pushNamed(context,
                  '/carrito'); // Navega a la página del carrito de compras
            },
          ),

          Divider(), // Línea divisoria
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Salir'),
            onTap: () async {
              // Mostrar el diálogo reutilizable de confirmación antes de salir
              bool shouldLogout = await showConfirmationDialog(
                context: context,
                title: 'Confirmación',
                content: '¿Estás seguro de que deseas cerrar sesión?',
                confirmText: 'Salir',
                cancelText: 'Cancelar',
              );
              if (shouldLogout) {
                await _logout(context); // Si el usuario confirma, cerrar sesión
              }
            },
          ),
        ],
      ),
    );
  }

  // Función para cerrar sesión
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Eliminar el token guardado

    // Redirigir a la pantalla de Login utilizando rutas nombradas
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (Route<dynamic> route) =>
          false, // Elimina todas las pantallas anteriores de la pila de navegación
    );
  }
}
