import 'package:flutter_driver/driver_extension.dart';
// import 'package:app_movil/vistas/productos_categoria.dart'; // Ajusta el import según tu estructura
import 'package:app_movil/componentes/productos_categoria.dart';
import 'package:flutter/material.dart';

void main() {
  // Habilitar la extensión de Flutter Driver
  enableFlutterDriverExtension();

  // Cargar la pantalla principal para pruebas
  runApp(
    MaterialApp(
      home: ProductosCategoria(
        categoriaId: '660e8da897d41d20a385ee4f',
        nombreCategoria: 'Accesorios',
      ),
    ),
  );
}
