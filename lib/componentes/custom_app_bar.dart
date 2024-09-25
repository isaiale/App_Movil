import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showCart;

  CustomAppBar({required this.title, this.showCart = true});

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
      actions: showCart
          ? [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Lógica para el carrito de compras
                },
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
