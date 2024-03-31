import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';

class Sleeper {
  final _watch = Stopwatch();
  var _duration = 0.0;
  var sleepDuration = 0.0;
  late StreamQueue _queue;
  late SendPort _senderPort;

  Future<void> init() async {
    if (!kIsWeb) {
      var receiverPort = ReceivePort();
      await Isolate.spawn(sleepIsolate, receiverPort.sendPort);
      _queue = StreamQueue(receiverPort.listenAndBuffer());
      _senderPort = await _queue.next;
    }
  }

  Future<void> sleepFor(double duration) async {
    sleepDuration = duration;
    _duration = duration;
    if (_duration <= 0) {
      return;
    }
    _watch.reset();
    _watch.start();
    await _doSleep(duration);
    _watch.stop();
  }

  Future<void> _doSleep(double duration) async {
    if (kIsWeb) {
      await Future.delayed(Duration(milliseconds: duration.round()));
    } else {
      _senderPort.send(duration);
      await _queue.next;
    }
  }

  double remaining() {
    return sleepDuration - (sleepDuration * getProgress());
  }

  stop() {
    _duration = 0;
    _watch.stop();
    _watch.reset();
  }

  double getProgress() {
    if (_duration > 0) {
      return min(1.0, _watch.elapsedMilliseconds.toDouble() / _duration);
    }
    return 0.0;
  }
}

void sleepIsolate(SendPort sendPort) {
  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  var sleepwatch = Stopwatch();
  receivePort.listen((message) {
    double duration = message;
    //sleepwatch.reset();
    //sleepwatch.start();
    var time = duration.round();
    //pre sleep
    sleep(Duration(milliseconds: max(0, time - 5)));
    /* do {
      sleep(const Duration(milliseconds: 1));
    } while (sleepwatch.elapsedMilliseconds < time - 3);*/
    sendPort.send("");
    // sleepwatch.stop();
  });
}
