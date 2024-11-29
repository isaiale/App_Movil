import 'package:flutter/material.dart';

class ProductFilterDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilter;

  ProductFilterDialog({required this.onApplyFilter});

  @override
  _ProductFilterDialogState createState() => _ProductFilterDialogState();
}

class _ProductFilterDialogState extends State<ProductFilterDialog> {
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  bool _onlyDiscounted = false;

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filtros de Productos'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Filtro por descuento
          CheckboxListTile(
            title: Text('Solo productos con descuento'),
            value: _onlyDiscounted,
            onChanged: (value) {
              setState(() {
                _onlyDiscounted = value ?? false;
              });
            },
          ),
          // Precio mínimo
          TextField(
            controller: _minPriceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Precio mínimo',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          // Precio máximo
          TextField(
            controller: _maxPriceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Precio máximo',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        // Botón de cancelar
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar'),
        ),
        // Botón de aplicar
        ElevatedButton(
          onPressed: () {
            final filters = {
              'onlyDiscounted': _onlyDiscounted,
              'minPrice': double.tryParse(_minPriceController.text) ?? 0,
              'maxPrice': double.tryParse(_maxPriceController.text) ?? double.infinity,
            };
            widget.onApplyFilter(filters);
            Navigator.pop(context);
          },
          child: Text('Aplicar'),
        ),
      ],
    );
  }
}
