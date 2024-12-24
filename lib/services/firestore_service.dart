import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Método para agregar un episodio
  Future<void> addEpisodio({
    required String titulo,
    required String duracion,
    required String descripcion,
    required String usuarioId,
    File? audioFile,
  }) async {
    try {
      String? audioUrl;

      // Subir el archivo de audio si existe
      if (audioFile != null) {
        audioUrl = await _uploadAudio(audioFile, 'audios');
      }

      // Guardar el episodio en Firestore
      await _db.collection('episodios').add({
        'titulo': titulo,
        'duracion': duracion,
        'descripcion': descripcion,
        'usuarioId': usuarioId,
        'audioUrl': audioUrl,
        'fechaCreacion': FieldValue.serverTimestamp(), // Fecha de creación
      });

      print('Episodio agregado correctamente');
    } catch (e) {
      print('Error al agregar episodio: $e');
      throw Exception('No se pudo agregar el episodio');
    }
  }

  // Método para subir un archivo de audio
  Future<String> _uploadAudio(File audioFile, String folderName) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = _storage.ref().child('$folderName/$fileName');
      UploadTask uploadTask = reference.putFile(audioFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error al subir el audio: $e');
      throw Exception('No se pudo subir el audio');
    }
  }

  // Método para obtener la lista de episodios
  Future<List<Map<String, dynamic>>> getEpisodios() async {
    try {
      QuerySnapshot snapshot = await _db.collection('episodios').orderBy('fechaCreacion', descending: true).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      print('Error al obtener episodios: $e');
      throw Exception('No se pudieron obtener los episodios');
    }
  }

  // Método para eliminar un episodio
  Future<void> deleteEpisodio(String episodioId) async {
    try {
      await _db.collection('episodios').doc(episodioId).delete();
      print('Episodio eliminado correctamente');
    } catch (e) {
      print('Error al eliminar el episodio: $e');
      throw Exception('No se pudo eliminar el episodio');
    }
  }

  // Método para editar un episodio
  Future<void> updateEpisodio({
    required String episodioId,
    required String titulo,
    required String duracion,
    required String descripcion,
    File? audioFile,
  }) async {
    try {
      String? audioUrl;

      // Subir un nuevo archivo de audio si se proporciona
      if (audioFile != null) {
        audioUrl = await _uploadAudio(audioFile, 'audios');
      }

      Map<String, dynamic> updateData = {
        'titulo': titulo,
        'duracion': duracion,
        'descripcion': descripcion,
      };

      if (audioUrl != null) {
        updateData['audioUrl'] = audioUrl;
      }

      await _db.collection('episodios').doc(episodioId).update(updateData);
      print('Episodio actualizado correctamente');
    } catch (e) {
      print('Error al actualizar el episodio: $e');
      throw Exception('No se pudo actualizar el episodio');
    }
  }
}
