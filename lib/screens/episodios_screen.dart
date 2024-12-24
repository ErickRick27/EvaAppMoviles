import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart'; // Necesitarás el paquete audioplayers

class EpisodiosScreen extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Instanciamos el reproductor de audio

  // Función para obtener los episodios desde Firestore
  Future<List<Map<String, dynamic>>> getEpisodios() async {
    QuerySnapshot snapshot = await _db.collection('episodios').get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }

  // Función para reproducir el audio
  Future<void> _reproducirAudio(String url) async {
    try {
      await _audioPlayer.play(url);
    } catch (e) {
      print('Error al reproducir el audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Episodios')),
      body: FutureBuilder(
        future: getEpisodios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar episodios'));
          }

          // Obtén los episodios desde los datos obtenidos de Firestore
          final episodios = snapshot.data as List<Map<String, dynamic>>;

          return ListView.builder(
            itemCount: episodios.length,
            itemBuilder: (context, index) {
              final episodio = episodios[index];

              // Aquí puedes agregar los detalles que quieras mostrar en la lista
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Text(
                    episodio['titulo'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Subido por: ${episodio['username']}'),
                      SizedBox(height: 5),
                      Text('Descripción: ${episodio['descripcion']}'),
                      SizedBox(height: 10),
                      // Botón para reproducir el audio
                      ElevatedButton(
                        onPressed: () {
                          _reproducirAudio(episodio['audioUrl']);
                        },
                        child: Text('Reproducir Audio'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

