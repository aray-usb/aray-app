/// Módulo que contiene un formulario de reporte a desplegar
/// en un modal (Alert dialog) para solicitar asistencia.

import 'package:flutter/material.dart';
import 'package:aray/styles/colors.dart';

class AyudaForm extends StatefulWidget {

  static final _formKey = GlobalKey<FormState>();

  final api;
  final location;
  final incidencias;

  AyudaForm(this.api, this.location, this.incidencias);

  @override
  _AyudaFormState createState() => _AyudaFormState();
}

class _AyudaFormState extends State<AyudaForm> {

  int incidenciaId;

  bool formEnviado = false;

  Widget mostrarMensaje(mensaje) => AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("$mensaje", textAlign: TextAlign.center,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
            child: Text("Cerrar"),
            color: ArayColors.primary,
            onPressed: () => Navigator.pop(context),
          ),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {

    if (this.formEnviado) {
      return mostrarMensaje("La solicitud de ayuda fue enviada exitosamente. Puedes actualizar el mapa.");
    }

    List<DropdownMenuItem<int>> opciones = [
      DropdownMenuItem<int>(
        value: -1,
        child: Text("Incidencia nueva"),
      )
    ];

    for (int i = 0; i < this.widget.incidencias.length; i++) {
      if (!this.widget.incidencias[i].perteneceAHistorico) {
        opciones.add(
          DropdownMenuItem<int>(
            value: this.widget.incidencias[i].id,
            child: Text("${this.widget.incidencias[i].nombre}"),
          )
        );
      }
    }

    return AlertDialog(
      content: Form(
        key: AyudaForm._formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownButton<int>(
              items: opciones,
              hint: Text('Selecciona una incidencia...'),
              value: incidenciaId,
              onChanged: (id) {
                setState(() {
                  incidenciaId = id;
                });
              },
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                child: Text("¡Ayuda!"),
                color: ArayColors.primary,
                onPressed: () async {
                  if (AyudaForm._formKey.currentState.validate()) {
                    AyudaForm._formKey.currentState.save();
                    final currentLocation = await widget.location.getLocation();
                    await widget.api.createReporte(
                      currentLocation.latitude,
                      currentLocation.longitude,
                      incidenciaId,
                      "¡Solicitud de ayuda!",
                      true
                    );
                    setState(() {
                      formEnviado = true;
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}