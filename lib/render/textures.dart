import 'package:spritewidget/spritewidget.dart';

class Textures {
  final ImageMap images = ImageMap();
  static const path = "assets/sprites/";

  load() async {
    await images.load([
      "note_whole",
      "note_half",
      "note_quarter",
      "note_8th",
      "note_16th",
      "note_32th",
      "pause_whole",
      "pause_half",
      "pause_quarter",
      "pause_8th",
      "pause_16th",
      "pause_32th",
    ].map((e) => "assets/sprites/$e.png").toList());
  }
}
