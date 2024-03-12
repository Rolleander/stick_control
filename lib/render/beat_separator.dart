import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class BeatSeparator extends Node {
  Paint p = Paint();
  static const black = Color.fromARGB(50, 100, 100, 200);

  BeatSeparator(this.length) {
    p.style = PaintingStyle.fill;
    p.color = black;
  }

  double length;

  @override
  void paint(Canvas canvas) {
    const root = Offset(-50, -180);
    canvas.drawRect(Rect.fromPoints(root, root.translate(length + 1, 380)), p);
  }
}
