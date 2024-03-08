import 'dart:ui';

import 'package:spritewidget/spritewidget.dart';
import 'package:stick_control/exercise/exercise.dart';
import 'package:stick_control/exercise/time_signature.dart';
import 'package:stick_control/render/note_bar.dart';
import 'package:stick_control/render/textures.dart';

class NoteRender extends NodeWithSize {
  NoteRender() : super(const Size(1000, 500));

  late TimeSignature timeSignature;
  var connect = false;
  var endConnect = false;
  var sameCount = 0;
  var y = 400.0;

  Textures textures = Textures();
  static const space = 50.0;

  Future<void> load() async {
    await textures.load();
  }

  void init(Exercise e) {
    timeSignature = e.timeSignature;
    removeAllChildren();
    var x = 0.0;
    for (var i = 0; i < e.notes.length; i++) {
      var note = e.notes[i];
      var next = i < e.notes.length - 1 ? e.notes[i + 1] : null;
      var sprite = _getImage(note, next);
      var noteSpace = note.calcLength(space);
      if (endConnect && sameCount > 0) {
        connectLastNotes(x, note, noteSpace);
        sameCount = 0;
      }
      sprite.position = Offset(x, y);
      x += noteSpace;
      addChild(sprite);
    }
  }

  void connectLastNotes(double x, Note note, double noteSpace) {
    var w = (sameCount - 1) * noteSpace;
    var noteBar = NoteBar(w, note.count > 2 ? note.count.toString() : null);
    noteBar.position = Offset(x - w, y);
    addChild(noteBar);
  }

  _getImage(Note note, Note? next) {
    var img = "note_";
    switch (note.value) {
      case 1:
        img += "whole";
      case 2:
        img += "half";
      case 4:
        img += "quarter";
      case 8:
        img += "8th";
      case 16:
        img += "16th";
      case 30:
        img += "32th";
    }
    var maxConnect = note.count > 2 ? note.count : note.value / 2;
    if (note.value > 4 && next?.value == note.value && sameCount < maxConnect) {
      img = "note_quarter";
      connect = true;
      sameCount++;
    } else {
      if (connect) {
        img = "note_quarter";
        sameCount++;
      }
      connect = false;
    }
    endConnect = sameCount >= maxConnect;
    return Sprite.fromImage(
        textures.images.getImage("assets/sprites/${img}.png")!);
  }

  @override
  void paint(Canvas canvas) {
    canvas.scale(0.4, 0.4);
    super.paint(canvas);
  }
}
