/// Módulo que contiene un pop-up modal para mostrar
/// los detalles de una tarea cargada en sistema.

import 'package:flutter/material.dart';
import 'package:aray/models/tarea.dart';
import 'package:aray/styles/colors.dart';
import 'package:aray/services/api.dart';

class TaskDetail extends StatefulWidget {

  final Tarea tarea;
  final APIService api;

  TaskDetail(this.tarea, this.api);

  @override
  _TaskDetailState createState() => _TaskDetailState(tarea, api);
}

class _TaskDetailState extends State<TaskDetail> {

  Tarea tarea;
  APIService api;

  _TaskDetailState(this.tarea, this.api);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "${widget.tarea.titulo}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Divider(),
          Text("Descripción: ${widget.tarea.descripcion ?? 'N/A'}"),
          Text("Estado: ${Tarea.NOMBRE_ESTADO[widget.tarea.estado]}"),
          Divider(),
          widget.tarea.fechaLimite!= null
            ? Text("Fecha Límite: ${widget.tarea.fechaLimite.day}/${widget.tarea.fechaLimite.month}/${widget.tarea.fechaLimite.year}")
            : Text("No tiene fecha límite"),
          widget.tarea.fechaDeResolucion != null
            ? Text("Fecha de Resolución: ${widget.tarea.fechaDeResolucion.day}/${widget.tarea.fechaDeResolucion.month}/${widget.tarea.fechaDeResolucion.year}")
            : Text("No ha sido resuelta aún"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              child: Text("Cerrar"),
              onPressed: () => Navigator.pop(context),
              color: ArayColors.primary,
            ),
          ),
        ],
      )
    );
  }
}