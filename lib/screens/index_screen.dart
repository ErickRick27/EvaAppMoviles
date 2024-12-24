import 'package:flutter/material.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla de Inicio')),
      body: Center(
        child: Text('Bienvenido a la Pantalla de Inicio (Index)!'),
      ),
    );
  }
}
