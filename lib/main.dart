import 'package:flutter/material.dart';
import 'package:aray/views/home.dart';
import 'package:aray/views/credits.dart';
import 'package:aray/views/incidences.dart';

void main() => runApp(ArayApp());

class ArayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aray',
      theme: ThemeData(
        primaryColor: Color(0xFF1DC7EA),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/creditos': (context) => CreditsPage(),
        '/incidencias': (context) => IncidencesPage(),
      },
    );
  }
}
