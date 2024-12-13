import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Comentarios extends StatefulWidget {
  const Comentarios({super.key});

  @override
  State<Comentarios> createState() => _ComentariosState();
}

class _ComentariosState extends State<Comentarios> {
  final TextEditingController _serieController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();
  final DatabaseReference _comentariosRef = FirebaseDatabase.instance.ref().child('comentarios');
  int _comentarioId = 1;


  Future<void> _guardarComentario() async {
    final serie = _serieController.text;
    final comentario = _comentarioController.text;

    if (serie.isNotEmpty && comentario.isNotEmpty) {
      final nuevoComentario = {
        'id': _comentarioId.toString(),
        'serie': serie,
        'comentario': comentario,
      };

      try {
        await _comentariosRef.child(_comentarioId.toString()).set(nuevoComentario);


        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comentario guardado exitosamente')),
        );


        setState(() {
          _comentarioId++;
        });


        _serieController.clear();
        _comentarioController.clear();
      } catch (e) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar comentario: $e')),
        );
      }
    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realizar Comentario'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _serieController,
              decoration: const InputDecoration(
                labelText: 'Serie',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _comentarioController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Comentario',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _guardarComentario,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
