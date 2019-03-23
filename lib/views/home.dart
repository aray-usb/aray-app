/// Módulo para el desarrollo de la vista inicial de Aray

import 'package:flutter/material.dart';
import 'package:aray/widgets/aray_drawer.dart';
import 'package:aray/widgets/incidence_map.dart';

/// Vista inicial de Aray: despliega el mapa de incidencias, centrado
/// en la ubicación del usuario (si es posible obtenerla) con los
/// marcadores a su alrededor, y permite enviar un reporte o solicitar
/// ayuda.
class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio"),
      ),
      drawer: ArayDrawer(),
      body: IncidenceMap(),
      // TODO: Incorporar dos botones: reporte, ayuda
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.flare),
        onPressed: () {

        },
        label: Text("Solicitar Ayuda"),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}