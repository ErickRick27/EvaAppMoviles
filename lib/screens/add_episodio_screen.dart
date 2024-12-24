import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:evaluacion3_4/models/episodio.dart';

class AddEpisodioScreen extends StatefulWidget {
  final Episodio episode;  // Now it's non-nullable

  // Updated constructor to make 'episode' required
  AddEpisodioScreen({required this.episode});  // Constructor that requires a non-nullable Episodio

  @override
  _AddEpisodioScreenState createState() => _AddEpisodioScreenState();
}

class _AddEpisodioScreenState extends State<AddEpisodioScreen> {
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _duracionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.episode.id.isNotEmpty) {
      // If it's an existing episode, pre-populate the fields
      _tituloController.text = widget.episode.titulo;
      _descripcionController.text = widget.episode.descripcion;
      _duracionController.text = widget.episode.duracion.toString();
    }
  }

  // Save or update the episode
  Future<void> _saveEpisode() async {
    if (_tituloController.text.isEmpty ||
        _descripcionController.text.isEmpty ||
        _duracionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    // Validate that the duration is a valid integer
    final duracion = int.tryParse(_duracionController.text);
    if (duracion == null || duracion <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Duración inválida. Debe ser un número entero mayor a 0')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inicia sesión primero')),
        );
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final username = userDoc['username'] ?? 'Desconocido';

      final episodeData = {
        'titulo': _tituloController.text,
        'descripcion': _descripcionController.text,
        'duracion': duracion, // Store as integer
        'userId': username,
        'createdAt': Timestamp.now(),
      };

      if (widget.episode.id.isEmpty) {
        // If it's a new episode, create a new document
        await FirebaseFirestore.instance.collection('episodios').add(episodeData);
      } else {
        // If it's an existing episode, update the document
        await FirebaseFirestore.instance
            .collection('episodios')
            .doc(widget.episode.id)
            .update(episodeData);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.episode.id.isEmpty ? 'Episodio agregado con éxito' : 'Episodio actualizado con éxito')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar episodio: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.episode.id.isEmpty ? 'Agregar Episodio' : 'Editar Episodio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: _duracionController,
              decoration: InputDecoration(labelText: 'Duración (en minutos)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveEpisode,
                    child: Text(widget.episode.id.isEmpty ? 'Guardar Episodio' : 'Actualizar Episodio'),
                  ),
          ],
        ),
      ),
    );
  }
}
