import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Lanzar un error intencional
            throw Exception('This is test exception');
          },
          child: const Text('Verify Sentry Setup'),
        ),
      ),
    );
  }
}
