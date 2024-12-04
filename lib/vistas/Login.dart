import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../componentes/CustomTextFormField.dart';
import '../componentes/CustomElevatedButton.dart';
import '../componentes/AlertMessage.dart'; // Importa el componente de alerta
import '../servicios/UserService.dart'; // Importa el servicio de usuario

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  // Función para iniciar sesión
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final url =
          Uri.parse('https://back-end-enfermera.vercel.app/api/auth/login');
      final body = {
        'correo': emailController.text,
        'contraseña': passwordController.text,
      };

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final token = data['token'];
          await UserService().saveToken(token);

          AlertMessage.show(
            context: context,
            message: 'Inicio de sesión exitoso',
            type: MessageType.success,
          );

          // Navegar a la pantalla principal utilizando rutas nombradas
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Decodificar la respuesta de error de la API
          final errorData = jsonDecode(response.body);
          final errorMessage =
              errorData['message'] ?? 'Error al iniciar sesión';

          // Mostrar el mensaje de error específico que devuelve la API
          AlertMessage.show(
            context: context,
            message: errorMessage,
            type: MessageType.error,
          );
        }
      } catch (error) {
        AlertMessage.show(
          context: context,
          message: 'Ocurrió un error. Intente de nuevo más tarde.',
          type: MessageType.error,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Función para navegar a la pantalla de registro
  void _navigateToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  // Función para navegar a la pantalla de recuperación de contraseña
  void _navigateToRecuperarContrasena() {
    Navigator.pushNamed(context, '/recuperar');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF4081), // Color degradado superior
              Color(0xFFF1F1F1), // Color degradado inferior
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    CustomTextFormField(
                      labelText: 'Correo electrónico',
                      validationType: 'gmail',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16.0),
                    PasswordField(
                      controller: passwordController,
                    ),
                    const SizedBox(height: 8.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _navigateToRecuperarContrasena,
                        child: const Text(
                          'Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : CustomElevatedButton(
                            text: "Iniciar Sesión",
                            onPressed: _login,
                          ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "No tienes cuenta? ",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: _navigateToRegister,
                          child: const Text(
                            'Registrate',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32.0),

                    // Agregar botón de prueba de error
                    ElevatedButton(
                      onPressed: () {
                        throw Exception('This is a test exception for Sentry!');
                      },
                      child: Text('Probar Error de Sentry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
