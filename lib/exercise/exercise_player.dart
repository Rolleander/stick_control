import 'package:stick_control/exercise/base_player.dart';
import 'package:stick_control/exercise/exercise.dart';
import 'package:tuple/tuple.dart';

class ExercisePlayer extends BasePlayer {
  final Exercise _exercise;
  var _current = 0;

  ExercisePlayer(this._exercise);

  @override
  Tuple2<NoteType, double> nextNote() {
    var note = _exercise.notes[_current];
    _current++;
    if (_current >= _exercise.notes.length) {
      _current = 0;
    }
    return Tuple2(note.type, calcNoteDuration(note));
  }

  double calcNoteDuration(Note note) {
    var delay = _exercise.timeSignature.calcNoteDuration(bpm);
    return note.calcLength(delay);
  }
}
