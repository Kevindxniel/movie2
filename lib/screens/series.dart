import 'package:evaluacion_02/navegador/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Series extends StatefulWidget {
  const Series({super.key});

  @override
  State<Series> createState() => _SeriesState();
}

class _SeriesState extends State<Series> {
  List _series = [];

  Future<void> _loadSeries() async {
    final response = await http.get(Uri.parse('https://jritsqmet.github.io/web-api/series.json'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _series = jsonData['series']; 
      });
    } else {
      print('Error al cargar los datos');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSeries(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Series'),
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
        shadowColor: Colors.white,
        backgroundColor: Colors.black,  
      ),
      drawer: MiDrawer(),
      backgroundColor: Colors.black,  
      body: _series.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _series.length,
              itemBuilder: (context, index) {
                final serie = _series[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  color: Colors.black,  // Fondo negro en las tarjetas
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      serie['titulo'],  // Cambié 'nombre' por 'titulo'
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    subtitle: Text(
                      serie['descripcion'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        serie['info']['imagen'],  // Cambié 'imagen' para acceder correctamente al campo
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Mostrar un ícono de error si no se puede cargar la imagen
                          return const Icon(Icons.error, color: Colors.red, size: 50);
                        },
                      ),
                    ),
                    onTap: () {
                      _showSerieDetails(serie, context);
                    },
                  ),
                );
              },
            ),
    );
  }

  void _showSerieDetails(Map serie, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,  // Fondo negro en el AlertDialog
          title: Text(
            serie['titulo'],  
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(serie['info']['imagen'], fit: BoxFit.cover),
              const SizedBox(height: 10),
              Text("Descripción: ${serie['descripcion']}", style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              Text("Año: ${serie['anio']}", style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              Text("Temporadas: ${serie['metadata']['temporadas']}", style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              Text("Creador: ${serie['metadata']['creador']}", style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              Text("Más información: ${serie['info']['url']}", style: const TextStyle(color: Colors.blue)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
