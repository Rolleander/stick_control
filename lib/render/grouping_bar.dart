import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class GroupingBar extends Node {
  Paint p = Paint();
  static const black = Color.fromARGB(255, 0, 0, 0);
  static const b = 2.0;

  GroupingBar(this.length, this.text) {
    p.style = PaintingStyle.fill;
    p.color = black;
  }

  double length;
  String? text;

  @override
  void paint(Canvas canvas) {
    const root = Offset(4, -145);
    canvas.drawRect(Rect.fromPoints(root, root.translate(length + 4, b)), p);
    canvas.drawRect(Rect.fromPoints(root, root.translate(b, 30)), p);
    canvas.drawRect(
        Rect.fromPoints(
            root.translate(length + 4 - b, 0), root.translate(length + 4, 30)),
        p);
    var span =
        TextSpan(text: text, style: const TextStyle(color: black, fontSize: 40));
    var painter = TextPainter(text: span, textDirection: TextDirection.ltr);
    painter.layout();
    painter.paint(canvas, Offset(length / 2 + 5, -195));
  }
}
