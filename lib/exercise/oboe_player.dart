import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class OboePlayer {
  static const channel = MethodChannel("com.brol.stickcontrol/oboe");

  init() async {
    channel.invokeMethod("init");
  }

  Future<int> load(ByteData src, String name) async {
    File? f = await (writeToFile(src, name: name, replace: true));
    var index = await channel.invokeMethod<int>("load", {'path': f!.path});
    return index!;
  }

  play(int id) async {
    channel.invokeMethod("play", {'id': id});
  }
}

Future<File?> writeToFile(ByteData data,
    {required String name, bool replace = false}) async {
  if (kIsWeb) return null;

  final buff = data.buffer;
  final d = await getApplicationDocumentsDirectory();

  if (!name.endsWith(".ogg")) {
    name = name + ".ogg";
  }

  Directory g = Directory("${d.path}/temp/");

  bool ge = await g.exists();

  if (!ge) {
    await g.create().then((d) {
      print("Directory created : " + d.path);
    });
  }

  final p = "${d.path}/temp/$name";

  File f = File(p);

  bool e = await f.exists();

  if (e) {
    if (replace) {
      return f.writeAsBytes(
          buff.asUint8List(data.offsetInBytes, data.lengthInBytes));
    } else {
      return f;
    }
  } else {
    return f
        .writeAsBytes(buff.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
