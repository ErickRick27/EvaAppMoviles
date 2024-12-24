import 'package:evaluacion3_4/screens/add_episodio_screen.dart';
import 'package:evaluacion3_4/screens/base_screen.dart';
import 'package:evaluacion3_4/services/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/episodios_screen.dart';
import 'screens/mis_episodios_screen.dart';
import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa Firebase con las opciones obtenidas
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Podcasts App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/episodios': (context) => EpisodiosScreen(),
        '/mis_episodios': (context) => MisEpisodiosScreen(),
        '/add_episodio': (context) => AddEpisodioScreen(),
        '/base': (context) => BaseScreen(),
      },
    );
  }
}
