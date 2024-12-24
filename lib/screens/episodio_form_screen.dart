import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class EpisodioFormScreen extends StatefulWidget {
  final Map<String, dynamic>? episodio;

  const EpisodioFormScreen({Key? key, this.episodio}) : super(key: key);

  @override
  _EpisodioFormScreenState createState() => _EpisodioFormScreenState();
}

class _EpisodioFormScreenState extends State<EpisodioFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _duracionController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    if (widget.episodio != null) {
      _tituloController.text = widget.episodio!['titulo'];
      _duracionController.text = widget.episodio!['duracion'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.episodio == null ? "Crear Episodio" : "Editar Episodio"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(labelText: "Título"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El título es obligatorio";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _duracionController,
                decoration: InputDecoration(labelText: "Duración (minutos)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La duración es obligatoria";
                  }
                  if (int.tryParse(value) == null) {
                    return "Debe ser un número válido";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final episodioData = {
                      'id': widget.episodio?['id'] ?? DateTime.now().toString(),
                      'titulo': _tituloController.text,
                      'duracion': int.parse(_duracionController.text),
                    };
                    await _firestoreService.saveEpisodio(episodioData);
                    Navigator.pop(context);
                  }
                },
                child: Text("Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
