import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Sleeper {
  final _watch = Stopwatch();
  late Isolate _isolate;
  late StreamQueue _queue;
  late SendPort _senderPort;
  var _duration = 0.0;

  Future<void> init() async {
    if (!kIsWeb) {
      var receiverPort = ReceivePort();
      _isolate = await Isolate.spawn(sleepIsolate, receiverPort.sendPort);
      _queue = StreamQueue(receiverPort.listenAndBuffer());
      _senderPort = await _queue.next;
    }
  }

  Future<void> sleepFor(double duration) async {
    _duration = duration;
    _watch.reset();
    _watch.start();
    if (kIsWeb) {
      await Future.delayed(Duration(milliseconds: duration.round()));
    } else {
      _senderPort.send(duration);
      await _queue.next;
    }
    _watch.stop();
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
    print("sleep in isolate for ${duration.round()}");
    var time = duration.round();
    //pre sleep
    sleep(Duration(milliseconds: time - 5));
    /* do {
      sleep(const Duration(milliseconds: 1));
    } while (sleepwatch.elapsedMilliseconds < time - 3);*/
    sendPort.send("");
    // sleepwatch.stop();
  });
}
