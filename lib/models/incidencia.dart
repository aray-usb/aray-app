/// Módulo para el desarrollo de una abstracción-clase
/// para el manejo de las incidencias.

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

/// Representa un reporte asociado a alguna incidencia.
class Incidencia {

  // Estados posibles de la incidencia
  static const ESTADO_RECHAZADA = -1;
  static const ESTADO_NUEVA = 0;
  static const ESTADO_CONFIRMADA = 1;
  static const ESTADO_ATENDIDA = 2;
  static const ESTADO_RESUELTA = 3;

  // ID numérico de la incidencia
  final int id;

  // Nombre de la incidencia
  final String nombre;

  // Descripción de la incidencia
  final String descripcion;

  // Entero correspondiente al estado de la incidencia
  final int estado;

  // Fecha de carga de la incidencia
  final DateTime fechaDeReporte;

  // Fecha de resolución de la incidencia
  final DateTime fechaDeResolucion;

  // Latitud de la incidencia
  final double latitud;

  // Longitud de la incidencia
  final double longitud;

  // Radio de la incidencia
  final int radio;

  Incidencia({
    this.id,
    this.latitud,
    this.longitud,
    this.radio,
    this.nombre,
    this.descripcion,
    this.estado,
    this.fechaDeReporte,
    this.fechaDeResolucion,
  });

  /// Retorna una nueva instancia de Reporte a partir de un objeto JSON
  factory Incidencia.fromJson(Map<String, dynamic> json) {
    return Incidencia(
      id: json['id'],
      latitud: double.parse(json['latitud']),
      longitud: double.parse(json['longitud']),
      radio: json['radio'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      estado: json['estado'],
      fechaDeReporte: DateTime.parse(json['fecha_de_reporte']),
      fechaDeResolucion:
          json['fecha_de_resolucion'] != null
        ? DateTime.parse(json['fecha_de_resolucion'])
        : null,
    );
  }

  /// Retorna una lista de Incidencias a partir de un JSON de múltiples objetos
  static List<Incidencia> fromJsonList(List<dynamic> json) {
    return json.map((object) =>  Incidencia.fromJson(object)).toList();
  }

  /// Posición del Reporte como LatLng
  LatLng get posicion => LatLng(
    this.latitud,
    this.longitud
  );

  /// Retorna una representación como cadena de caracteres del Reporte
  String toString() => "${this.nombre}";

  /// Retorna un tile de la incidencia para la lista
  ListTile get tile => ListTile(
    leading: Icon(Icons.notification_important),
    title: Text('$nombre'),
    subtitle: Text('Estatus: En curso.\n$descripcion'),
  );

  /// Determina si una Incidencia debe pertenecer al histórico
  /// o a las incidencias actuales.
  bool get perteneceAHistorico =>
    this.estado == Incidencia.ESTADO_RECHAZADA ||
    this.estado == Incidencia.ESTADO_RESUELTA;
}