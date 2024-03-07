import 'package:audioplayers/audioplayers.dart';
import 'package:soundpool/soundpool.dart';

class SamplePlayer {
  static const count = 10;
  var _current = 0;
  final List<AudioPlayer> _players = [];
  final _pool =
      Soundpool.fromOptions(options: const SoundpoolOptions(maxStreams: 10));

  init(String asset) async {
    for (var i = 0; i < count; i++) {
      var player = AudioPlayer();
      player.setSourceAsset("samples/$asset");
      player.setReleaseMode(ReleaseMode.stop);
      player.setPlayerMode(PlayerMode.lowLatency);
      _players.add(player);
    }
  }

  play() {
    _players[_current].stop();
    _players[_current].resume();
    _current++;
    if (_current >= count) {
      _current = 0;
    }
  }
}
