import 'package:evaluacion3_4/screens/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Guardar el username en Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'username': _usernameController.text.trim()});

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BaseScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrarse: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
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
              // Campo de nombre de usuario
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de Usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0), // Bordes redondeados
                  ),
                  filled: true, // Rellena el campo
                  fillColor: Colors.grey[200], // Color de relleno
                ),
              ),
              SizedBox(height: 20),
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
              // Botón de registro
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Color del botón
                  padding: EdgeInsets.symmetric(vertical: 15), // Espacio vertical
                  textStyle: TextStyle(fontSize: 18), // Tamaño de fuente
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0), // Bordes redondeados
                  ),
                ),
                child: Text('Registrarse', style: TextStyle(color: Colors.white)), // Texto blanco
              ),
            ],
          ),
        ),
      ),
    );
  }
}
