/// Módulo para el desarrollo de la vista de créditos de Aray

import 'package:flutter/material.dart';
import 'package:aray/widgets/credits_box.dart';

/// Vista de créditos de Aray: muestra alguna información útil sobre versión
/// y autores del app, licencias, propiedad, copyright, entre otros.
class CreditsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Créditos"),
      ),
      body: CreditsBox(),
    );
  }
}