/// Módulo para el desarrollo de una abstracción-clase
/// para el manejo de los reportes.

import 'package:flutter/material.dart';
import 'package:aray/styles/markers.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';


/// Representa un reporte asociado a alguna incidencia.
class Reporte {

  // ID numérico del reporte
  final int id;

  // ID de la incidencia asociada
  final int incidenciaId;

  // Nombre de la incidencia asociada
  final String incidencia;

  // Contenido del reporte
  final String contenido;

  // Entero correspondiente al estado del reporte
  final int estado;

  // Fecha de carga del reporte
  final DateTime fechaDeReporte;

  // Latitud del reporte
  final double latitud;

  // Longitud del reporte
  final double longitud;

  // Si el reporte es una solicitud de ayuda o no
  final bool esSolicitudDeAyuda;

  Reporte({
    this.id,
    this.incidenciaId,
    this.incidencia,
    this.contenido,
    this.estado,
    this.fechaDeReporte,
    this.latitud,
    this.longitud,
    this.esSolicitudDeAyuda
  });

  /// Retorna una nueva instancia de Reporte a partir de un objeto JSON
  factory Reporte.fromJson(Map<String, dynamic> json) {
    return Reporte(
      id: json['id'],
      incidenciaId: json['incidencia']['id'],
      incidencia: json['incidencia']['nombre'],
      contenido: json['contenido'],
      estado: json['estado'],
      fechaDeReporte: DateTime.parse(json['fecha_de_reporte']),
      latitud: double.parse(json['latitud']),
      longitud: double.parse(json['longitud']),
      esSolicitudDeAyuda: json['es_solicitud_de_ayuda']
    );
  }

  /// Retorna una lista de Reportes a partir de un JSON de múltiples objetos
  static List<Reporte> fromJsonList(List<dynamic> json) {
    return json.map((object) =>  Reporte.fromJson(object)).toList();
  }

  /// Posición del Reporte como LatLng
  LatLng get posicion => LatLng(
    this.latitud,
    this.longitud
  );

  /// Retorna una representación como cadena de caracteres del Reporte
  String toString() => "${this.incidencia}:\n${this.contenido}";

  /// Marcador correspondiente al Reporte para el mapa
  Marker get marker => Marker(
    width: 60.0,
    height: 60.0,
    point: this.posicion,
    builder: (ctx) => new Tooltip(
      child: new Container(
        child:
          this.esSolicitudDeAyuda
        ? ArayMarkers.helpMarker
        : ArayMarkers.genericMarker
      ),
      message: this.toString(),
      excludeFromSemantics: true,
    )
  );
}