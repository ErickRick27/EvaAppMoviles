import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MisEpisodiosScreen extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  // Función para obtener los episodios del usuario actual
  Future<List<Map<String, dynamic>>> getMisEpisodios() async {
    if (_currentUser == null) {
      return [];
    }

    QuerySnapshot snapshot = await _db
        .collection('episodios')
        .where('userId', isEqualTo: _currentUser!.uid)
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }

  // Función para eliminar un episodio
  Future<void> deleteEpisodio(String episodioId) async {
    try {
      await _db.collection('episodios').doc(episodioId).delete();
      print('Episodio eliminado correctamente');
    } catch (e) {
      print('Error al eliminar episodio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Episodios'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add_episodio');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: getMisEpisodios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar episodios'));
          }

          final episodios = snapshot.data as List<Map<String, dynamic>>;

          // Si no tiene episodios, mostramos un mensaje amigable
          if (episodios.isEmpty) {
            return Center(child: Text('No tienes episodios aún.'));
          }

          return ListView.builder(
            itemCount: episodios.length,
            itemBuilder: (context, index) {
              final episodio = episodios[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Text(
                    episodio['titulo'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(episodio['descripcion']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // Pedimos confirmación antes de eliminar
                      bool? confirmDelete = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Confirmar eliminación'),
                            content: Text('¿Estás seguro de que quieres eliminar este episodio?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text('Eliminar'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmDelete != null && confirmDelete) {
                        await deleteEpisodio(episodio['id']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Episodio eliminado')),
                        );
                      }
                    },
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
