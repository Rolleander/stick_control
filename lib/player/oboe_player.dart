import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class OboePlayer {
  static const channel = MethodChannel("com.brol.stickcontrol/oboe");

  init() async {
    channel.invokeMethod("init");
  }

  Future<int> load(ByteData src, String name) async {
    File file = await writeTempFile(src, name);
    var index = await channel.invokeMethod<int>("load", {'path': file.path});
    return index!;
  }

  play(int id) async {
    channel.invokeMethod("play", {'id': id});
  }
}

Future<File> writeTempFile(ByteData data, String name) async {
  final appDir = await getApplicationDocumentsDirectory();
  final tempDir = Directory("${appDir.path}/temp/");
  makeSureDirectoryExists(tempDir);
  final file = File("${tempDir.path}/$name");
  return file.writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

makeSureDirectoryExists(Directory directory) {
  if (!directory.existsSync()) {
    directory.createSync();
  }
}
