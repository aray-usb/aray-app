/// Módulo para el desarrollo del listado de tareas

import 'package:flutter/material.dart';
import 'package:aray/models/tarea.dart';
import 'package:aray/widgets/tarea_form.dart';
import 'package:aray/services/api.dart';
import 'package:aray/styles/colors.dart';
import 'package:aray/widgets/task_detail.dart';

/// Lista de tareas en curso, a modo de tarjetas
class TaskList extends StatefulWidget {

  /// Servicio de la API
  final APIService apiService;

  TaskList(this.apiService);

  @override
  _TaskListState createState() => _TaskListState(this.apiService);
}

class _TaskListState extends State<TaskList> {
  /// Lista de incidencias obtenidas de la API
  List<Tarea> tareas = <Tarea>[];

  /// Servicio de la API
  final APIService apiService;

  /// Para conocer si las incidencias ya fueron cargadas
  bool tareasCargadas = false;

  _TaskListState(this.apiService);

  @override
  void initState() {
    super.initState();
    fetchTareas();
  }

  /// Carga desde la API la lista de tareas y actualiza el estado
  /// del widget
  fetchTareas() async {
    this.tareas = await this.apiService.getTareas();

    setState(() {
      this.tareasCargadas = true;
    });
  }

  /// Determina qué tareas están en curso
  List<Tarea> getTareasEnCurso() =>
    this.tareas
      .where((incidencia) => !incidencia.perteneceAHistorico)
      .toList();

  /// Determina qué tareas pertenecen al histórico
  List<Tarea> getTareasHistoricas() =>
    this.tareas
      .where((incidencia) => incidencia.perteneceAHistorico)
      .toList();

  /// Retorna los botones a mostrar en la lista de tareas
  List<Widget> getBotones(Tarea tarea) {
    List<Widget> lista = <Widget>[];

    if (tarea.estado == Tarea.ESTADO_NUEVA) {
      lista.add(
        FlatButton(
          child: const Text('EN PROGRESO'),
          onPressed: () async {
            await apiService.updateTask(tarea.id, Tarea.ESTADO_EN_PROGRESO);
            setState(() {
              this.tareasCargadas = false;
            });
            await fetchTareas();
          },
        ),
      );
    }

    if (tarea.estado != Tarea.ESTADO_RESUELTA) {
      lista.add(
        FlatButton(
          child: const Text('CULMINAR'),
          onPressed: () async {
            await apiService.updateTask(tarea.id, Tarea.ESTADO_RESUELTA);
            setState(() {
              this.tareasCargadas = false;
            });
            await fetchTareas();
          },
        )
      );
    }

    lista.add(
      FlatButton(
        child: const Text('DETALLES'),
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => TaskDetail(tarea, apiService),
        ),
      )
    );

    return lista;
  }

  /// Dada una lista de tareas, construye una vista con las mismas
  Widget buildTab(tareas) {

    // Si no hay tareas se muestra un mensaje apropiado
    if (tareas.length == 0) {
      return Center(
        child: Text("No hay tareas de este tipo.")
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 2*tareas.length - 1,
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final int index = i % 2;
        final Tarea tarea = tareas[index];

        return Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                tarea.tile,
                ButtonTheme.bar(
                  child: ButtonBar(
                    children: getBotones(tarea),
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
  Widget tabTareasEnCurso() =>
    this.buildTab(this.getTareasEnCurso());

  /// Construye la pestaña de incidencias históricas
  Widget tabTareasHistoricas() =>
    this.buildTab(this.getTareasHistoricas());

  @override
  Widget build(BuildContext context) {

    // Se muestra un splash si las incidencias no han sido cargadas aún
    if (!this.tareasCargadas) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                ArayColors.primary,
              ),
            ),
            Text('Cargando tareas...')
          ],
        ),
      );
    }

    // Si no hay ninguna incidencia, se muestra un mensaje apropiado
    if (this.tareas.length == 0) {
      return Center(
        child: Text("Aún no hay tareas registradas. :-(")
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
            this.tabTareasEnCurso(),
            this.tabTareasHistoricas(),
          ]
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () async {
                setState(() {
                  this.tareasCargadas = false;
                });

                await fetchTareas();
              },
              child: Icon(Icons.update),
              backgroundColor: ArayColors.primary,
            ),
            FloatingActionButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => TareaForm(apiService),
              ),
              child: Icon(Icons.add),
              backgroundColor: ArayColors.primary,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      )
    );
  }
}