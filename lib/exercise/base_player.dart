import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:stick_control/exercise/exercise.dart';
import 'package:tuple/tuple.dart';

abstract class BasePlayer {
  final _stopwatch = Stopwatch();
  var _stop = false;
  var _pause = false;
  var bpm = 100;
  final _soundIds = <NoteType, int>{};
  final _pool =
      Soundpool.fromOptions(options: const SoundpoolOptions(maxStreams: 50));

  Future<void> init() async {
    for (var noteType in NoteType.values) {
      if (noteType.asset.isNotEmpty) {
        _soundIds[noteType] = await rootBundle
            .load("assets/samples/${noteType.asset}")
            .then((ByteData soundData) {
          return _pool.load(soundData);
        });
      }
    }
  }

  play() async {
    _stop = false;
    _stopwatch.reset();
    _stopwatch.start();
    var previousDelay = 0.0;
    var duration = Stopwatch();
    duration.start();
    do {
      var next = nextNote();
      var delay = next.item2;
      if (previousDelay != 0) {
        //    delay -= (duration.elapsedMilliseconds - previousDelay);
      }
      duration.reset();
      previousDelay = next.item2;
      if (next.item1.asset.isNotEmpty) {
        _pool.play(_soundIds[next.item1]!);
      }
      //   yield next.item1;
      await Future.delayed(Duration(milliseconds: delay.round()));
      //  sleep(Duration(milliseconds: delay.round()));
      if (_pause) {
        await _waitForResume();
      }
      if (_stop) {
        break;
      }
    } while (!_stop);
    _stopwatch.stop();
  }

  Tuple2<NoteType, double> nextNote();

  Future<void> _waitForResume() async {
    while (!_stop && _pause) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    _stopwatch.start();
  }

  int getElapsedTime() {
    return _stopwatch.elapsedMilliseconds;
  }

  void stop() {
    _stop = true;
  }

  void pause() {
    if (!_stop && !_pause) {
      _stopwatch.stop();
      _pause = true;
    }
  }

  void resume() {
    _pause = false;
  }
}
