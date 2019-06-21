/// Módulo que contiene una implementación de un widget para mostrar
/// el mapa de incidencias de Aray, incluyendo funciones auxiliares para
/// mantener el estado y actualizar las incidencias, en caso de que ocurran.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aray/styles/markers.dart';
import 'package:aray/env.dart';
import 'package:aray/models/reporte.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

/// Widget que muestra el mapa de incidencias de Aray. El estado
/// es manejado por IncidenceMapState
class IncidenceMap extends StatefulWidget {

  // Controladores del mapa y gestor de ubicaciones, inyectados
  // desde el widget padre, y servicio de la API
  final mapController;
  final locationManager;
  final apiService;

  IncidenceMap(this.mapController, this.locationManager, this.apiService);

  @override
  _IncidenceMapState createState() => _IncidenceMapState(this.mapController, this.locationManager, this.apiService);
}

/// Manejador de estado para el widget de Mapa de Incidencias. Muestra las incidencias
/// e indicadores cercanos al usuario, y actualiza constantemente el mapa
/// según la ubicación y el movimiento del mismo.
class _IncidenceMapState extends State<IncidenceMap> {

  // Controladores del mapa y gestor de ubicaciones, inyectados
  // desde el widget padre, y servicio de la API
  final mapController;
  final locationManager;
  final apiService;

  _IncidenceMapState(this.mapController, this.locationManager, this.apiService);

  // Variables para almacenar la ubicación actual, el zoom por defecto
  // y verificar si el mapa ya ha sido centrado (al iniciar)
  var _currentLocation;
  var defaultZoom = 17.75;
  var alreadyCentered = false;

  // Variables para almacenar los marcadores, y poder cargar el mapa
  // al inicio mientras se espera por los mismos
  var markersAlreadyFetched = false;
  List<Marker> markers = [];

  // Variable para almacenar el suscriptor a los cambios de ubicacion
  var locationSubscription;

  @override
  void initState() {
    super.initState();

    // Inicia la búsqueda de datos de ubicación
    initLocationState();

    // Inicia la búsqueda de marcadores para el mapa (reportes)
    initMarkerFetch();
  }

  /// Obtiene el arreglo de marcadores de la API si no se han obtenido previamente
  void initMarkerFetch() async {
    await this.apiService.initClient();
    this.markers = await getMarkers();

    setState(() {
      this.markersAlreadyFetched = true;
    });

    Timer.periodic(
      Duration(seconds: 10),
      (Timer t) async {
        this.markers = await getMarkers();

        setState(() {
          this.markersAlreadyFetched = true;
        });
      }
    );
  }

  /// Obtiene la ubicación del usuario, suscribiendo el mapa de incidencias a cualquier
  /// cambio de ubicación y almacenando esta información
  /// TODO: ¿Es realmente necesario suscribrnos a los cambios? Detalle de eficiencia
  void initLocationState() async {
    try {
      // Suscribiendo el mapa a los cambios de posición del dispositivo
      this.locationSubscription = this.locationManager.onLocationChanged().listen((LocationData fetchedLocation) {
        // Actualizamos el estado para renderizar de nuevo el mapa
        setState(() {
          _currentLocation = fetchedLocation;

          // Centra el mapa si no ha sido centrado al abrir el mapa
          if (!alreadyCentered) {
            alreadyCentered = true;
            this.mapController.move(getCurrentLocation(), this.defaultZoom);
          }
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

  /// Retorna el diccionario con las opciones de renderizaje del mapa,
  /// incluyendo la ubicación de manera dinámica
  MapOptions getMapOptions() => new MapOptions(
    center: getCurrentLocation(),
    zoom: this.defaultZoom,
  );

  /// Retorna un marcador con la ubicación actual del usuario
  Marker getCurrentPositionMarker() {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: getCurrentLocation(),
      builder: (ctx) => new Tooltip(
        child: new Container(
          child: ArayMarkers.currentPosition,
        ),
        message: "Tu ubicación",
        excludeFromSemantics: true,
      ),
    );
  }

  /// Retorna una lista de marcadores a posicionar en el mapa
  Future<List<Marker>> getMarkers() async {
    List<Reporte> reportes = await this.apiService.getReportes(
      position: getCurrentLocation()
    );

    List<Marker> APIMarkers = reportes.map((reporte) => reporte.marker).toList();

    return APIMarkers;
  }

  /// Retorna la configuración del proveedor del mapa
  TileLayerOptions getMapProvider() => new TileLayerOptions(
    urlTemplate: "https://api.tiles.mapbox.com/v4/"
        "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
    additionalOptions: {
      'accessToken': ENV['MAPBOX_API_KEY'],
      'id': 'mapbox.streets',
    }
  );

  @override
  Widget build(BuildContext context) {

    return new FlutterMap(
      options: getMapOptions(),
      layers: [
        getMapProvider(),
        new MarkerLayerOptions(
          markers: [getCurrentPositionMarker()] + this.markers,
        )
      ],
      mapController: this.mapController,
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (this.locationSubscription != null) {
      this.locationSubscription.cancel();
    }
  }
}
