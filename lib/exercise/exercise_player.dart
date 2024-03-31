import 'package:stick_control/exercise/base_player.dart';
import 'package:stick_control/exercise/exercise.dart';

class ExercisePlayer extends BasePlayer {
  var lastNoteIndex = -1;

  @override
  playLoop() async {
    var noteCount = exercise.notes.length;
    for (var i = 0; i < noteCount; i++) {
      var note = exercise.notes[i];
      var next = exercise.notes[i >= noteCount - 1 ? 0 : i + 1];
      await _progressExercise(i, note, next);
      if (stopping) {
        break;
      }
    }
  }

  _progressExercise(int index, Note note, Note next) async {
    var lengthFactor = 1.0;
    if (index == 0) {
      //initial sleep for half of last note
      await sleepForNote(lastNote, 0.5);
    } else if (note == lastNote) {
      //sleep only for half duration
      lengthFactor = 0.5;
    }
    lastNoteIndex = index;
    await _playNote(note, lengthFactor);
  }

  _playNote(Note note, double lengthFactor) async {
    if (note.type.asset.isNotEmpty && !muted) {
      samples.play(note.type);
    }
    await sleepForNote(note, lengthFactor);
  }

  @override
  void stop() {
    super.stop();
    lastNoteIndex = -1;
  }
}
