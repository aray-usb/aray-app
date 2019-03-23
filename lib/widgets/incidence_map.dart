/// Módulo que contiene una implementación de un widget para mostrar
/// el mapa de incidencias de Aray, incluyendo funciones auxiliares para
/// mantener el estado y actualizar las incidencias, en caso de que ocurran.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:aray/styles/markers.dart';

class MainMap extends StatefulWidget {

  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {

  final markers = <Marker>[
    new Marker(
      width: 80.0,
      height: 80.0,
      point: new LatLng(10.409153, -66.883417),
      builder: (ctx) => new Container(
            child: ArayMarkers.currentPosition,
          ),
    ),
    new Marker(
      width: 80.0,
      height: 80.0,
      point: new LatLng(10.411992, -66.881605),
      builder: (ctx) => new Container(
            child: ArayMarkers.genericMarker,
          ),
    ),
    new Marker(
      width: 80.0,
      height: 80.0,
      point: new LatLng(10.410161, -66.882549),
      builder: (ctx) => new Container(
            child: ArayMarkers.genericMarker,
          ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return new FlutterMap(
      options: new MapOptions(
        center: new LatLng(10.409153, -66.883417),
        zoom: 18.0,
      ),
      layers: [
        new TileLayerOptions(
            urlTemplate:
                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        new MarkerLayerOptions(markers: markers)
      ],
    );
  }
}
