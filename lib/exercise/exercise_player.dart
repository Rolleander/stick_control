import 'package:stick_control/exercise/exercise.dart';
import 'package:stick_control/exercise/sample_player.dart';
import 'package:stick_control/exercise/sleeper.dart';

class ExercisePlayer {
  final _sleeper = Sleeper();
  final _stopwatch = Stopwatch();
  late Exercise exercise;
  late Note _lastNote;
  var _stop = false;
  var playing = false;
  var bpm = 100;
  var length = 0.0;
  var _progress = 0.0;
  var _currentSleepTarget = 0.0;
  var _targetDuration = 0.0;
  var lastNoteIndex = -1;
  final _samples = SamplePlayer();

  init(Exercise e) {
    exercise = e;
    length = e.length;
    _lastNote = e.notes.last;
  }

  Future<void> load() async {
    await _sleeper.init();
    await _samples.load();
  }

  play() async {
    if (playing) {
      return;
    }
    playing = true;
    _stop = false;
    _stopwatch.start();
    _stopwatch.reset();
    _targetDuration = 0;
    _progress = 0;
    var noteCount = exercise.notes.length;
    do {
      for (var i = 0; i < noteCount; i++) {
        var note = exercise.notes[i];
        var next = exercise.notes[i >= noteCount - 1 ? 0 : i + 1];
        await _progressExercise(i, note, next);
        if (_stop) {
          break;
        }
      }
    } while (!_stop);
    _stopwatch.stop();
  }

  _progressExercise(int index, Note note, Note next) async {
    var lengthFactor = 1.0;
    if (index == 0) {
      //inital sleep for half of last note
      await _sleepForNote(_lastNote, 0.5);
    } else if (note == _lastNote) {
      //sleep only for half duration
      lengthFactor = 0.5;
    }
    lastNoteIndex = index;
    await _playNote(note, lengthFactor);
  }

  _playNote(Note note, double lengthFactor) async {
    if (note.type.asset.isNotEmpty) {
      _samples.play(note.type);
    }
    await _sleepForNote(note, lengthFactor);
  }

  _sleepForNote(Note note, double lengthFactor) async {
    var delay = exercise.calcNoteLength(note, bpm) * lengthFactor;
    var length = note.calcLength(lengthFactor);
    await _sleepAndProgress(delay, length);
  }

  _sleepAndProgress(double delay, double progressLength) async {
    _currentSleepTarget = progressLength;
    var fixedDelay = delay;
    if (_targetDuration > 0) {
      var fix = _targetDuration - _stopwatch.elapsedMilliseconds;
      fixedDelay += fix;
    }
    _targetDuration += delay;
    await _sleeper.sleepFor(fixedDelay);
    if (!_stop) {
      _progress += progressLength;
      if (_progress >= length) {
        _progress -= length;
      }
    }
  }

  double getNoteProgress() {
    var l = (_progress + _sleeper.getProgress() * _currentSleepTarget);
    if (l == 0) {
      return l;
    }
    return l % length;
  }

  void stop() {
    lastNoteIndex = -1;
    playing = false;
    _currentSleepTarget = 0;
    _stop = true;
    _stopwatch.stop();
    _progress = 0;
    _targetDuration = 0;
    _sleeper.stop();
  }
}
