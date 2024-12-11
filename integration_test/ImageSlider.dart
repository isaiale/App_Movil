import 'package:flutter/material.dart';
import 'package:app_movil/componentes/image_slider.dart';

class TestImageSliderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Test Image Slider')),
        body: Center(
          child: ImageSlider(), // Aquí se renderiza el componente a probar
        ),
      ),
    );
  }
}
