import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class PersonaFormScreen extends StatefulWidget {
  final Map<String, dynamic>? persona;

  const PersonaFormScreen({Key? key, this.persona}) : super(key: key);

  @override
  _PersonaFormScreenState createState() => _PersonaFormScreenState();
}

class _PersonaFormScreenState extends State<PersonaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ocupacionController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    if (widget.persona != null) {
      _nombreController.text = widget.persona!['nombre'];
      _ocupacionController.text = widget.persona!['ocupacion'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.persona == null ? "Crear Persona" : "Editar Persona"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: "Nombre"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El nombre es obligatorio";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ocupacionController,
                decoration: InputDecoration(labelText: "Ocupación"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La ocupación es obligatoria";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final personaData = {
                      'id': widget.persona?['id'] ?? DateTime.now().toString(),
                      'nombre': _nombreController.text,
                      'ocupacion': _ocupacionController.text,
                    };
                    await _firestoreService.savePersona(personaData);
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
