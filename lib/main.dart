import 'package:evaluacion3_4/screens/index_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Asegúrate de que Firebase esté inicializado correctamente.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IndexScreen(),  // Aquí es donde defines que la pantalla de inicio sea IndexScreen.
    );
  }
}
