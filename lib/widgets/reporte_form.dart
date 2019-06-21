/// Módulo que contiene un formulario de reporte a desplegar
/// en un modal (Alert dialog).

import 'package:flutter/material.dart';
import 'package:aray/styles/colors.dart';

class ReporteForm extends StatefulWidget {

  static final _formKey = GlobalKey<FormState>();

  final api;
  final location;
  final incidencias;

  ReporteForm(this.api, this.location, this.incidencias);

  @override
  _ReporteFormState createState() => _ReporteFormState();
}

class _ReporteFormState extends State<ReporteForm> {

  int incidenciaId;

  bool formEnviado = false;

  final contenidoController = TextEditingController();

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
      return mostrarMensaje("El reporte fue creado exitosamente. Puedes actualizar el mapa.");
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
        key: ReporteForm._formKey,
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
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: contenidoController,
                decoration: InputDecoration(
                  hintText: "¿Qué ocurre?",
                  icon: Icon(Icons.list),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                child: Text("Enviar Reporte"),
                color: ArayColors.primary,
                onPressed: () async {
                  if (ReporteForm._formKey.currentState.validate()) {
                    ReporteForm._formKey.currentState.save();
                    final currentLocation = await widget.location.getLocation();
                    await widget.api.createReporte(
                      currentLocation.latitude,
                      currentLocation.longitude,
                      incidenciaId,
                      contenidoController.text,
                      false
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