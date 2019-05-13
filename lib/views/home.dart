/// Módulo para el desarrollo de la vista inicial de Aray

import 'package:flutter/material.dart';
import 'package:aray/services/api.dart';
import 'package:aray/widgets/aray_drawer.dart';
import 'package:aray/widgets/incidence_map.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

/// Vista inicial de Aray: despliega el mapa de incidencias, centrado
/// en la ubicación del usuario (si es posible obtenerla) con los
/// marcadores a su alrededor, y permite enviar un reporte o solicitar
/// ayuda.
class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

/// Manejador de estado para la vista inicial de Aray. Actualiza el mapa
/// por petición del usuario en caso de que desee centrarlo en su ubicación.
class _HomePageState extends State<HomePage> {

  // Controlador del mapa y manejador de ubicación del usuario, para
  // inyectar desde la vista hacia el widget de mapa de incidencias
  final _mapController = new MapController();
  final _locationManager = new Location();
  final _apiService = new APIService();

  /// Retorna la última ubicación conocida del usuario.
  /// INFO: Actualmente, solicita la ubicación de nuevo con poca precisión.
  /// TODO: Refactorizar. Esperar respuesta a PR en el repositorio del plugin location.
  Future<LocationData> getlastKnownLocation() async {
    // Configura el manejador para tener poca precisión
    this._locationManager.changeSettings(
      accuracy: LocationAccuracy.POWERSAVE
    );

    // Obtiene la ubicación del usuario
    var currentLocation = await _locationManager.getLocation();

    // Reestablece la precisión del manejador antes de retornar
    this._locationManager.changeSettings(
      accuracy: LocationAccuracy.HIGH
    );

    return currentLocation;
  }

  /// Centra el mapa de incidencias del home a la posición actual del usuario.
  void centrarMapa() async {

    // Obtiene y transforma la ubicación actual a una instancia de LatLng
    var currentLocation = await getlastKnownLocation();
    var centerLocation = LatLng(
      currentLocation.latitude,
      currentLocation.longitude
    );

    // Actualiza el estado del mapa, si el controlador está listo
    // (previene una excepción justo al abrir la vista)
    if (this._mapController.ready) {
      setState(() {
        this._mapController.move(centerLocation, this._mapController.zoom);
      });
    }
  }

  /// Retorna la fila de botones FAB para permitir al usuario
  /// interactuar con el mapa
  Widget getFloatingActionButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FloatingActionButton.extended(
          heroTag: 'ayuda',
          icon: Icon(Icons.warning),
          onPressed: () {

          },
          label: Text("Ayuda"),
          backgroundColor: Colors.red,
        ),
        FloatingActionButton(
          heroTag: 'ubicar',
          child: Icon(Icons.my_location),
          onPressed: () => centrarMapa(),
          tooltip: "Ayuda",
          backgroundColor: Colors.blue,
        ),
        FloatingActionButton.extended(
          heroTag: 'reporte',
          icon: Icon(Icons.perm_device_information),
          onPressed: () {

          },
          label: Text("Reporte"),
          backgroundColor: Colors.orange,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Aray"),
      ),
      drawer: ArayDrawer(),
      body: IncidenceMap(this._mapController, this._locationManager, this._apiService),
      floatingActionButton: getFloatingActionButtonRow(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}