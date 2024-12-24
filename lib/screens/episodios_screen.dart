import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EpisodiosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Episodios')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('episodios')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay episodios disponibles'));
          }

          final episodes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: episodes.length,
            itemBuilder: (context, index) {
              final episode = episodes[index];
              final titulo = episode['titulo'] ?? 'Sin título';
              final descripcion = episode['descripcion'] ?? 'Sin descripción';
              final duracion = (episode['duracion'] ?? 0) as int;
              final userId = episode['userId'] ?? 'Usuario desconocido'; // Obtener el nombre de usuario

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  title: Text(titulo),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(descripcion),
                      SizedBox(height: 5),
                      Text('Subido por: $userId', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                    ],
                  ),
                  trailing: Text('Duración: $duracion min'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
