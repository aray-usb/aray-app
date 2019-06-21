/// Módulo para el desarrollo del listado de Incidencias

import 'package:flutter/material.dart';
import 'package:aray/widgets/incidence_list.dart';
import 'package:aray/services/api.dart';

/// Vista de incidencias de Aray: lista las incidencias en curso, en tarjetas,
/// permitiendo acceder a los detalles de cada incidencia.
class IncidencesPage extends StatelessWidget {

  final _apiService = new APIService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Incidencias"),
      ),
      body: IncidenceList(_apiService),
    );
  }
}