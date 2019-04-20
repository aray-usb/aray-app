/// Módulo para el desarrollo del listado de incidencias

import 'package:flutter/material.dart';

/// Lista de incidencias en curso, a modo de tarjetas
class IncidenceList extends StatelessWidget {

  // Cantidad de tarjetas a poner. Para calcular cantidad de divisiones
  // al generar la lista de tarjetas.
  final int _cardAmount = 10;

  // TODO: Cargar incidencias desde la API
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 2*_cardAmount - 1,
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        return Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.power),
                  title: Text('Apagón Nacional'),
                  subtitle: Text('Estatus: En curso.\nApagón confirmado en 20 estados.'),
                ),
                ButtonTheme.bar( // make buttons use the appropriate styles for cards
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('VER DETALLES'),
                        onPressed: () { /* ... */ },
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
}


