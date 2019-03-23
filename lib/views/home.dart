import 'package:flutter/material.dart';
import 'package:aray/widgets/aray_drawer.dart';
import 'package:aray/widgets/incidence_map.dart';

class HomePage extends StatelessWidget {

  final String title;

  HomePage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      drawer: ArayDrawer(),
      body: MainMap(),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.flare),
        onPressed: () {

        },
        label: Text("Solicitar Ayuda"),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}