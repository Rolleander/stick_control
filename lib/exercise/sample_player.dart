import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

import 'exercise.dart';

class SamplePlayer {
  final _soundIds = <NoteType, int>{};
  Soundpool? _pool;

  Future<void> load() async {
    if (kIsWeb) {
      _pool = Soundpool.fromOptions(
          options: const SoundpoolOptions(
              maxStreams: 10, streamType: StreamType.ring));
    } else {}
    /* _ogg = FlutterOggPiano();
      await _ogg!.init();*/
    if (kIsWeb) {
      var count = 0;
      for (var noteType in NoteType.values) {
        if (noteType.asset.isNotEmpty) {
          _soundIds[noteType] = await rootBundle
              .load("assets/samples/${noteType.asset}.ogg")
              .then((ByteData soundData) {
            return _pool!.load(soundData);
          });
        }
      }
    }
  }

  /*  count++;
            return _ogg!
                .load(
                    src: soundData, name: "${noteType.asset}.ogg", index: count)
                .then((value) => count);
          }*/

  play(NoteType type) {
    if (_pool != null) {
      _pool!.play(_soundIds[type]!);
    } else {}
  }
}
