/// Módulo que contiene una implementación de menú lateral para la app
/// a modo de un drawer.

import 'package:flutter/material.dart';

/// Menú lateral de tipo Drawer. Contiene un esquema de navegación general
/// de la aplicación y permite acceder a las distintas secciones.
class ArayDrawer extends Drawer {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Fulanito"),
            accountEmail: Text("fulanito@usb.ve"),
          ),
          ListTile(
            title: Text('Inicio'),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Incidencias'),
            leading: Icon(Icons.stars),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Prevención'),
            leading: Icon(Icons.list),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            title: Text('Cerrar Sesión'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
