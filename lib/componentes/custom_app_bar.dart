import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLogo;

  CustomAppBar({required this.title, this.showLogo = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.pink,
      iconTheme: IconThemeData(
        color: Colors.white, // Asegura que el ícono del Drawer sea blanco
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: showLogo
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Fondo blanco
                    shape: BoxShape.circle, // Borde circular
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Sombra suave
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Sombra bajo el círculo
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Espacio interno para la imagen
                    child: Image.asset(
                      'imagenes/Logo de mi enfermera favorita.jpg',
                      fit: BoxFit.contain,
                      height: 40, // Altura ajustada para la imagen
                    ),
                  ),
                ),
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
