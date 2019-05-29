/// Definiciones de estilo referentes a los colores oficiales de la aplicación.
import 'dart:ui';
import 'package:flutter/material.dart';

/// Define como variables estáticas los colores oficiales de la aplicación.
class ArayColors {

  // Color primario de Aray
  static const Color primary = const Color(0xFFFF582A);
  static const Color secondary = const Color(0xFFFF6858);

  // Colores de gradiente para Login
  static const Color loginGradientStart = const Color(0xFFfbab66);
  static const Color loginGradientEnd = const Color(0xFFf7418c);

  // Gradiente principal para Login
  static const LinearGradient primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}