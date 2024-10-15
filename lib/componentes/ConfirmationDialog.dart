import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;

  // Constructor for receiving title, content, and button texts
  ConfirmationDialog({
    required this.title,
    required this.content,
    this.confirmText = 'Confirmar', // Default confirm text
    this.cancelText = 'Cancelar', // Default cancel text
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Text(
        content,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            cancelText,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(false); // User doesn't confirm
          },
        ),
        TextButton(
          child: Text(
            confirmText,
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(true); // User confirms
          },
        ),
      ],
    );
  }
}

// Helper function to show the dialog and return the user's response
Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'Confirmar',
  String cancelText = 'Cancelar',
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: false, // Dialog cannot be closed by tapping outside
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
      );
    },
  ) ?? false; // Returns false if the dialog is closed without selecting anything
}