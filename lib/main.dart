import 'package:evaluacion3_4/screens/add_episodio_screen.dart';
import 'package:evaluacion3_4/screens/base_screen.dart';
import 'package:evaluacion3_4/services/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'screens/login_screen.dart';
import 'screens/episodios_screen.dart';
import 'screens/mis_episodios_screen.dart';
import 'screens/register_screen.dart';
import 'models/episodio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa Firebase con las opciones obtenidas
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        // Updated route for AddEpisodioScreen to pass an empty episodio when adding new
        '/add_episodio': (context) => AddEpisodioScreen(episode: Episodio(id: '', titulo: '', descripcion: '', duracion: 0, usuarioInicial: '')),
        '/base': (context) => BaseScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/add_episodio') {
          final episodio = settings.arguments as Episodio?;
          return MaterialPageRoute(
            builder: (context) => AddEpisodioScreen(episode: episodio ?? Episodio(id: '', titulo: '', descripcion: '', duracion: 0, usuarioInicial: '')),
          );
        }
        return null;
      },
    );
  }
}

