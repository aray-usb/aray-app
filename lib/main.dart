import 'package:flutter/material.dart';
import 'package:aray/views/login.dart';
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
      initialRoute: '/login',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/creditos': (context) => CreditsPage(),
        '/incidencias': (context) => IncidencesPage(),
      },
    );
  }
}
