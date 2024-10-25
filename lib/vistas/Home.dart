import 'package:flutter/material.dart';
import 'package:app_movil/componentes/drawer.dart';
import 'package:app_movil/componentes/custom_app_bar.dart';
import 'package:app_movil/componentes/image_slider.dart';
import 'package:app_movil/componentes/categories_carousel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Inicio'),
      drawer: DrawerUser(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slider de Imágenes
            ImageSlider(), // Aquí se integra el componente

            // Carrusel de Categorías usando Chips
            CategoriesCarousel(), // Aquí se integra el nuevo componente
          ],
        ),
      ),
    );
  }
}
