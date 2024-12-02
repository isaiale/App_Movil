import 'package:flutter/material.dart';
import 'package:app_movil/servicios/producto_service.dart';
import 'lista_productos.dart';
import '/componentes/ProductSearch.dart';
import '/componentes/fitroProductos.dart';

class ProductosCategoria extends StatefulWidget {
  final String categoriaId;
  final String nombreCategoria;

  ProductosCategoria(
      {required this.categoriaId, required this.nombreCategoria});

  @override
  _ProductosCategoriaState createState() => _ProductosCategoriaState();
}

class _ProductosCategoriaState extends State<ProductosCategoria> {
  final ProductosCategoriaService _productoService =
      ProductosCategoriaService();
  List<dynamic> productos = [];
  List<dynamic> productosFiltrados = [];
  bool isLoading = true;
  final TextEditingController _searchController =
      TextEditingController(); // Controlador para el campo de búsqueda

  @override
  void initState() {
    super.initState();
    fetchProductosByCategoria();
  }

  Future<void> fetchProductosByCategoria() async {
    print(
        'Iniciando la solicitud para obtener productos de la categoría: ${widget.categoriaId}');
    try {
      final data =
          await _productoService.fetchProductosByCategoria(widget.categoriaId);

      setState(() {
        productos = data;
        productosFiltrados =
            data; // Inicialmente, los productos filtrados son todos los productos
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

  void _filterProductos(String query) {
    setState(() {
      if (query.isEmpty) {
        productosFiltrados = productos;
      } else {
        productosFiltrados = productos
            .where((producto) => producto['nombre']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      productosFiltrados = productos.where((producto) {
        // Validar que el precio y descuento no sean nulos antes de compararlos
        final precio = (producto['precio'] ?? 0).toDouble();
        final descuento = (producto['descuento'] ?? 0).toDouble();

        final tieneDescuento = filters['onlyDiscounted'] ? descuento > 0 : true;
        final precioMinimo =
            filters['minPrice'] != null ? precio >= filters['minPrice'] : true;
        final precioMaximo =
            filters['maxPrice'] != null ? precio <= filters['maxPrice'] : true;

        return tieneDescuento && precioMinimo && precioMaximo;
      }).toList();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return ProductFilterDialog(
          onApplyFilter: (filters) {
            _applyFilters(filters);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nombreCategoria,
          style: TextStyle(
            color: Colors.white, // Cambia el color del texto a blanco
            fontSize: 20.0, // Tamaño de fuente opcional
            fontWeight: FontWeight.bold, // Negrita opcional
          ),
        ),
        centerTitle: true, // Centrar el título
        backgroundColor: Colors.pinkAccent, // Color de fondo del AppBar
        iconTheme: IconThemeData(
            color: Colors.white), // Iconos también en blanco, si aplica
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : productos.isEmpty
              ? Center(child: Text("No hay productos en esta categoría"))
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ProductSearch(
                            controller: _searchController,
                            onSearch: _filterProductos,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.filter_alt, color: Colors.black),
                          onPressed: _showFilterDialog,
                        ),
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.red),
                          onPressed: _clearFilters,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 5.0,
                            childAspectRatio: 0.65,
                          ),
                          itemCount: productosFiltrados.length,
                          itemBuilder: (context, index) {
                            final producto = productosFiltrados[index];

                            if (producto is! Map<String, dynamic>) {
                              print('Producto inesperado: $producto');
                              return Center(
                                  child: Text('Producto no disponible'));
                            }

                            final nombre = producto['nombre'] ?? 'Sin nombre';
                            final precio = (producto['precio'] ?? 0).toDouble();
                            final descripcion =
                                producto['descripcion'] ?? 'Sin descripción';
                            final inventario = producto['inventario'] ?? 0;
                            final descuento = producto['descuento'] ?? 0;
                            final talla = producto['talla'] ?? [];
                            final sexo = producto['sexo'] ?? 'No aplica';
                            final categoria = producto['categoria']
                                    ?['nombre'] ??
                                'Sin categoría';
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
                    ),
                  ],
                ),
    );
  }

  /// Función para limpiar filtros y restaurar la lista original
  void _clearFilters() {
    setState(() {
      productosFiltrados = productos;
      _searchController.clear(); // Limpia el campo de búsqueda
    });
  }
}
