import 'package:flutter/material.dart';
import 'package:aray/views/home.dart';
import 'package:aray/views/credits.dart';
import 'package:aray/views/incidences.dart';
import 'package:aray/styles/colors.dart';

void main() => runApp(ArayApp());

class ArayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aray',
      theme: ThemeData(
        primaryColor: ArayColors.primary,
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
