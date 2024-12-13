import 'package:flutter/material.dart';

class ProductSearch extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final String hintText;

  ProductSearch({
    required this.controller,
    required this.onSearch,
    this.hintText = 'Buscar producto...',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onSubmitted: onSearch, // Acción al enviar
          onChanged: onSearch, // Acción al escribir
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          ),
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
