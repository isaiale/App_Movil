import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa intl para formatear fechas
import '../servicios/UserService.dart'; // Importa el servicio de usuario

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
    String fechaCreado = userInfo['fechaCreado'] ?? 'Fecha de creación no disponible';
    String formattedDate;

    try {
      DateTime parsedDate = DateTime.parse(fechaCreado);
      formattedDate = DateFormat('yyyy/MM/dd').format(parsedDate);
    } catch (e) {
      formattedDate = 'Fecha inválida';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.pink,
              child: Text(
                iniciales,
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              '$nombre $apellido',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email, color: Colors.grey),
                SizedBox(width: 8.0),
                Text(
                  correo,
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone, color: Colors.grey),
                SizedBox(width: 8.0),
                Text(
                  telefono,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, color: Colors.grey),
                SizedBox(width: 8.0),
                Text(
                  'Estado: $estado',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, color: Colors.grey),
                SizedBox(width: 8.0),
                Text(
                  'Rol: $rol',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.date_range, color: Colors.grey),
                SizedBox(width: 8.0),
                Text(
                  'Miembro desde: $formattedDate',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Botón para editar perfil
            ElevatedButton(
              onPressed: () {
                // Navegar a pantalla de edición de perfil o abrir modal
              },
              child: Text('Editar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
