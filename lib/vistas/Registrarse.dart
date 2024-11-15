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
        final response = await http.get(
          Uri.parse('https://back-end-enfermera.vercel.app/api/usuario'),
        );
        final usuarios = jsonDecode(response.body);

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
          AlertMessage.show(
            context: context,
            message:
                'Registro exitoso. Revisa tu correo para activar la cuenta.',
            type: MessageType.success,
          );

          nameController.clear();
          lastNameController.clear();
          phoneController.clear();
          emailController.clear();
          passwordController.clear();

          Future.delayed(Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          });
        } else {
          AlertMessage.show(
            context: context,
            message: 'Error al registrar el usuario. Inténtalo nuevamente.',
            type: MessageType.error,
          );
        }
      } catch (error) {
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
      appBar: AppBar(
        backgroundColor: Color(0xFFFF4081),
        elevation: 0,
      ),              
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
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Registro',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.0),

                  CustomTextFormField(
                    labelText: 'Nombre',
                    validationType: 'letters',
                    controller: nameController,
                  ),
                  SizedBox(height: 16.0),

                  CustomTextFormField(
                    labelText: 'Apellido',
                    validationType: 'letters',
                    controller: lastNameController,
                  ),
                  SizedBox(height: 16.0),

                  PhoneNumberField(
                    controller: phoneController,
                  ),
                  SizedBox(height: 16.0),

                  CustomTextFormField(
                    labelText: 'Correo electrónico',
                    validationType: 'gmail',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.0),

                  PasswordFieldRegistro(
                    controller: passwordController,
                  ),
                  SizedBox(height: 16.0),

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
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.0),

                  if (_isLoading)
                    Center(child: CircularProgressIndicator()),

                  CustomElevatedButton(
                    text: "Registrar",
                    onPressed: _register,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
