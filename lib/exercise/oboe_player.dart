import 'package:flutter/services.dart';

class OboePlayer {
  static const channel = MethodChannel("com.brol.stickcontrol/oboe");

  play() async {
    channel.invokeMethod("play", "test");
  }
}
