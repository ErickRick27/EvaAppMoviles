import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'mis_episodios_screen.dart';  // Asegúrate de importar la pantalla de Mis Episodios
import 'episodios_screen.dart';      // Asegúrate de importar la pantalla de Episodios
import 'login_screen.dart';         // Asegúrate de importar la pantalla de login

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  // Lista de pantallas a mostrar según la selección
  final List<Widget> _screens = [
    EpisodiosScreen(),    // Pantalla de Episodios
    MisEpisodiosScreen(), // Pantalla de Mis Episodios
  ];

  // Lista de títulos para cada pantalla
  final List<String> _screenTitles = [
    'Episodios',
    'Mis Episodios',
  ];

  // Método para cambiar entre pantallas cuando el usuario selecciona un ítem de la barra
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Actualiza la pantalla que se mostrará
    });
  }

  // Método para cerrar sesión
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Redirigir al login después de cerrar sesión
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      // Manejo de errores durante el cierre de sesión
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitles[_selectedIndex]), // Título de la app
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app), // Ícono de cerrar sesión
            onPressed: _signOut, // Llama al método de cierre de sesión
          ),
        ],
      ),
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