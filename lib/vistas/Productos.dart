import 'package:flutter/material.dart';
import '../servicios/producto_service.dart';
import '../componentes/drawer.dart'; 
import '../vistas/detalle_producto.dart';
import '../componentes/custom_app_bar.dart';

class Productos extends StatefulWidget {
  @override
  _ProductosState createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  final ProductoService _productoService = ProductoService();
  List<dynamic> productos = [];
  String? selectedCategory;  // Nueva variable para la categoría seleccionada

  @override
  void initState() {
    super.initState();
    fetchProductos();
  }

  Future<void> fetchProductos() async {
    try {
      List<dynamic> data = await _productoService.fetchProductos();
      setState(() {
        productos = data;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtrar los productos según la categoría seleccionada
    List<dynamic> filteredProductos = selectedCategory == null
        ? productos
        : productos.where((producto) => producto['categoria'].contains(selectedCategory)).toList();

    return Scaffold(
      appBar: CustomAppBar(title: 'Productos'),
      drawer: DrawerUser(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar producto...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('Chalecos'),
                  _buildCategoryChip('Filipinas'),
                  _buildCategoryChip('Pantalones'),
                  _buildCategoryChip('Zapatos'),
                  _buildCategoryChip('Accesorios'),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: filteredProductos.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.73,
                      ),
                      itemCount: filteredProductos.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          id: filteredProductos[index]['_id'],
                          title: filteredProductos[index]['nombre'],
                          descripcion: filteredProductos[index]['descripcion'],
                          price: filteredProductos[index]['precio'].toDouble(),
                          imageUrl: filteredProductos[index]['imagenes'][0]['url'],
                          inventario: filteredProductos[index]['inventario'],
                          categoria: filteredProductos[index]['categoria'] ?? [],
                          descuento: filteredProductos[index]['descuento'] ?? 0,
                          talla: filteredProductos[index]['talla'] ?? [],
                          sexo: filteredProductos[index]['sexo'] ?? 'Desconocido',
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Modificar el método para seleccionar la categoría
  Widget _buildCategoryChip(String label) {
    bool isSelected = selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            selectedCategory = selected ? label : null;
          });
        },
        backgroundColor: Colors.green,
        selectedColor: Colors.lightGreen,
        labelStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}


class ProductCard extends StatelessWidget {
  final String id;
  final String title;
  final String descripcion;
  final double price;
  final String imageUrl;
  final int inventario;
  final List<dynamic> categoria;
  final int? descuento;
  final List<dynamic> talla;
  final String sexo;

  ProductCard({
    required this.id,
    required this.title,
    required this.descripcion,
    required this.price,
    required this.imageUrl,
    required this.inventario,
    required this.categoria,
    required this.descuento,
    required this.talla,
    required this.sexo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$$price',
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleProducto(
                                id: id,
                                title: title,
                                descripcion: descripcion,
                                price: price,
                                imageUrl: imageUrl,
                                inventario: inventario,
                                categoria: categoria,
                                descuento: descuento,
                                talla: talla,
                                sexo: sexo,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: Size(40, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Icon(Icons.add_shopping_cart, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
