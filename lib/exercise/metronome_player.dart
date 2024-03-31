import 'package:stick_control/exercise/base_player.dart';

import 'exercise.dart';

class MetronomePlayer extends BasePlayer {
  var clicks = 0;
  var clickLength = 0.0;

  @override
  init(Exercise e) {
    super.init(e);
    clickLength = e.timeSignature.length / e.timeSignature.note;
    clicks = length ~/ clickLength;
  }

  @override
  Future<void> playLoop() async {
    for (var i = 0; i < clicks; i++) {
      if (i == 0) {
        //initial sleep for half of last note
        await sleepForNote(lastNote, 0.5);
      }
      if (!muted) {
        var type = i % exercise.timeSignature.count == 0
            ? NoteType.clickAccent
            : NoteType.click;
        samples.play(type);
      }
      var sleepTime = exercise.timeSignature.calcNoteDuration(bpm) * 4;
      if (i == clicks - 1) {
        //reduce by half of last note
        sleepTime -= exercise.calcNoteLength(lastNote, bpm) * 0.5;
      }
      await sleepAndProgress(sleepTime, clickLength);
      if (stopping) {
        break;
      }
    }
  }
}
