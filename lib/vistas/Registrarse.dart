import 'package:flutter/material.dart';
import 'package:app_movil/componentes/CustomTextFormField.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../componentes/CustomElevatedButton.dart';
import '../componentes/AlertMessage.dart';
import 'TerminoCondiciones.dart';
import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _acceptTerms = false;
  bool _isLoading = false; // Para mostrar un indicador de carga

  void _register() async {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Verificar si el correo ya existe
        final response = await http.get(
          Uri.parse('https://back-end-enfermera.vercel.app/api/usuario'),
        );
        final usuarios = jsonDecode(response.body);

        // Verificar si el correo ya está en uso
        if (usuarios
            .any((usuario) => usuario['correo'] == emailController.text)) {
          AlertMessage.show(
            context: context,
            message: 'El correo ya existe. Utiliza otro',
            type: MessageType.warning,
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Si no está en uso, proceder con el registro
        final registerResponse = await http.post(
          Uri.parse('https://back-end-enfermera.vercel.app/api/usuario'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'nombre': nameController.text,
            'apellido': lastNameController.text,
            'correo': emailController.text,
            'contraseña': passwordController.text,
            'numeroTelefono': phoneController.text,
          }),
        );

        if (registerResponse.statusCode == 201) {
          // Registro exitoso
          AlertMessage.show(
            context: context,
            message:
                'Registro exitoso. Revisa tu correo para activar la cuenta.',
            type: MessageType.success,
          );

          // Limpiar los campos después de un registro exitoso
          nameController.clear();
          lastNameController.clear();
          phoneController.clear();
          emailController.clear();
          passwordController.clear();

          // Esperar 2 segundos antes de navegar a la pantalla de login
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          });
        } else {
          // Error en el registro
          AlertMessage.show(
            context: context,
            message: 'Error al registrar el usuario. Inténtalo nuevamente.',
            type: MessageType.error,
          );
        }
      } catch (error) {
        // Error al hacer la solicitud
        AlertMessage.show(
          context: context,
          message: 'Error al conectar con el servidor. Inténtalo más tarde.',
          type: MessageType.error,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else if (!_acceptTerms) {
      // Mostrar error si no aceptan los términos
      AlertMessage.show(
          context: context,
          message: 'Debes aceptar los términos y condiciones',
          type: MessageType.info,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                child: Text(
                  'Registro',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // Campo de nombre (solo letras y primera letra mayúscula)
              CustomTextFormField(
                labelText: 'Nombre',
                validationType: 'letters', // Validación para solo letras
                controller: nameController,
              ),
              SizedBox(height: 16.0),

              // Campo de apellido (solo letras y primera letra mayúscula)
              CustomTextFormField(
                labelText: 'Apellido',
                validationType: 'letters', // Validación para solo letras
                controller: lastNameController,
              ),
              SizedBox(height: 16.0),

              // Campo de teléfono (usando PhoneNumberField)
              PhoneNumberField(
                controller: phoneController,
              ),
              SizedBox(height: 16.0),

              // Campo de correo electrónico
              CustomTextFormField(
                labelText: 'Correo electrónico',
                validationType: 'gmail',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),

              // Campo de contraseña utilizando el componente especializado PasswordField
              PasswordFieldRegistro(
                controller: passwordController,
              ),
              SizedBox(height: 16.0),

              // Checkbox para aceptar términos y condiciones
              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (bool? value) {
                      setState(() {
                        _acceptTerms = value ?? false;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsAndConditionsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Aceptar los términos y condiciones',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),

              // Mostrar indicador de carga si está en progreso
              if (_isLoading) CircularProgressIndicator(),

              // Botón de registro
              CustomElevatedButton(
                text: "Registrar",
                onPressed: _register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
