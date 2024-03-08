import 'dart:convert';

import 'package:stick_control/exercise/time_signature.dart';

class Exercise {
  late String name;
  late TimeSignature timeSignature;
  late List<Note> notes;

  Exercise(String json) {
    Map data = jsonDecode(json);
    name = data['name'];
    timeSignature = TimeSignature(data['time']);
    notes = (data['notes'] as List).map((note) => Note(note)).toList();
  }
}

enum NoteType {
  pause("P", ""),
  accent("A", "rimshot.wav"),
  standard("", "standard.wav"),
  ghost("G", "ghost.wav"),
  roll("R", ""),
  flam("F", ""),
  clickAccent("", "click.wav"),
  click("", "rim.wav");

  const NoteType(this.code, this.asset);

  final String code;
  final String asset;
}

enum Sticking {
  right("R"),
  left("L");

  const Sticking(this.code);

  final String code;
}

class Note {
  late int value;
  late int count = 2;
  late NoteType type = NoteType.standard;
  late Sticking sticking;

  Note(String data) {
    //format-examples:
    // R:1-3:A
    // R:1:A
    // R:1
    var parts = data.split(":");
    _parseSticking(parts[0]);
    _parseValueAndCount(parts[1]);
    if (parts.length == 3) {
      _parseType(parts[2]);
    }
  }

  _parseValueAndCount(String data) {
    if (data.contains("-")) {
      var parts = data.split("-");
      value = int.parse(parts[0]);
      count = int.parse(parts[1]);
    } else {
      value = int.parse(data);
    }
  }

  _parseType(String code) {
    type = NoteType.values
        .firstWhere((it) => it.code == code, orElse: () => NoteType.standard);
  }

  _parseSticking(String code) {
    sticking = Sticking.values.firstWhere((it) => it.code == code);
  }

  calcLength(double base) {
    if (count > 2) {
      base *= 2 / count;
    }
    return base * 16 / value;
  }
}
