/// Módulo para el desarrollo de widgets referentes a la vista de Créditos

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

/// Contenedor de la descripción de créditos de la aplicación
class CreditsBox extends StatefulWidget {

  @override
  _CreditsBoxState createState() => _CreditsBoxState();
}

class _CreditsBoxState extends State<CreditsBox> {

  var _version;
  var _build;

  @override
  void initState() {
    super.initState();
    fetchVersionNumber();
  }

  void fetchVersionNumber() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _version = packageInfo.version;
        _build = packageInfo.buildNumber;
      });
    });
  }

  Widget getVersionWidget() {
    if (_version == null || _build == null) {
      return Text("Versión desconocida");
    }

    return Text("Versión $_version (build $_build)");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(32.0),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
            child: Image.asset('images/usb.png'),
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
          Divider(color: Colors.transparent),
          Container(
            child: Image.asset('images/aray.png'),
            margin: const EdgeInsets.all(16.0),
          ),
          Text(
            'Aray',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          getVersionWidget(),
          Text(
            'Desarrollado por Andrés Ignacio Torres y Jawil Ricauter Dodero.',
            textAlign: TextAlign.center
          ),
          Text(
            'Tutora: Prof. Ivette C. Martínez.',
            textAlign: TextAlign.center
          ),
        ],
      )
    );
  }
}