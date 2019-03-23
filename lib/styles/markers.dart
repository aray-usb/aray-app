/// Definiciones de estilo referentes a los distintos marcadores que pueden
/// aparecer en un mapa, colores, alertas, etc.

import 'package:flutter/material.dart';

/// Contiene distintos tipos de marcadores que pueden superponerse a un mapa
/// indicando información relevante.
class ArayMarkers {

  // Objeto genérico, para pruebas
  static final Icon genericMarker = Icon(
    Icons.location_on,
    size: 56,
    color: Colors.red,
  );

  // Denota la ubicación actual de la persona
  static final Icon currentPosition = Icon(
    Icons.my_location,
    size: 56,
    color: Color(0xFF1DC7EA),
  );
}