import 'package:flutter/material.dart';
import 'package:aray/views/home.dart';

void main() => runApp(ArayApp());

class ArayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aray',
      theme: ThemeData(
        primaryColor: Color(0xFF1DC7EA),
      ),
      home: HomePage(title: 'Inicio'),
    );
  }
}
