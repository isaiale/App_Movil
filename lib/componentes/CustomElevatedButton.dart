import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFF4081), // Color de fondo
        minimumSize: Size.fromHeight(50), // Tamaño mínimo del botón
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white, // Color del texto
          fontSize: 18, // Tamaño del texto
        ),
      ),
    );
  }
}
