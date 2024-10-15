import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para los input formatters

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String validationType;
  final TextEditingController controller;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    required this.validationType,
    required this.controller,
  }) : super(key: key);

  // Método de validación para diferentes tipos de inputs
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa $labelText';
    }

    if (validationType == 'gmail') {
      final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!regex.hasMatch(value)) {
        return 'Ingresa un correo válido de Gmail';
      }
    } else if (validationType == 'password') {
      if (value.length < 8) {
        return 'La contraseña debe tener al menos 8 caracteres';
      }
    } else if (validationType == 'telefono') {
      final regex = RegExp(r'^[0-9]+$');
      if (!regex.hasMatch(value)) {
        return 'Este campo solo acepta números';
      } else if (value.length != 10) {
        return 'El teléfono debe tener exactamente 10 números';
      }
    } else if (validationType == 'letters') {
      final regex = RegExp(r'^[a-zA-Z ]+$'); // Solo letras y espacios
      if (!regex.hasMatch(value)) {
        return 'Este campo solo acepta letras';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black, // Cambia el color del label a negro
          fontSize: 20, // Cambia el tamaño del texto del label
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black, // Cambia el color del borde a negro
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.5,
          ),
        ),
        errorStyle: TextStyle(
          fontSize: 16, // Tamaño del texto del mensaje de error
          color: Colors.red, // Color del texto de error
        ),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(
        color: Colors.black, // Color del texto dentro del campo
        fontSize: 18, // Tamaño del texto dentro del campo
      ),
      validator: validate,
      // Aplicar los inputFormatters solo si es para letras
      inputFormatters: validationType == 'letters'
          ? [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
              TextCapitalizationFormatter(), // Formateador personalizado para capitalizar
            ]
          : [],
    );
  }
}

// Formateador personalizado para convertir la primera letra de cada palabra en mayúscula
class TextCapitalizationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final capitalizedText = _capitalizeWords(text);
    return newValue.copyWith(
      text: capitalizedText,
      selection: TextSelection.collapsed(offset: capitalizedText.length),
    );
  }

  // Función para capitalizar la primera letra de cada palabra
  String _capitalizeWords(String text) {
    return text
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }
}

// Campo de texto exclusivo para teléfono
class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneNumberField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa el teléfono';
    }

    if (value.length != 10) {
      return 'El teléfono debe tener exactamente 10 números';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Teléfono',
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.5,
          ),
        ),
        errorStyle: TextStyle(
          fontSize: 16,
          color: Colors.red,
        ),
      ),
      keyboardType: TextInputType.phone,
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Solo números
        LengthLimitingTextInputFormatter(10), // Limitar a 10 dígitos
      ],
      validator: validatePhoneNumber,
    );
  }
}

// Campo de texto exclusivo para contraseña con visibilidad alternable
class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({Key? key, required this.controller}) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa la contraseña';
    }
    if (value.length < 5) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.5,
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: _toggleVisibility,
        ),
        errorStyle: TextStyle(
          fontSize: 16,
          color: Colors.red,
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
      validator: validatePassword,
    );
  }
}

class PasswordFieldRegistro extends StatefulWidget {
  final TextEditingController controller;

  const PasswordFieldRegistro({Key? key, required this.controller}) : super(key: key);

  @override
  _PasswordFieldStateRegistro createState() => _PasswordFieldStateRegistro();
}

class _PasswordFieldStateRegistro extends State<PasswordFieldRegistro> {
  bool _obscureText = true;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigit = false;
  bool _hasSpecialCharacter = false;
  bool _hasMinLength = false;
  bool _showCriteria = false; // Esta bandera controla si se muestran los criterios

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa la contraseña';
    }
    return null;
  }

  // Actualizar las reglas conforme el usuario escribe
  void _updatePasswordCriteria(String value) {
    setState(() {
      _hasUppercase = value.contains(RegExp(r'[A-Z]')); // Mayúsculas
      _hasLowercase = value.contains(RegExp(r'[a-z]')); // Minúsculas
      _hasDigit = value.contains(RegExp(r'[0-9]')); // Números
      _hasSpecialCharacter = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')); // Caracteres especiales
      _hasMinLength = value.length >= 8; // Longitud mínima
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          onChanged: (value) {
            _updatePasswordCriteria(value);
            if (value.isNotEmpty && !_showCriteria) {
              setState(() {
                _showCriteria = true; // Mostrar los criterios cuando el usuario empiece a escribir
              });
            }
          },
          decoration: InputDecoration(
            labelText: 'Contraseña',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: _toggleVisibility,
            ),
            errorStyle: TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
          keyboardType: TextInputType.visiblePassword,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          validator: validatePassword,
        ),
        SizedBox(height: 10),

        // Solo mostrar las reglas que no están cumplidas si _showCriteria es true
        if (_showCriteria &&
            (!_hasMinLength || !_hasUppercase || !_hasLowercase || !_hasDigit || !_hasSpecialCharacter))
          Text(
            'La contraseña debe tener:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        SizedBox(height: 5),

        // Mostrar los criterios que aún no se cumplen
        if (_showCriteria && !_hasMinLength)
          _buildPasswordCriteriaText('Al menos 8 caracteres'),
        if (_showCriteria && !_hasUppercase)
          _buildPasswordCriteriaText('Una letra mayúscula'),
        if (_showCriteria && !_hasLowercase)
          _buildPasswordCriteriaText('Una letra minúscula'),
        if (_showCriteria && !_hasDigit) _buildPasswordCriteriaText('Un número'),
        if (_showCriteria && !_hasSpecialCharacter)
          _buildPasswordCriteriaText('Un carácter especial (!@#\$%^&*)'),
      ],
    );
  }

  // Widget para mostrar cada criterio
  Widget _buildPasswordCriteriaText(String text) {
    return Row(
      children: [
        Icon(
          Icons.cancel,
          color: Colors.red,
          size: 18,
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
