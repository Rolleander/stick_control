import 'dart:ui';

import 'package:spritewidget/spritewidget.dart';
import 'package:stick_control/exercise/exercise.dart';
import 'package:stick_control/exercise/exercise_player.dart';
import 'package:stick_control/exercise/time_signature.dart';
import 'package:stick_control/render/grouping_bar.dart';
import 'package:stick_control/render/note_bar.dart';
import 'package:stick_control/render/play_cursor.dart';
import 'package:stick_control/render/textures.dart';

class ExerciseRender extends NodeWithSize {
  ExerciseRender(this.player) : super(const Size(1000, 500));

  late TimeSignature timeSignature;
  ExercisePlayer player;
  Exercise? exercise;
  List<Sprite> notes = [];
  Sprite? lastPop;
  var connect = false;
  var endConnect = false;
  var sameCount = 0;
  var oddGroupingLength = 0.0;
  var y = 400.0;
  var length = 0.0;
  var cursor = PlayCursor();

  Textures textures = Textures();
  static const space = 50.0;

  Future<void> load() async {
    await textures.load();
  }

  void init(Exercise e) {
    notes.clear();
    exercise = e;
    length = e.length * space;
    timeSignature = e.timeSignature;
    removeAllChildren();
    cursor.position = Offset(0, y);
    addChild(cursor);
    var x = 0.0;
    for (var i = 0; i < e.notes.length; i++) {
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
        addChild(accent);
      }
      sprite.position = Offset(x, y);
      x += noteSpace;
      addChild(sprite);
      notes.add(sprite);
    }
  }

  void connectLastNotes(double x, Note note, double noteSpace) {
    var w = (sameCount - 1) * noteSpace;
    var noteBar = NoteBar(w, note.odd() ? note.count.toString() : null);
    noteBar.position = Offset(x - w, y);
    addChild(noteBar);
  }

  void connectOddGroup(double x, String title) {
    var oddGroup = GroupingBar(oddGroupingLength, title);
    oddGroup.position = Offset(x - oddGroupingLength, y);
    addChild(oddGroup);
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

  @override
  void paint(Canvas canvas) {
    canvas.scale(0.4, 0.4);
    cursor.position =
        Offset(length * player.getProgress() - 40, cursor.position.dy);
    if (exercise != null) {
      checkNotePop();
    }
    super.paint(canvas);
  }

  checkNotePop() {
    if (!player.playing || player.lastNoteIndex < 0) {
      lastPop = null;
      return;
    }
    var lastNote = notes[player.lastNoteIndex];
    if (lastPop != lastNote) {
      lastPop = lastNote;
      print("pops!");
      lastNote.motions.run(MotionTween<double>(
          setter: (a) => lastNote.scale = a,
          start: 1.5,
          end: 1,
          duration: 0.2));
    }
  }
}
