/// Módulo que contiene una implementación de menú lateral para la app
/// a modo de un drawer.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aray/views/login.dart';

/// Menú lateral de tipo Drawer. Contiene un esquema de navegación general
/// de la aplicación y permite acceder a las distintas secciones.
class ArayDrawer extends Drawer {

  Future<void> logOut(BuildContext context) async {
    // Eliminamos el token del localStorage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => LoginPage()
      )
    );
  }

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
              Navigator.pushNamed(context, '/incidencias');
            },
          ),
          ListTile(
            title: Text('Tareas'),
            leading: Icon(Icons.list),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/tareas');
            },
          ),
          Divider(),
          ListTile(
            title: Text('Créditos'),
            leading: Icon(Icons.info_outline),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/creditos');
            },
          ),
          Divider(),
          ListTile(
            title: Text('Cerrar Sesión'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.pop(context);
              logOut(context);
            },
          ),
        ],
      ),
    );
  }
}
