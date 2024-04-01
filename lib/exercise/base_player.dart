import 'package:stick_control/exercise/sample_player.dart';
import 'package:stick_control/exercise/sleeper.dart';

import 'exercise.dart';

abstract class BasePlayer {
  final _stopwatch = Stopwatch();
  final sleeper = Sleeper();
  late SamplePlayer samples;
  late Exercise exercise;
  late Note lastNote;
  var length = 0.0;
  var playing = false;
  var muted = false;
  var bpm = 100;
  var stopping = false;
  var _targetDuration = 0.0;
  var _progress = 0.0;
  var _currentSleepTarget = 0.0;

  init(Exercise e) {
    exercise = e;
    length = e.length;
    lastNote = e.notes.last;
  }

  void play() async {
    if (playing) {
      return;
    }
    _progress = 0;
    playing = true;
    stopping = false;
    _stopwatch.start();
    _stopwatch.reset();
    _targetDuration = 0;
    do {
      await playLoop();
    } while (!stopping);
    _stopwatch.stop();
  }

  void changeBpm(int newBpm) {
    var prevBpm = bpm;
    bpm = newBpm;
    var speedup = newBpm / prevBpm;
    _targetDuration -= sleeper.sleepDuration;
    _targetDuration += sleeper.slept() + sleeper.remaining() / speedup;
  }

  Future<void> playLoop();

  void stop() {
    playing = false;
    sleeper.stop();
    playing = false;
    stopping = true;
    _currentSleepTarget = 0;
    _progress = 0;
    _stopwatch.stop();
  }

  _sleep(double delay) async {
    var fixedDelay = delay;
    if (_targetDuration > 0) {
      var fix = _targetDuration - _stopwatch.elapsedMilliseconds;
      fixedDelay += fix;
    }
    _targetDuration += delay;
    await sleeper.sleepFor(fixedDelay);
  }

  sleepAndProgress(double delay, double progressLength) async {
    _currentSleepTarget = progressLength;
    await _sleep(delay);
    if (!stopping) {
      _progress += progressLength;
      if (_progress >= length) {
        _progress -= length;
      }
    }
  }

  sleepForNote(Note note, double lengthFactor) async {
    var delay = exercise.calcNoteLength(note, bpm) * lengthFactor;
    var length = note.calcLength(lengthFactor);
    await sleepAndProgress(delay, length);
  }

  double getNoteProgress() {
    var l = (_progress + sleeper.getProgress() * _currentSleepTarget);
    if (l == 0) {
      return l;
    }
    return l % length;
  }
}
