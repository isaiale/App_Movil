import 'package:flutter/material.dart';
import 'package:app_movil/servicios/producto_service.dart';
import 'lista_productos.dart';

class ProductosCategoria extends StatefulWidget {
  final String categoriaId;

  ProductosCategoria({required this.categoriaId});

  @override
  _ProductosCategoriaState createState() => _ProductosCategoriaState();
}

class _ProductosCategoriaState extends State<ProductosCategoria> {
  final ProductosCategoriaService _productoService = ProductosCategoriaService();
  List<dynamic> productos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductosByCategoria();
  }

  Future<void> fetchProductosByCategoria() async {
    print('Iniciando la solicitud para obtener productos de la categoría: ${widget.categoriaId}');
    try {
      final data = await _productoService.fetchProductosByCategoria(widget.categoriaId);

      setState(() {
        productos = data;
        print(productos);
        isLoading = false;
      });
      print('Productos cargados: ${productos.length} encontrados');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al obtener los productos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos por Categoría'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : productos.isEmpty
              ? Center(child: Text("No hay productos en esta categoría"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.74,
                    ),
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      final producto = productos[index];

                      if (producto is! Map<String, dynamic>) {
                        print('Producto inesperado: $producto');
                        return Center(child: Text('Producto no disponible'));
                      }

                      final nombre = producto['nombre'] ?? 'Sin nombre';
                      final precio = (producto['precio'] ?? 0).toDouble();
                      final descripcion = producto['descripcion'] ?? 'Sin descripción';
                      final inventario = producto['inventario'] ?? 0;
                      final descuento = producto['descuento'] ?? 0;
                      final talla = producto['talla'] ?? [];
                      final sexo = producto['sexo'] ?? 'No aplica';
                      final categoria = producto['categoria']?['nombre'] ?? 'Sin categoría';
                      final imagenes = producto['imagenes'] ?? [];
                      final imageUrl = imagenes.isNotEmpty
                          ? imagenes[0]['url']
                          : 'https://via.placeholder.com/150';

                      return ProductCard(
                        id: producto['_id'] ?? '',
                        title: nombre,
                        price: precio,
                        descripcion: descripcion,
                        inventario: inventario,
                        descuento: descuento,
                        talla: talla,
                        sexo: sexo,
                        categoria: categoria,
                        imageUrl: imageUrl,
                      );
                    },
                  ),
                ),
    );
  }
}
