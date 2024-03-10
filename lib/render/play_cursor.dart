import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class PlayCursor extends Node {
  Paint p = Paint();
  static const black = Color.fromARGB(200, 100, 100, 255);

  PlayCursor() {
    p.style = PaintingStyle.fill;
    p.color = black;
  }

  @override
  void paint(Canvas canvas) {
    const root = Offset(-15, -90);
    canvas.drawRect(Rect.fromPoints(root, root.translate(10, 210)), p);
  }
}
