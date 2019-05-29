/// Definiciones de estilo referentes a los colores oficiales de la aplicación.
import 'dart:ui';
import 'package:flutter/material.dart';

/// Define como variables estáticas los colores oficiales de la aplicación.
class ArayColors {

  // Color primario de Aray
  static const Color primary = const Color(0xFFFF582A);
  static const Color secondary = const Color(0xFFFF6858);

  // Colores de gradiente para Login
  static const Color loginGradientStart = const Color(0xFFFBAB66);
  static const Color loginGradientEnd = const Color(0xFFF7418C);
  static const List<Color> primaryGradientColors = const [loginGradientStart, loginGradientEnd];

  // Gradiente principal para Login
  static const LinearGradient primaryGradient = const LinearGradient(
    colors: primaryGradientColors,
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Sombra en gradiente para el Login
  static const List<BoxShadow> primaryGradientBoxShadows = const <BoxShadow>[
    BoxShadow(
      color: ArayColors.loginGradientStart,
      offset: Offset(1.0, 6.0),
      blurRadius: 20.0,
    ),
    BoxShadow(
      color: ArayColors.loginGradientEnd,
      offset: Offset(1.0, 6.0),
      blurRadius: 20.0,
    ),
  ];
}