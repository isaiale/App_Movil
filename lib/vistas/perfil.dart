import 'package:flutter/material.dart';

class Perfil extends StatelessWidget {
  // Datos del usuario proporcionados
  final String nombre = 'isai';
  final String apellido = 'alejandro';
  final String correo = 'isaialejandro2024@outlook.com';
  final String estado = 'ACTIVO';
  final String telefono = '7891091412';
  final String rol = 'User';
  final String fechaCreado = '2024-02-18';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Contenido del perfil
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80), // Espacio para el Positioned (icono atrás y título)
                // Imagen de perfil con bordes redondeados
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('imagenes/AdminIsai.jpg'), // Ruta de la imagen
                ),
                SizedBox(height: 20),
                // Información del usuario centrada
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$nombre $apellido',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.email, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            correo,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            telefonoo,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            'Estado: $estado',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.lock_outline, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            'Rol: $rol',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.date_range, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            'Miembro desde: $fechaCreado',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
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
          // Botón para volver atrás y título de la pantalla
          Positioned(
            top: 40.0,
            left: 20.0,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          // Título "Perfil" en la parte superior
          Positioned(
            top: 43.0,
            left: 0, // Se asegura de que el Row ocupe todo el ancho
            right: 0, // Se asegura de que el Row ocupe todo el ancho
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Perfil",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
