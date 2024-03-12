import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:stick_control/exercise/exercise.dart';
import 'package:stick_control/exercise/exercise_player.dart';
import 'package:stick_control/render/beat_render.dart';
import 'package:stick_control/render/play_cursor.dart';
import 'package:stick_control/render/textures.dart';

const space = 60.0;

class ExerciseRender extends NodeWithSize {
  ExerciseRender(this.player) : super(const Size(500, 300));

  ExercisePlayer player;
  Exercise? exercise;
  List<Sprite> notes = [];
  Sprite? lastPop;
  late BuildContext context;
  var connect = false;
  var endConnect = false;
  var sameCount = 0;
  var oddGroupingLength = 0.0;
  var y;
  var wrapHeight = 400.0;
  var startX = 0.0;
  var startY = 50.0;
  var maxWidth = 1.0;
  var length = 0.0;
  var zoom = 1.5;
  var cursor = PlayCursor();
  var resize = false;

  Textures textures = Textures();

  Future<void> load() async {
    await textures.load();
  }

  void init(Exercise e) {
    y = startY;
    notes.clear();
    exercise = e;
    length = e.length * space;
    removeAllChildren();
    cursor.position = Offset(startX, y);
    addChild(cursor);
    var screenSize = MediaQuery.of(context).size;
    var ratio = screenSize.aspectRatio;
    var beatLength = e.timeSignature.length * space;
    var maxBeats = max(1, ratio * 1.5).toInt();
    maxWidth = min(maxBeats * beatLength, length);
    print("max width $maxWidth  $length");
    var x = startX;
    var noteIndex = 0;
    var rows = 1;
    do {
      var render = BeatRender(x, y, e, textures);
      var notes = render.render(noteIndex);
      this.notes.addAll(notes);
      noteIndex += notes.length;
      for (var node in render.nodes) {
        addChild(node);
      }
      x += beatLength;
      if (x >= maxWidth) {
        x = startX;
        y += wrapHeight;
        rows++;
      }
    } while (noteIndex < e.notes.length - 1);
    this.size = Size(maxWidth - 100, screenSize.height - 200);
    this.spriteBox!.markNeedsLayout();
  }

  @override
  void paint(Canvas canvas) {
    //canvas.scale(zoom, zoom);
    if (maxWidth > 0) {
      updateCursor();
    }
    if (exercise != null) {
      checkNotePop();
    }
    super.paint(canvas);
  }

  updateCursor() {
    var y = startY;
    var x = startX - 40.0;
    var l = player.getNoteProgress() * space;
    var d = l % maxWidth;
    x += d;
    y += (l ~/ maxWidth) * wrapHeight;
    cursor.position = Offset(x, y);
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
