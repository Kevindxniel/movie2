import 'package:evaluacion_02/main.dart';
import 'package:evaluacion_02/screens/comentarios.dart';
import 'package:evaluacion_02/screens/series.dart';
import 'package:flutter/material.dart';


class MiDrawer extends StatelessWidget {
  const MiDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("Series"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Series())),
          ),
          ListTile(
            title: Text("Comentarios"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Comentarios())),
          ),
        ],
      ),
    );
  }
}
