/// Módulo que contiene un formulario de reporte a desplegar
/// en un modal (Alert dialog).

import 'package:flutter/material.dart';
import 'package:aray/styles/colors.dart';

class ReporteForm extends StatelessWidget {

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Descripción",
                  icon: Icon(Icons.list),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                child: Text("Enviar Reporte"),
                color: ArayColors.primary,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    // TODO: Mandar el reporte
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