/// Módulo para el desarrollo de la vista inicial de Aray

import 'package:flutter/material.dart';
import 'package:aray/widgets/aray_drawer.dart';
import 'package:aray/widgets/incidence_map.dart';

/// Vista inicial de Aray: despliega el mapa de incidencias, centrado
/// en la ubicación del usuario (si es posible obtenerla) con los
/// marcadores a su alrededor, y permite enviar un reporte o solicitar
/// ayuda.
class HomePage extends StatelessWidget {

  Widget getFloatingActionButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FloatingActionButton.extended(
          heroTag: 'ayuda',
          icon: Icon(Icons.warning),
          onPressed: () {

          },
          label: Text("Ayuda"),
          backgroundColor: Colors.red,
        ),
        FloatingActionButton.extended(
          heroTag: 'reporte',
          icon: Icon(Icons.perm_device_information),
          onPressed: () {

          },
          label: Text("Reporte"),
          backgroundColor: Colors.blue,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aray"),
      ),
      drawer: ArayDrawer(),
      body: IncidenceMap(),
      floatingActionButton: getFloatingActionButtonRow(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}