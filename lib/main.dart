import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consumo de API',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  void _cargarUsuarios() {
    ApiService.fetchUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API REST en Flutter')),
      body: Center(
        child: ElevatedButton(
          onPressed: _cargarUsuarios, 
          child: Text('Cargar Usuarios'),
        ),
      ),
    );
  }
}
