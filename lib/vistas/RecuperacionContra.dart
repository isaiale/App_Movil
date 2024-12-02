import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../componentes/CustomElevatedButton.dart';
import '../componentes/CustomTextFormField.dart';
import '../componentes/AlertMessage.dart';
import 'Login.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  int _currentStep = 0;
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false; // Indicador de carga

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Text(
              'Recuperar Contraseña',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Theme(
            data: ThemeData(
              colorScheme: ColorScheme.light(primary: Colors.green),
            ),
            child: SizedBox(
              height: 100,
              child: Stepper(
                type: StepperType.horizontal,
                currentStep: _currentStep,
                onStepContinue: _onStepContinue,
                onStepCancel: _currentStep == 0 ? null : _onStepCancel,
                steps: [
                  Step(
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    title: Text(''),
                    content: Container(),
                  ),
                  Step(
                    isActive: _currentStep >= 1,
                    state: _currentStep > 1
                        ? StepState.complete
                        : StepState.indexed,
                    title: Text(''),
                    content: Container(),
                  ),
                  Step(
                    isActive: _currentStep >= 2,
                    state: _currentStep == 2
                        ? StepState.indexed
                        : StepState.complete,
                    title: Text(''),
                    content: Container(),
                  ),
                ],
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  return Container(); // No controles debajo del Stepper
                },
              ),
            ),
          ),
          _isLoading ? CircularProgressIndicator() : _buildStepContent(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                CustomElevatedButton(
                  text: _currentStep == 2
                      ? 'Cambiar Contraseña'
                      : _currentStep == 1
                          ? 'Verificar Código'
                          : 'Enviar Correo',
                  onPressed: _onStepContinue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Ingresa tu correo electrónico para restablecer tu contraseña',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                labelText: 'Correo electrónico',
                validationType: 'gmail',
                controller: _emailController,
              ),
            ],
          ),
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Se ha enviado un código de verificación a tu correo electrónico',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: 'Código de verificación',
                validationType: 'text',
                controller: _codeController,
              ),
            ],
          ),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Ingresa tu nueva contraseña',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              PasswordField(controller: _passwordController),
              SizedBox(height: 10),
              PasswordField(controller: _confirmPasswordController), // Para confirmar la contraseña
            ],
          ),
        );
      default:
        return Container();
    }
  }

  // Función para continuar al siguiente paso o enviar el correo
  void _onStepContinue() async {
    if (_currentStep == 0) {
      await _sendEmail();
    } else if (_currentStep == 1) {
      await _verifyCode();
    } else if (_currentStep == 2) {
      await _resetPassword();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  // Función para enviar el correo y manejar la respuesta de la API
  Future<void> _sendEmail() async {
    final email = _emailController.text;

    if (email.isEmpty) {
      AlertMessage.show(
        context: context,
        message: 'Por favor ingresa tu correo electrónico',
        type: MessageType.error,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://back-end-enfermera.vercel.app/api/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo': email}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _currentStep = 1;
        });
        AlertMessage.show(
          context: context,
          message: 'Correo enviado con éxito',
          type: MessageType.success,
        );
      } else {
        final responseData = json.decode(response.body);
        AlertMessage.show(
          context: context,
          message: 'Error: ${responseData['message']}',
          type: MessageType.error,
        );
      }
    } catch (e) {
      AlertMessage.show(
        context: context,
        message: 'Error al enviar el correo',
        type: MessageType.error,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Función para verificar el código y manejar la respuesta de la API
  Future<void> _verifyCode() async {
    final email = _emailController.text;
    final verificationCode = _codeController.text;

    if (verificationCode.isEmpty) {
      AlertMessage.show(
        context: context,
        message: 'Por favor ingresa el código de verificación',
        type: MessageType.error,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://back-end-enfermera.vercel.app/api/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo': email, 'verificationCode': verificationCode}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _currentStep = 2;
        });
        AlertMessage.show(
          context: context,
          message: 'Código verificado con éxito',
          type: MessageType.success,
        );
      } else {
        final responseData = json.decode(response.body);
        AlertMessage.show(
          context: context,
          message: 'Error: ${responseData['message']}',
          type: MessageType.error,
        );
      }
    } catch (e) {
      AlertMessage.show(
        context: context,
        message: 'Error al verificar el código',
        type: MessageType.error,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Función para restablecer la contraseña y manejar la respuesta de la API
  Future<void> _resetPassword() async {
    final email = _emailController.text;
    final verificationCode = _codeController.text;
    final newPassword = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      AlertMessage.show(
        context: context,
        message: 'Las contraseñas no coinciden',
        type: MessageType.error,
      );
      return;
    }

    if (newPassword.isEmpty) {
      AlertMessage.show(
        context: context,
        message: 'Por favor ingresa tu nueva contraseña',
        type: MessageType.error,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://back-end-enfermera.vercel.app/api/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': email,
          'verificationCode': verificationCode,
          'newPassword': newPassword
        }),
      );

      if (response.statusCode == 200) {
        AlertMessage.show(
          context: context,
          message: 'Contraseña restablecida correctamente',
          type: MessageType.success,
        );
        // Navigator.pushReplacementNamed(context, '/login'); // Redirige a la pantalla de login
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),  // Navegar a la pantalla de Login
      );
      } else {
        final responseData = json.decode(response.body);
        AlertMessage.show(
          context: context,
          message: 'Error: ${responseData['message']}',
          type: MessageType.error,
        );
      }
    } catch (e) {
      AlertMessage.show(
        context: context,
        message: 'Error al restablecer la contraseña',
        type: MessageType.error,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
