import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa intl para formatear fechas
import '../servicios/UserService.dart'; // Importa el servicio de usuario
import '../componentes/custom_app_bar.dart';
import 'package:app_movil/componentes/drawer.dart';

class Perfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener la información decodificada del token
    final userInfo = UserService().decodedToken;

    // Verifica si la información del usuario está disponible
    if (userInfo == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Perfil'),
        ),
        body: Center(
          child: Text('No se pudo cargar la información del usuario.'),
        ),
      );
    }

    // Extraer la información específica del usuario del token decodificado
    String nombre = userInfo['nombre'] ?? 'Nombre';
    String apellido = userInfo['apellido'] ?? 'Apellido';
    String correo = userInfo['correo'] ?? 'Correo no disponible';
    String estado = userInfo['estado'] ?? 'Estado no disponible';
    String telefono = userInfo['numeroTelefono'] ?? 'Teléfono no disponible';
    String rol = userInfo['rol'] ?? 'Rol no disponible';

    // Obtener las iniciales del nombre y apellido
    String iniciales = '${nombre[0]}${apellido[0]}'.toUpperCase();

    // Obtener la fecha de creación y formatearla
    String fechaCreado =
        userInfo['fechaCreado'] ?? 'Fecha de creación no disponible';
    String formattedDate;

    try {
      DateTime parsedDate = DateTime.parse(fechaCreado);
      formattedDate = DateFormat('yyyy/MM/dd').format(parsedDate);
    } catch (e) {
      formattedDate = 'Fecha inválida';
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Perfil'),
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      // ),
      appBar: CustomAppBar(title: 'Perfil'),
      drawer: DrawerUser(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Encabezado del perfil con un fondo atractivo
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.deepPurple],/* pinkAccent */
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.white,
                      child: Text(
                        iniciales,
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      '$nombre $apellido',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      correo,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),

              // Detalles del perfil organizados en tarjetas
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.phone, color: Colors.pinkAccent),
                  title: Text(
                    'Teléfono:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    telefono,
                    style: TextStyle(fontSize: 16.0, color: Colors.black87),
                  ),
                ),
              ),
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading:
                      Icon(Icons.check_circle_outline, color: Colors.green),
                  title: Text(
                    'Estado:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    estado,
                    style: TextStyle(fontSize: 16.0, color: Colors.black87),
                  ),
                ),
              ),
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.lock_outline, color: Colors.blue),
                  title: Text(
                    'Rol:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    rol,
                    style: TextStyle(fontSize: 16.0, color: Colors.black87),
                  ),
                ),
              ),
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.date_range, color: Colors.orange),
                  title: Text(
                    'Miembro desde:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    formattedDate,
                    style: TextStyle(fontSize: 16.0, color: Colors.black87),
                  ),
                ),
              ),

              // Botón de acción al final
              const SizedBox(height: 30.0),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              //     backgroundColor: Colors.deepPurple,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20.0),
              //     ),
              //   ),
              //   onPressed: () {
              //     // Acción al presionar
              //   },
              //   child: const Text(
              //     'Actualizar Perfil',
              //     style: TextStyle(fontSize: 18.0, color: Colors.white),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
