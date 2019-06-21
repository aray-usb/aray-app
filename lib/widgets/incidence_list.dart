/// Módulo para el desarrollo del listado de incidencias

import 'package:flutter/material.dart';
import 'package:aray/models/incidencia.dart';
import 'package:aray/services/api.dart';
import 'package:aray/styles/colors.dart';
import 'package:aray/widgets/incidence_detail.dart';

/// Lista de incidencias en curso, a modo de tarjetas
class IncidenceList extends StatefulWidget {

  /// Servicio de la API
  final APIService apiService;

  IncidenceList(this.apiService);

  @override
  _IncidenceListState createState() => _IncidenceListState(this.apiService);
}

class _IncidenceListState extends State<IncidenceList> {
  /// Lista de incidencias obtenidas de la API
  List<Incidencia> incidencias = <Incidencia>[];

  /// Servicio de la API
  final APIService apiService;

  /// Para conocer si las incidencias ya fueron cargadas
  bool incidenciasCargadas = false;

  _IncidenceListState(this.apiService);

  @override
  void initState() {
    super.initState();
    fetchIncidencias();
  }

  /// Carga desde la API la lista de incidencias y actualiza el estado
  /// del widget
  fetchIncidencias() async {
    this.incidencias = await this.apiService.getIncidencias();

    setState(() {
      this.incidenciasCargadas = true;
    });
  }

  /// Determina qué incidencias están en curso
  List<Incidencia> getIncidenciasEnCurso() =>
    this.incidencias
      .where((incidencia) => !incidencia.perteneceAHistorico)
      .toList();

  /// Determina qué incidencias pertenecen al histórico
  List<Incidencia> getIncidenciasHistoricas() =>
    this.incidencias
      .where((incidencia) => incidencia.perteneceAHistorico)
      .toList();

  /// Dada una lista de incidencias, construye una vista con las mismas
  Widget buildTab(incidencias) {

    // Si no hay incidencias se muestra un mensaje apropiado
    if (incidencias.length == 0) {
      return Center(
        child: Text("No hay incidencias de este tipo.")
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 2*incidencias.length - 1,
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final int index = i % 2;
        final Incidencia incidencia = incidencias[index];

        return Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                incidencia.tile,
                ButtonTheme.bar(
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('VER DETALLES'),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => IncidenceDetail(incidencia),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Construye la pestaña de incidencias en curso
  Widget tabIncidenciasEnCurso() =>
    this.buildTab(this.getIncidenciasEnCurso());

  /// Construye la pestaña de incidencias históricas
  Widget tabIncidenciasHistoricas() =>
    this.buildTab(this.getIncidenciasHistoricas());

  @override
  Widget build(BuildContext context) {

    // Se muestra un splash si las incidencias no han sido cargadas aún
    if (!this.incidenciasCargadas) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                ArayColors.primary,
              ),
            ),
            Text('Cargando incidencias...')
          ],
        ),
      );
    }

    // Si no hay ninguna incidencia, se muestra un mensaje apropiado
    if (this.incidencias.length == 0) {
      return Center(
        child: Text("Aún no hay incidencias registradas. :-(")
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: ArayColors.primary,
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list)),
              Tab(icon: Icon(Icons.history)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            this.tabIncidenciasEnCurso(),
            this.tabIncidenciasHistoricas(),
          ]
        )
      )
    );
  }
}
