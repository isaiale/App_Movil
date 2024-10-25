import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:carousel_slider/carousel_controller.dart' as carousel_ctrl;
import 'package:flutter/material.dart';

class ProductCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final carousel_ctrl.CarouselController controller;

  ProductCarousel({required this.products, required this.controller});

  @override
  Widget build(BuildContext context) {
    return carousel_slider.CarouselSlider(
      options: carousel_slider.CarouselOptions(
        height: 250.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        enableInfiniteScroll: true,
        autoPlayInterval: Duration(seconds: 3),
      ),
      items: products.map((product) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                print('Producto seleccionado: ${product['name']}');
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(
                          product['imageUrl'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product['name'],
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '\$${product['price'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
