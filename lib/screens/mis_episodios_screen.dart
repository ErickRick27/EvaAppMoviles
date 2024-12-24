import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_episodio_screen.dart'; // Import the screen for adding episodes
import 'package:evaluacion3_4/models/episodio.dart';

class MisEpisodiosScreen extends StatelessWidget {
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  // Retrieve only the episodes created by the authenticated user
  Stream<List<Episodio>> _getMisEpisodios() {
    if (_currentUser == null) {
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('episodios')
        .where('userId', isEqualTo: _currentUser?.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Episodio.fromDocument(doc))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Episodios'),
      ),
      body: StreamBuilder<List<Episodio>>(
        stream: _getMisEpisodios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los episodios'));
          }

          final episodios = snapshot.data ?? [];

          if (episodios.isEmpty) {
            return Center(child: Text('No tienes episodios disponibles.'));
          }

          return ListView.builder(
            itemCount: episodios.length,
            itemBuilder: (context, index) {
              final episodio = episodios[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(episodio.titulo),
                  subtitle: Text(episodio.descripcion),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.green),
                        onPressed: () {
                          _editEpisodio(context, episodio);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteEpisodio(context, episodio),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/add_episodio',
            arguments: Episodio(id: '', titulo: '', descripcion: '', duracion: 0, usuarioInicial: ''), // Pass an empty episode for adding new
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Agregar Episodio',
      ),
    );
  }

  // Function to delete an episode
  Future<void> _deleteEpisodio(BuildContext context, Episodio episodio) async {
    try {
      await FirebaseFirestore.instance
          .collection('episodios')
          .doc(episodio.id)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Episodio eliminado correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el episodio: $e')),
      );
    }
  }

  // Function to edit an episode
  void _editEpisodio(BuildContext context, Episodio episodio) {
    Navigator.pushNamed(
      context,
      '/add_episodio',
      arguments: episodio, // Pass the selected episode for editing
    );
  }
}
