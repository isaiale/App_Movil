import 'package:flutter/material.dart';

class AlertMessage {
  // Función estática para mostrar el mensaje de alerta centrado en la pantalla
  static void show({
    required BuildContext context,
    required String message,
    required MessageType type, // Tipo de mensaje: información, error, éxito o advertencia
  }) {
    // Definir el color y el icono dependiendo del tipo de mensaje
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case MessageType.success:
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case MessageType.error:
        backgroundColor = Colors.red;
        icon = Icons.error;
        break;
      case MessageType.warning:
        backgroundColor = Colors.orange;
        icon = Icons.warning;
        break;
      case MessageType.info:
      default:
        backgroundColor = Colors.blue;
        icon = Icons.info;
        break;
    }

    // Mostrar el diálogo de alerta
    showDialog(
      context: context,
      barrierDismissible: false, // Evita que el usuario lo cierre tocando fuera
      builder: (BuildContext context) {
        // Cerrar el diálogo después de 4 segundos
        Future.delayed(Duration(seconds: 4), () {
          Navigator.of(context).pop(); // Cierra el diálogo automáticamente
        });

        return AlertDialog(
          backgroundColor: backgroundColor, // Cambiar el color de fondo
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white), // Icono en el mensaje
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white), // Texto en color blanco
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Enum para definir los tipos de mensajes
enum MessageType {
  success,
  error,
  warning,
  info,
}


// Ejemplo de uso del componente 

// AlertMessage.show(
//    context: context,
//    message: 'Mensaje',
//    type: MessageType.success,
// );
