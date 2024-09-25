import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // importar la dependencia 
import 'tabs.dart'; 

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TabsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              // Encabezado
              Container(
                child: Text(
                  'Inicio de sesion',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0), // Espacio entre el texto y el primer campo
              // Agregamos un ícono de usuario circular
              CircleAvatar(
                radius: 40.0, // Tamaño del ícono circular
                backgroundColor: Colors.grey[300], // Color de fondo
                child: Icon(
                  Icons.person, // Ícono de usuario
                  size: 50.0, // Tamaño del ícono
                  color: Colors.purple, // Color del ícono
                ),
              ),
              SizedBox(height: 16.0), // Espacio debajo del ícono

              // Campo de correo electrónico
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // ... (resto de las propiedades)
              ),
              SizedBox(height: 16.0), // Espacio entre los campos de texto

              // Campo de contraseña
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true, // Para ocultar el texto de la contraseña
              ),
              
              SizedBox(height: 16.0), // Espacio entre los campos de texto y el botón

              // Botón de inicio de sesión
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Color de fondo
                  minimumSize: Size.fromHeight(50), // Tamaño mínimo del botón
                ),
                child: Text("Iniciar Sesión",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                ),
              ),
              SizedBox(height: 16.0), // Espacio debajo del botón

              // Enlace para recuperar la contraseña
              TextButton(
                onPressed: () {},
                child: Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                    fontSize: 16,
                ),
                  ),                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
