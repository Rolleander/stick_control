import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class NoteBar extends Node {
  Paint p = Paint();
  static const black = Color.fromARGB(255, 0, 0, 0);

  NoteBar(this.length, this.text) {
    p.style = PaintingStyle.fill;
    p.color = black;
  }

  double length;
  String? text;

  @override
  void paint(Canvas canvas) {
    const root = Offset(4, -56);
    canvas.drawRect(Rect.fromPoints(root, root.translate(length + 4, 5)), p);

    if (text == null) {
      return;
    }
    var span =
        TextSpan(text: text, style: TextStyle(color: black, fontSize: 40));
    var painter = TextPainter(text: span, textDirection: TextDirection.ltr);
    painter.layout();
    painter.paint(canvas, Offset(length / 2 - 5, -100));
  }
}
