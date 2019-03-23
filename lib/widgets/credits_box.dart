/// Módulo para el desarrollo de widgets referentes a la vista de Créditos

import 'package:flutter/material.dart';

/// Contenedor de la descripción de créditos de la aplicación
class CreditsBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
            child: Image(image: AssetImage('images/aray.png')),
            margin: const EdgeInsets.all(16.0),
          ),
          Text(
            'Aray',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Desarrollado por Andrés Ignacio Torres y Jawil Ricauter Dodero, bajo la tutoría de la Prof. Ivette C. Martínez.',
            textAlign: TextAlign.center
          ),
          Divider(color: Colors.transparent),
          Container(
            child: Image(image: AssetImage('images/usb.png')),
            margin: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 64.0
            ),
          ),
          Text(
            'Universidad Simón Bolívar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Miniproyecto de Desarrollo de Software',
            textAlign: TextAlign.center
          ),
          Text(
            'Trimestre Enero - Marzo 2019',
            textAlign: TextAlign.center
          ),
        ],
      )
    );
  }
}