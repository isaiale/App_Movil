import 'package:flutter/material.dart';

class DetalleProducto extends StatefulWidget {
  final String title;
  final double price;
  final String imageUrl;
  final int inventario;
  final List<dynamic> categoria;
  final int? descuento;
  final List<dynamic> talla;
  final String sexo;

  DetalleProducto({
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.inventario,
    required this.categoria,
    required this.descuento,
    required this.talla,
    required this.sexo,
  });

  @override
  _DetalleProductoState createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  int cantidad = 1;
  String tamanoSeleccionado = 'Small';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Imagen del producto
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                ),
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 40.0,
                left: 20.0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Positioned(
                top: 40.0,
                right: 20.0,
                child: IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: () {
                    // Acción de agregar a favoritos
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del producto y calificación
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          '4.8', // Ejemplo de calificación
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Lattes, Caffè latte, etc.', // Ejemplo de descripción
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 20.0),

                  // Mostrar Inventario
                  Text(
                    'Inventario: ${widget.inventario}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 10.0),

                  // Mostrar Categoría
                  Text(
                    'Categoría: ${widget.categoria.isNotEmpty ? widget.categoria.map((c) => c["nombre"]).join(", ") : 'No especificada'}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 10.0),

                  // Mostrar Descuento
                  if (widget.descuento != null && widget.descuento! > 0)
                    Text(
                      'Descuento: ${widget.descuento}% OFF',
                      style: TextStyle(fontSize: 16.0, color: Colors.red),
                    ),
                  SizedBox(height: 10.0),

                  // Mostrar Talla
                  Text(
                    'Talla: ${widget.talla.isNotEmpty ? widget.talla.join(", ") : 'No disponible'}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 10.0),

                  // Mostrar Sexo
                  Text(
                    'Sexo: ${widget.sexo}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 20.0),

                  // Selector de cantidad
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cantidad',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              setState(() {
                                if (cantidad > 1) cantidad--;
                              });
                            },
                          ),
                          Text(
                            '$cantidad',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() {
                                cantidad++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  // Precio y botón de agregar al carrito
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Price',
                              style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 5.0),
                          Text(
                            '\$${(widget.price * cantidad).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Acción para agregar al carrito
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          'Add to cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
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

  Widget _buildSizeOption(String size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          tamanoSeleccionado = size;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: tamanoSeleccionado == size ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: tamanoSeleccionado == size ? Colors.green : Colors.grey,
          ),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: tamanoSeleccionado == size ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
