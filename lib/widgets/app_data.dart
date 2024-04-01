import 'package:flutter/cupertino.dart';
import 'package:stick_control/exercise/exercise.dart';
import 'package:stick_control/player/metronome_player.dart';
import 'package:stick_control/player/sample_player.dart';
import 'package:stick_control/storage/storage.dart';

import '../exercise/exercise_library.dart';
import '../player/exercise_player.dart';
import '../render/textures.dart';

class AppData {
  final ExerciseLibrary library = ExerciseLibrary();
  final Textures textures = Textures();
  final SamplePlayer samplePlayer = SamplePlayer();
  final ExercisePlayer player = ExercisePlayer();
  final MetronomePlayer metronome = MetronomePlayer();
  final ValueNotifier<double> bpm = ValueNotifier(100.0);

  Future<void> load() async {
    await Future.wait([
      storage.init(),
      library.load(),
      textures.load(),
      samplePlayer.load(),
      player.sleeper.init(),
      metronome.sleeper.init()
    ]);
    player.samples = samplePlayer;
    metronome.samples = samplePlayer;
    bpm.addListener(() {
      var newBpm = bpm.value.round();
      player.changeBpm(newBpm);
      metronome.changeBpm(newBpm);
    });
  }

  playerStart() {
    player.play();
    metronome.play();
  }

  playerStop() {
    player.stop();
    metronome.stop();
  }

  void initExercise(Exercise exercise) {
    player.init(exercise);
    metronome.init(exercise);
  }
}
