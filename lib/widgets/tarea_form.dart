/// Módulo que contiene un formulario de reporte a desplegar
/// en un modal (Alert dialog) para agregar una tarea.

import 'package:flutter/material.dart';
import 'package:aray/styles/colors.dart';
import 'package:flutter/widgets.dart';

class TareaForm extends StatefulWidget {

  static final _formKey = GlobalKey<FormState>();

  final api;

  TareaForm(this.api);

  @override
  _AyudaFormState createState() => _AyudaFormState();
}

class _AyudaFormState extends State<TareaForm> {

  bool formEnviado = false;
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  final fechaLimiteController = TextEditingController();

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
      return mostrarMensaje("La tarea fue creada exitosamente. Puedes actualizar la lista de tareas.");
    }

    return AlertDialog(
      content: Form(
        key: TareaForm._formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: tituloController,
                decoration: InputDecoration(
                  hintText: "Título",
                  icon: Icon(Icons.star),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: descripcionController,
                decoration: InputDecoration(
                  hintText: "Descripción",
                  icon: Icon(Icons.list),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: fechaLimiteController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: "Fecha Límite",
                  icon: Icon(Icons.calendar_today),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                child: Text("¡Ayuda!"),
                color: ArayColors.primary,
                onPressed: () async {
                  if (TareaForm._formKey.currentState.validate()) {
                    TareaForm._formKey.currentState.save();
                    await widget.api.createTarea(
                      tituloController.text,
                      descripcionController.text,
                      fechaLimiteController.text,
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