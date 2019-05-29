/// Módulo para el desarrollo de un widget indicador de pestañas
/// para uso en el login.

import 'dart:math';
import 'package:flutter/material.dart';

/// Painter para un indicador de pestañas.
class TabIndicationPainter extends CustomPainter {
  Paint painter;

  // Valor objetivo de la animación (horizontal)
  final double dxTarget;

  // Valor inicial de la animación (horizontal)
  final double dxEntry;

  // Valor fijo en vertical del widget
  final double dy;

  // Radio de las pestañas
  final double radius;

  // Manejador del estado de la página, a mostrar/ocultar según la
  // interacción con el widget que esté modificando el painter
  final PageController pageController;

  TabIndicationPainter({
    this.dxTarget = 125.0,
    this.dxEntry = 25.0,
    this.radius = 21.0,
    this.dy = 25.0,
    this.pageController
  }) : super(repaint: pageController) {
    painter = Paint()
      ..color = Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Obtenemos la posición del controller
    final pos = pageController.position;

    // Calculamos el ancho completo de scroll
    double fullExtent = (pos.maxScrollExtent - pos.minScrollExtent + pos.viewportDimension);

    // Calculamos el offset
    double pageOffset = pos.extentBefore / fullExtent;

    // Verificamos si la animación ocurrirá de izquierda a derecha o viceversa
    bool left2right = dxEntry < dxTarget;

    // Generamos los offets correspondientes según la dirección de animación
    Offset entry = Offset(left2right? dxEntry : dxTarget, dy);
    Offset target = Offset(left2right? dxTarget : dxEntry, dy);

    // Generamos el camino de la animación
    Path path = new Path();
    path.addArc(
      Rect.fromCircle(
        center: entry,
        radius: radius
      ),
      0.5 * pi,
      1 * pi
    );
    path.addRect(
      Rect.fromLTRB(
        entry.dx,
        dy - radius,
        target.dx,
        dy + radius
      ),
    );
    path.addArc(
      Rect.fromCircle(
        center: target,
        radius: radius
      ),
      1.5 * pi,
      1 * pi
    );

    // Dibujamos las animaciones en el canvas
    canvas.translate(size.width * pageOffset, 0.0);
    canvas.drawShadow(path, Color(0xFFFBAB66), 3.0, true);
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(TabIndicationPainter oldDelegate) => true;
}