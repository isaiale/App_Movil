import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../componentes/ConfirmationDialog.dart'; // Importa el componente de diálogo
import '../servicios/UserService.dart'; // Importa el servicio de usuario para obtener los datos

class DrawerUser extends StatefulWidget {
  @override
  _DrawerUserState createState() => _DrawerUserState();
}

class _DrawerUserState extends State<DrawerUser> {
  Map<String, dynamic>? userInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    await UserService().loadToken();
    setState(() {
      userInfo = UserService().decodedToken;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Drawer(
        child: Center(child: CircularProgressIndicator()),
      );
    }

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

    String nombre = userInfo!['nombre'] ?? 'Nombre no disponible';
    String apellido = userInfo!['apellido'] ?? 'Apellido no disponible';
    String iniciales = '${nombre[0]}${apellido[0]}'.toUpperCase();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF4081), Color(0xFFFF4081)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Text(
                    iniciales,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$nombre $apellido',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.black54),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.black54),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/perfil');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart, color: Colors.black54),
            title: const Text('Carrito de Compras'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/carrito');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag, color: Colors.black54),
            title: const Text('Compras'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/compras');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Salir'),
            onTap: () async {
              bool shouldLogout = await showConfirmationDialog(
                context: context,
                title: 'Confirmación',
                content: '¿Estás seguro de que deseas cerrar sesión?',
                confirmText: 'Salir',
                cancelText: 'Cancelar',
              );
              if (shouldLogout) {
                await _logout(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (Route<dynamic> route) => false,
    );
  }
}
