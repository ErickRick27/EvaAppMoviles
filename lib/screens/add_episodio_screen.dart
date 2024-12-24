import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // Importa para usar kIsWeb

class AddEpisodioScreen extends StatefulWidget {
  @override
  _AddEpisodioScreenState createState() => _AddEpisodioScreenState();
}

class _AddEpisodioScreenState extends State<AddEpisodioScreen> {
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  File? _audioFile;
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _currentUser = FirebaseAuth.instance.currentUser;
  double _uploadProgress = 0.0;

  Future<void> _pickAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      if (kIsWeb) {
        // En la web usamos 'bytes' en lugar de 'path'
        final audioBytes = result.files.single.bytes;
        if (audioBytes != null) {
          setState(() {
            // Usamos File.fromRawPath para convertir los bytes en un archivo
            _audioFile = File.fromRawPath(audioBytes);
            print("Archivo seleccionado en Web: ${_audioFile?.path}");
          });
        }
      } else {
        // En plataformas no web usamos el 'path' del archivo
        if (result.files.single.path != null) {
          setState(() {
            _audioFile = File(result.files.single.path!);
            print("Archivo seleccionado: ${_audioFile?.path}");
          });
        }
      }
    }
  }

  Future<String?> _uploadAudio(File audioFile) async {
    if (audioFile.path.isEmpty || !audioFile.path.endsWith('.mp3')) {
      print("El archivo seleccionado no es un audio válido.");
      return null;
    }

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = _storage.ref().child('audios/$fileName');
      UploadTask uploadTask = reference.putFile(audioFile);

      // Escuchar el progreso de la carga
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      }, onError: (error) {
        print("Error durante la subida: $error");
      });

      // Esperar que la carga se complete
      TaskSnapshot snapshot = await uploadTask;
      print("Archivo subido con éxito");

      // Devolver la URL del archivo subido
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error al subir el audio: $e');
      return null;
    }
  }

  Future<void> _saveEpisodio() async {
    if (_tituloController.text.isEmpty ||
        _descripcionController.text.isEmpty ||
        _audioFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos y seleccione un archivo')),
      );
      return;
    }

    try {
      // Subir el archivo de audio
      String? audioUrl = await _uploadAudio(_audioFile!);

      // Si la subida fue exitosa y el audio tiene URL
      if (_currentUser != null && audioUrl != null) {
        await _db.collection('episodios').add({
          'titulo': _tituloController.text.trim(),
          'descripcion': _descripcionController.text.trim(),
          'audioUrl': audioUrl,
          'userId': _currentUser!.uid,
          'username': await _getUsername(),
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Episodio guardado correctamente')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar episodio: $e')),
      );
    }
  }

  Future<String> _getUsername() async {
    final userDoc = await _db.collection('users').doc(_currentUser!.uid).get();
    return userDoc.data()?['username'] ?? 'Desconocido';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Episodio')),
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
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickAudio,
              child: Text('Seleccionar Archivo de Audio'),
            ),
            if (_audioFile != null)
              Text('Archivo seleccionado: ${_audioFile!.path.split('/').last}'),
            SizedBox(height: 10),
            if (_uploadProgress > 0)
              LinearProgressIndicator(
                value: _uploadProgress,
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEpisodio,
              child: Text('Guardar Episodio'),
            ),
          ],
        ),
      ),
    );
  }
}
