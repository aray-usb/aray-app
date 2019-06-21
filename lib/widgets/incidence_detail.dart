/// Módulo que contiene un pop-up modal para mostrar
/// los detalles de una incidencia cargada en sistema.

import 'package:flutter/material.dart';
import 'package:aray/models/incidencia.dart';
import 'package:aray/styles/colors.dart';

class IncidenceDetail extends StatelessWidget {

  final Incidencia incidencia;

  IncidenceDetail(this.incidencia);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "${incidencia.nombre}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Divider(),
          Text("Descripción: ${incidencia.descripcion ?? 'N/A'}"),
          Text("Estado: ${Incidencia.NOMBRE_ESTADO[incidencia.estado]}"),
          Divider(),
          Text("Latitud: ${incidencia.latitud}"),
          Text("Longitud: ${incidencia.longitud}"),
          Text("Radio: ${incidencia.radio}m"),
          Divider(),
          Text("Fecha de Reporte: ${incidencia.fechaDeReporte.day}/${incidencia.fechaDeReporte.month}/${incidencia.fechaDeReporte.year}"),
          incidencia.fechaDeResolucion != null
            ? Text("Fecha de Resolución: ${incidencia.fechaDeResolucion.day}/${incidencia.fechaDeResolucion.month}/${incidencia.fechaDeResolucion.year}")
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