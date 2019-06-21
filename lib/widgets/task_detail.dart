/// Módulo que contiene un pop-up modal para mostrar
/// los detalles de una tarea cargada en sistema.

import 'package:flutter/material.dart';
import 'package:aray/models/tarea.dart';
import 'package:aray/styles/colors.dart';

class TaskDetail extends StatelessWidget {

  final Tarea tarea;

  TaskDetail(this.tarea);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "${tarea.titulo}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Divider(),
          Text("Descripción: ${tarea.descripcion ?? 'N/A'}"),
          Text("Estado: ${Tarea.NOMBRE_ESTADO[tarea.estado]}"),
          Divider(),
          tarea.fechaLimite!= null
            ? Text("Fecha Límite: ${tarea.fechaLimite.day}/${tarea.fechaLimite.month}/${tarea.fechaLimite.year}")
            : Text("No tiene fecha límite"),
          tarea.fechaDeResolucion != null
            ? Text("Fecha de Resolución: ${tarea.fechaDeResolucion.day}/${tarea.fechaDeResolucion.month}/${tarea.fechaDeResolucion.year}")
            : Text("No ha sido resuelta aún"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              child: Text("Cerrar"),
              onPressed: () => Navigator.pop(context),
              color: ArayColors.primary,
            ),
          )
        ],
      )
    );
  }
}