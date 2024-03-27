import 'package:flutter/cupertino.dart';

import '../exercise/exercise_library.dart';
import '../exercise/exercise_player.dart';
import '../render/textures.dart';

class AppData {
  final ExerciseLibrary library = ExerciseLibrary();
  final Textures textures = Textures();
  final ExercisePlayer player = ExercisePlayer();
  final ValueNotifier<double> bpm = ValueNotifier(100.0);

  Future<void> load() async {
    await Future.wait([library.load(), textures.load(), player.load()]);
  }
}
