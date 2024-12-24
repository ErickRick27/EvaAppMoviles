import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;  // Aquí se inicializa Firestore.

  // Método para guardar una persona
  Future<void> savePersona(Map<String, dynamic> personaData) async {
    try {
      await _db.collection('personas').add(personaData);  // Usamos _db para acceder a la colección.
      print('Persona guardada correctamente');
    } catch (e) {
      print('Error al guardar persona: $e');
      throw Exception('Error al guardar persona');
    }
  }

  // Método para guardar un episodio
  Future<void> saveEpisodio(Map<String, dynamic> episodioData) async {
    try {
      await _db.collection('episodios').add(episodioData);
      print('Episodio guardado correctamente');
    } catch (e) {
      print('Error al guardar episodio: $e');
      throw Exception('Error al guardar episodio');
    }
  }

  // Método para eliminar una persona
  Future<void> deletePersona(String personaId) async {
    try {
      await _db.collection('personas').doc(personaId).delete();  // Eliminamos la persona por su ID.
      print('Persona eliminada correctamente');
    } catch (e) {
      print('Error al eliminar persona: $e');
      throw Exception('Error al eliminar persona');
    }
  }

  // Método para eliminar un episodio
  Future<void> deleteEpisodio(String episodioId) async {
    try {
      await _db.collection('episodios').doc(episodioId).delete();  // Eliminamos el episodio por su ID.
      print('Episodio eliminado correctamente');
    } catch (e) {
      print('Error al eliminar episodio: $e');
      throw Exception('Error al eliminar episodio');
    }
  }

  // Obtener la lista de personas
  Future<List<Map<String, dynamic>>> getPersonas() async {
    try {
      QuerySnapshot snapshot = await _db.collection('personas').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error al obtener personas: $e');
      throw Exception('Error al obtener personas');
    }
  }

  // Obtener la lista de episodios
  Future<List<Map<String, dynamic>>> getEpisodios() async {
    try {
      QuerySnapshot snapshot = await _db.collection('episodios').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error al obtener episodios: $e');
      throw Exception('Error al obtener episodios');
    }
  }
}
