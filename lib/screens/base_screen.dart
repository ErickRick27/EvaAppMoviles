import 'package:flutter/material.dart';
import 'mis_episodios_screen.dart';  // Asegúrate de importar la pantalla de Mis Episodios
import 'episodios_screen.dart';      // Asegúrate de importar la pantalla de Episodios

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0; // Índice para saber qué pantalla se está mostrando

  // Lista de pantallas a mostrar según la selección
  final List<Widget> _screens = [
    EpisodiosScreen(),    // Pantalla de Episodios
    MisEpisodiosScreen(), // Pantalla de Mis Episodios
  ];

  // Método para cambiar entre pantallas cuando el usuario selecciona un ítem de la barra
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Actualiza la pantalla que se mostrará
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Aquí se renderiza la pantalla correspondiente
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Controla cuál ítem está seleccionado
        onTap: _onItemTapped, // Cambia la pantalla al seleccionar un ítem
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music), // Ícono para la pantalla de Episodios
            label: 'Episodios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), // Ícono para la pantalla de Mis Episodios
            label: 'Mis Episodios',
          ),
        ],
      ),
    );
  }
}
