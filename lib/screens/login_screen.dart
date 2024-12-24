import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'base_screen.dart';  // Asegúrate de importar la pantalla BaseScreen
import 'register_screen.dart';  // Pantalla para registrarse

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Redirigir a BaseScreen si el login es exitoso
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BaseScreen()),
      );
    } catch (e) {
      print('Error en el login: $e');
      // Mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al iniciar sesión: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
        backgroundColor: Colors.blue, // Color de fondo del AppBar
      ),
      body: SingleChildScrollView( // Para que el contenido se desplace si es necesario
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido verticalmente
            crossAxisAlignment: CrossAxisAlignment.stretch, // Expande los widgets horizontalmente
            children: [
              SizedBox(height: 30),
              // Campo de correo electrónico
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0), // Bordes redondeados
                  ),
                  filled: true, // Rellena el campo
                  fillColor: Colors.grey[200], // Color de relleno
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              // Campo de contraseña
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                obscureText: true,
              ),
              SizedBox(height: 30),
              // Botón de inicio de sesión
              ElevatedButton(
                onPressed: () => _login(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Color del botón
                  padding: EdgeInsets.symmetric(vertical: 15), // Espacio vertical
                  textStyle: TextStyle(fontSize: 18), // Tamaño de fuente
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0), // Bordes redondeados
                  ),
                ),
                child: Text('Iniciar Sesión', style: TextStyle(color: Colors.white)), // Texto blanco
              ),
              SizedBox(height: 20),
              // Texto para registrarse
              TextButton(
                onPressed: () {
                  // Redirigir a la pantalla de registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text('¿No tienes cuenta? Regístrate aquí', style: TextStyle(color: Colors.blue)), // Texto azul
              ),
            ],
          ),
        ),
      ),
    );
  }
}
