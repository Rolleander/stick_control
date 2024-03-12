class TimeSignature {
  static const secondsPerMinute = 60;
  static const millisPerSecond = 1000;
  late int count;
  late int note;
  late double length;

  TimeSignature(String signature) {
    final splitted = signature.split('/');
    count = int.parse(splitted[0]);
    note = int.parse(splitted[1]);
    length = count * 16 * (1.0 / note);
  }

  double calcNoteDuration(int bpm) {
    final beatsPerSecond = bpm / secondsPerMinute;
    final beatDuration = millisPerSecond / beatsPerSecond;
    return beatDuration / note;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSignature &&
          runtimeType == other.runtimeType &&
          count == other.count &&
          note == other.note;

  @override
  int get hashCode => count.hashCode ^ note.hashCode;
}
