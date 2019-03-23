import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:aray/widgets/aray_drawer.dart';
class MainMap extends StatelessWidget {

  static final mark = Icon(
    Icons.location_on,
    size: 56,
    color: Colors.red,
  );

  static final mymark = Icon(
    Icons.my_location,
    size: 56,
    color: Color(0xFF1DC7EA),
  );


  final markers = <Marker>[
    new Marker(
      width: 80.0,
      height: 80.0,
      point: new LatLng(10.409153, -66.883417),
      builder: (ctx) => new Container(
            child: mymark,
          ),
    ),
    new Marker(
      width: 80.0,
      height: 80.0,
      point: new LatLng(10.411992, -66.881605),
      builder: (ctx) => new Container(
            child: mark,
          ),
    ),
    new Marker(
      width: 80.0,
      height: 80.0,
      point: new LatLng(10.410161, -66.882549),
      builder: (ctx) => new Container(
            child: mark,
          ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return new FlutterMap(
      options: new MapOptions(
        center: new LatLng(10.409153, -66.883417),
        zoom: 5.0,
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

class HomePage extends StatelessWidget {

  final String title;

  HomePage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      drawer: ArayDrawer(),
      body: MainMap(),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.flare),
        onPressed: () {

        },
        label: Text("Solicitar Ayuda"),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}