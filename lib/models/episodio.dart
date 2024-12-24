import 'package:cloud_firestore/cloud_firestore.dart';

class Episodio {
  final String id;
  final String titulo;
  final String descripcion;
  final int duracion;
  final String usuarioInicial;

  Episodio({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.duracion,
    required this.usuarioInicial,
  });

  factory Episodio.fromDocument(DocumentSnapshot doc) {
    return Episodio(
      id: doc.id,
      titulo: doc['titulo'] ?? 'Título no disponible',
      descripcion: doc['descripcion'] ?? 'Descripción no disponible',
      duracion: doc['duracion'] != null ? int.parse(doc['duracion'].toString()) : 0,
      usuarioInicial: doc['userId']?.substring(0, 1).toUpperCase() ?? 'U',
    );
  }

  static empty() {}
}