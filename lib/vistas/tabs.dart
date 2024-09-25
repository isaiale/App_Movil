import 'package:flutter/material.dart';
import 'productos.dart';
import 'Home.dart'; // Importa la nueva pantalla Home
import 'compras.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;

  // Lista de pantallas, reemplaza Perfil() por Home()
  final List<Widget> _pages = [
    Productos(),
    Home(),
    Compras(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Cambia entre las páginas según el índice seleccionado
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Cambia el ícono a uno relacionado con Home
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Compras',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.pink, // Color de fondo del BottomNavigationBar
        selectedItemColor: Colors.white, // Color de los íconos y texto seleccionados
        unselectedItemColor: Colors.white, // Color de los íconos y texto no seleccionados
        onTap: _onItemTapped,
      ),
    );
  }
}
