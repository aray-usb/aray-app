/// Módulo para el desarrollo del listado de Tareas

import 'package:flutter/material.dart';
import 'package:aray/widgets/task_list.dart';
import 'package:aray/services/api.dart';

/// Vista de tareas de Aray: lista las tareas en curso, en tarjetas,
/// permitiendo acceder a los detalles de cada tarea.
class TasksPage extends StatelessWidget {

  final _apiService = new APIService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tareas"),
      ),
      body: TaskList(_apiService),
    );
  }
}