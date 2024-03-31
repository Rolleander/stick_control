import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:stick_control/exercise/oboe_player.dart';

import 'exercise.dart';

class SamplePlayer {
  final _soundIds = <NoteType, int>{};
  OboePlayer? _oboe;
  Soundpool? _pool;

  Future<void> load() async {
    if (!kIsWeb && Platform.isAndroid) {
      _oboe = OboePlayer();
      await _oboe!.init();
    } else {
      _pool = Soundpool.fromOptions(
          options: const SoundpoolOptions(
              maxStreams: 10, streamType: StreamType.ring));
    }
    for (var noteType in NoteType.values) {
      if (noteType.asset.isNotEmpty) {
        _soundIds[noteType] = await rootBundle
            .load("assets/samples/${noteType.asset}.ogg")
            .then((ByteData soundData) {
          if (_pool != null) {
            return _pool!.load(soundData);
          } else {
            return _oboe!.load(soundData, noteType.asset);
          }
        });
      }
    }
  }

  play(NoteType type) {
    if (_pool != null) {
      _pool!.play(_soundIds[type]!);
    } else {
      _oboe!.play(_soundIds[type]!);
    }
  }
}
