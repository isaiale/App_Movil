import 'package:flutter/material.dart';
import '../vistas/detalle_producto.dart';

class ProductCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  ProductCarousel({required this.products});

  @override
  _ProductCarouselState createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.5);
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340, // Ajusta según el diseño requerido
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          final product = widget.products[index];

          // Aplicar escala para el efecto de carrusel
          final double scale = (_currentPage - index).abs() < 1.0
              ? 1.0 - (_currentPage - index).abs() * 0.3
              : 0.8;

          return Transform.scale(
            scale: scale,
            child: Transform.rotate(
              angle: (_currentPage - index) * 0.1, // Efecto de rotación leve
              child: GestureDetector(
                onTap: () {
                  // Navegar a la pantalla de DetalleProducto
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalleProducto(
                        id: product['_id'],
                        title: product['name'],
                        descripcion: product['descripcion'] ?? 'Sin descripción',
                        price: product['price'].toDouble(),
                        imageUrl: product['imageUrl'],
                        inventario: product['inventario'] ?? 0,
                        categoria: product['categoria'] ?? [],
                        descuento: product['descuento'] ?? 0,
                        talla: product['talla'] ?? [],
                        sexo: product['sexo'] ?? 'Desconocido',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Card(
                        elevation: 6.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15.0),
                                ),
                                child: Image.network(
                                  product['imageUrl'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                (loadingProgress.expectedTotalBytes ?? 1)
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Text(
                                product['name'],
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '\$${product['price'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                      // Mostrar etiqueta de descuento si aplica
                      if (product['descuento'] != null && product['descuento'] > 0)
                        Positioned(
                          top: 10.0,
                          right: 10.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              '${product['descuento']}% OFF',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
