import 'package:flutter/material.dart';
import '../componentes/custom_app_bar.dart'; // Importa el CustomAppBar
import 'package:app_movil/componentes/drawer.dart';

class Compras extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Compras'), // Usamos el CustomAppBar
      drawer: DrawerUser(),
      body: Center(
        child: Text('Página de compras'),
      ),
    );
  }
}

