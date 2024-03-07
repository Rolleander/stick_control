import 'package:stick_control/exercise/base_player.dart';
import 'package:stick_control/exercise/exercise.dart';
import 'package:tuple/tuple.dart';


class ClickPlayer extends BasePlayer {
  final Exercise _exercise;
  var _current = 0;
  ClickPlayer(this._exercise);

  @override
  Tuple2<NoteType, double> nextNote() {
    var type = NoteType.click;
    if(_current == 0){
      type = NoteType.clickAccent;
    }
    _current ++;
    if(_current >= _exercise.timeSignature.count){
      _current =0;
    }
    return Tuple2(type, calcNoteDuration());
  }

  double calcNoteDuration(){
    var delay= _exercise.timeSignature.calcNoteDuration(bpm);
    return delay / 4;
  }
  
}
