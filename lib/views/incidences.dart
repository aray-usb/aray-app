/// Módulo para el desarrollo del listado de Incidencias

import 'package:flutter/material.dart';
import 'package:aray/widgets/incidence_list.dart';

/// Vista de incidencias de Aray: lista las incidencias en curso, en tarjetas,
/// permitiendo acceder a los detalles de cada incidencia.
class IncidencesPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Incidencias"),
      ),
      body: IncidenceList(),
    );
  }
}