/// Módulo que contiene una implementación de un widget para mostrar
/// el mapa de incidencias de Aray, incluyendo funciones auxiliares para
/// mantener el estado y actualizar las incidencias, en caso de que ocurran.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';
import 'package:aray/styles/markers.dart';

class IncidenceMap extends StatefulWidget {

  @override
  _IncidenceMapState createState() => _IncidenceMapState();
}

class _IncidenceMapState extends State<IncidenceMap> {

  var _currentLocation;
  var _locationManager = new Location();
  var _mapControler = new MapController();

  @override
  initState() {
    super.initState();

    initLocationState();
  }

  initLocationState() async {
    try {
      var fetchedLocation = await _locationManager.getLocation();

      setState(() {
        _currentLocation = fetchedLocation;
        _mapControler.move(getCurrentLocation(), 18.0);
      });
    } on Exception catch (_) {
      _currentLocation = null;
    }
  }

  LatLng getCurrentLocation() {
    if (this._currentLocation == null) {
      // para pruebas, ubicación del Dpto. de Computación y TI (USB)
      return LatLng(10.409153, -66.883417);
    }

    return new LatLng(
      this._currentLocation.latitude,
      this._currentLocation.longitude
    );
  }

  List<Marker> getMarkers() => <Marker>[
    new Marker(
      width: 80.0,
      height: 80.0,
      point: getCurrentLocation(),
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
        center: getCurrentLocation(),
        zoom: 18.0,
      ),
      layers: [
        new TileLayerOptions(
            urlTemplate:
                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        new MarkerLayerOptions(markers: getMarkers())
      ],
      mapController: this._mapControler,
    );
  }
}
