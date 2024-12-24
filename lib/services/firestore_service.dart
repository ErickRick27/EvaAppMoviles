import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Método para agregar un episodio
  Future<void> addEpisodio({
    required String titulo,
    required int duracion,
    required String descripcion,
    required String usuarioId,
  }) async {
    try {
      if (titulo.isEmpty || descripcion.isEmpty || duracion <= 0) {
        throw Exception('Los campos título, descripción y duración deben ser válidos');
      }

      await _db.collection('episodios').add({
        'titulo': titulo,
        'duracion': duracion,
        'descripcion': descripcion,
        'usuarioId': usuarioId,
        'fechaCreacion': FieldValue.serverTimestamp(),
      });

      print('Episodio agregado correctamente');
    } catch (e) {
      print('Error al agregar episodio: $e');
      throw Exception('No se pudo agregar el episodio: ${e.toString()}');
    }
  }

  // Método para obtener la lista de episodios
  Future<List<Map<String, dynamic>>> getEpisodios() async {
    try {
      QuerySnapshot snapshot =
          await _db.collection('episodios').orderBy('fechaCreacion', descending: true).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      print('Error al obtener episodios: $e');
      throw Exception('No se pudieron obtener los episodios: ${e.toString()}');
    }
  }

  // Método para eliminar un episodio
  Future<void> deleteEpisodio(String episodioId) async {
    try {
      await _db.collection('episodios').doc(episodioId).delete();
      print('Episodio eliminado correctamente');
    } catch (e) {
      print('Error al eliminar el episodio: $e');
      throw Exception('No se pudo eliminar el episodio: ${e.toString()}');
    }
  }

  // Método para editar un episodio
  Future<void> updateEpisodio({
    required String episodioId,
    String? titulo,
    int? duracion,
    String? descripcion,
  }) async {
    try {
      Map<String, dynamic> updateData = {};
      if (titulo != null) updateData['titulo'] = titulo;
      if (duracion != null) updateData['duracion'] = duracion;
      if (descripcion != null) updateData['descripcion'] = descripcion;

      if (updateData.isEmpty) {
        throw Exception('No hay campos para actualizar');
      }

      await _db.collection('episodios').doc(episodioId).update(updateData);
      print('Episodio actualizado correctamente');
    } catch (e) {
      print('Error al actualizar el episodio: $e');
      throw Exception('No se pudo actualizar el episodio: ${e.toString()}');
    }
  }
}
