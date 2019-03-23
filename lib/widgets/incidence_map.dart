/// Módulo que contiene una implementación de un widget para mostrar
/// el mapa de incidencias de Aray, incluyendo funciones auxiliares para
/// mantener el estado y actualizar las incidencias, en caso de que ocurran.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';
import 'package:aray/styles/markers.dart';

/// Widget que muestra el mapa de incidencias de Aray. El estado
/// es manejado por IncidenceMapState
class IncidenceMap extends StatefulWidget {

  @override
  _IncidenceMapState createState() => _IncidenceMapState();
}

/// Manejador de estado para el widget de Mapa de Incidencias. Muestra las incidencias
/// e indicadores cercanos al usuario, y actualiza constantemente el mapa
/// según la ubicación y el movimiento del mismo.
class _IncidenceMapState extends State<IncidenceMap> {

  // Variables para almacenar la ubicación y controles de posición y mapa
  var _currentLocation;
  var _locationManager = new Location();
  var _mapControler = new MapController();

  @override
  void initState() {
    super.initState();

    // Para iniciar la búsqueda de datos de ubicación
    initLocationState();
  }

  /// Obtiene la ubicación del usuario, suscribiendo el mapa de incidencias a cualquier
  /// cambio de ubicación y almacenando esta información
  void initLocationState() async {
    try {
      // Suscribiendo el mapa a los cambios de posición del dispositivo
      _locationManager.onLocationChanged().listen((LocationData fetchedLocation) {
        // Actualizamos el estado para renderizar de nuevo el mapa y centrarlo en la nueva posición
        setState(() {
          _currentLocation = fetchedLocation;
          _mapControler.move(getCurrentLocation(), 18.0);
        });
      });
    } on Exception catch (_) {
      // Si se cae en este caso, probablemente no se otorgó el permiso
      // de utilizar la ubicación.
      // TODO: Mostrar un modal que indique al usuario que sin ubicación la app no funciona bien
      // TODO: Mostrar un botón para solicitar el permiso de nuevo (si se puede)
      _currentLocation = null;
    }
  }

  /// Retorna la posición actual del usuario, si se cuenta con la información,
  /// o una posición de pruebas (mock)
  LatLng getCurrentLocation() {
    if (this._currentLocation == null) {
      // para pruebas, ubicación del Dpto. de Computación y TI (USB)
      return LatLng(10.409153, -66.883417);
    }

    // Se retorna la última ubicación conocida, dada por la latitud y longitud
    return new LatLng(
      this._currentLocation.latitude,
      this._currentLocation.longitude
    );
  }

  /// Retorna una lista de marcadores a posicionar en el mapa
  //  TODO: Obtener marcadores de la API dinámicamente según la posición
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
            // TODO: Buscar un mejor proveedor de mapas
            urlTemplate:
                "https://{s}.tile.openstreetmap.se/hydda/full/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        new MarkerLayerOptions(markers: getMarkers())
      ],
      mapController: this._mapControler,
    );
  }
}
