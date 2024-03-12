import 'dart:ui';

import 'package:spritewidget/spritewidget.dart';
import 'package:stick_control/exercise/exercise.dart';
import 'package:stick_control/render/exercise_render.dart';
import 'package:stick_control/render/textures.dart';

import 'beat_separator.dart';
import 'grouping_bar.dart';
import 'note_bar.dart';

class BeatRender {
  BeatRender(this.x, this.y, this.e, this.textures);

  double x;
  double y;
  Exercise e;
  Textures textures;
  List<Node> nodes = [];

  var connect = false;
  var endConnect = false;
  var sameCount = 0;
  var oddGroupingLength = 0.0;

  List<Sprite> render(int start) {
    List<Sprite> notes = [];
    var beatLength = e.timeSignature.length * space;
    var separator = BeatSeparator(beatLength);
    separator.position = Offset(x, y);
    nodes.add(separator);
    var length = 0.0;
    for (var i = start; i < e.notes.length; i++) {
      var note = e.notes[i];
      var next = i < e.notes.length - 1 ? e.notes[i + 1] : null;
      var sprite = _getImage(note, next);
      var noteSpace = note.calcLength(space);
      if (note.odd() && sameCount == 0) {
        if ((next == null ||
                next.count != note.count ||
                oddGroupingLength >= note.calcBaseLength(space)) &&
            oddGroupingLength > 0) {
          connectOddGroup(x, note.count.toString());
          oddGroupingLength = 0;
        } else {
          oddGroupingLength += noteSpace;
        }
      } else {
        oddGroupingLength = 0;
      }
      if (endConnect && sameCount > 0) {
        connectLastNotes(x, note, noteSpace);
        sameCount = 0;
      }
      if (note.type == NoteType.accent) {
        var accent = Sprite.fromImage(
            textures.images.getImage("assets/sprites/accent.png")!);
        accent.position = Offset(x, y - 85);
        accent.scale = 0.7;
        nodes.add(accent);
      }
      sprite.position = Offset(x, y);
      x += noteSpace;
      nodes.add(sprite);
      notes.add(sprite);
      length += noteSpace;
      if (length >= beatLength) {
        break;
      }
    }
    return notes;
  }

  void connectLastNotes(double x, Note note, double noteSpace) {
    var w = (sameCount - 1) * noteSpace;
    var noteBar = NoteBar(w, note.odd() ? note.count.toString() : null);
    noteBar.position = Offset(x - w, y);
    nodes.add(noteBar);
  }

  void connectOddGroup(double x, String title) {
    var oddGroup = GroupingBar(oddGroupingLength, title);
    oddGroup.position = Offset(x - oddGroupingLength, y);
    nodes.add(oddGroup);
  }

  _getImage(Note note, Note? next) {
    var img = "note_";
    if (note.type == NoteType.pause) {
      img = "pause_";
    }
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
    var maxConnect = note.odd() ? note.count : note.value / 2;
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
}
