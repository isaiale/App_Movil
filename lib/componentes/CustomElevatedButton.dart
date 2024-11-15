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
        backgroundColor: const Color(0xFFFF4081), // Color de fondo
        foregroundColor: Colors.white, // Color del texto
        minimumSize: const Size.fromHeight(50), // Altura mínima
        elevation: 6, // Sombra del botón
        shadowColor: Colors.pinkAccent, // Color de la sombra
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Bordes redondeados
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18, // Tamaño del texto
          fontWeight: FontWeight.bold, // Negrita para destacar el texto
          letterSpacing: 1.2, // Espaciado entre letras
        ),
      ),
    );
  }
}
