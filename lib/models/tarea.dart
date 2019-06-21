/// Módulo para el desarrollo de una abstracción-clase
/// para el manejo de las tareas.

import 'package:flutter/material.dart';

/// Representa una tarea asociada a algún usuario.
class Tarea {

  // Estados posibles de la tarea
  static const ESTADO_NUEVA = 0;
  static const ESTADO_EN_PROGRESO = 1;
  static const ESTADO_RESUELTA = 2;

  // Nombres de los posibles estados
  static const NOMBRE_ESTADO = {
    ESTADO_NUEVA: "Nueva",
    ESTADO_EN_PROGRESO: "En Progreso",
    ESTADO_RESUELTA: "Resuelta",
  };

  // ID numérico de la tarea
  final int id;

  // Título de la tarea
  final String titulo;

  // Descripción de la tarea
  final String descripcion;

  // Entero correspondiente al estado del reporte
  final int estado;

  // Fecha limite de la tarea
  final DateTime fechaLimite;

  // Fecha de resolución de la tarea
  final DateTime fechaDeResolucion;

  Tarea({
    this.id,
    this.titulo,
    this.descripcion,
    this.estado,
    this.fechaLimite,
    this.fechaDeResolucion,
  });

  /// Retorna una nueva instancia de Tarea a partir de un objeto JSON
  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      estado: json['estado'],
      fechaLimite:
          json['fecha_limite'] != null
        ? DateTime.parse(json['fecha_limite'])
        : null,
      fechaDeResolucion:
          json['fecha_de_resolucion'] != null
        ? DateTime.parse(json['fecha_de_resolucion'])
        : null,
    );
  }

  /// Retorna una lista de Reportes a partir de un JSON de múltiples objetos
  static List<Tarea> fromJsonList(List<dynamic> json) {
    return json.map((object) =>  Tarea.fromJson(object)).toList();
  }

  /// Retorna una representación como cadena de caracteres del Tarea
  String toString() => "${this.titulo}:\n${this.descripcion}";

  /// Retorna un tile de la tarea para una lista
  ListTile get tile => ListTile(
    leading: Icon(Icons.star),
    title: Text('$titulo'),
    subtitle: Text('Estatus: ${NOMBRE_ESTADO[estado]}.\n$descripcion'),
  );

  /// Determina si una Incidencia debe pertenecer al histórico
  /// o a las incidencias actuales.
  bool get perteneceAHistorico =>
    this.estado == Tarea.ESTADO_RESUELTA;

}