import 'package:flutter/services.dart';
import 'package:quiver/collection.dart';
import 'package:stick_control/exercise/exercise.dart';

class ExerciseLibrary {
  Multimap<String, Exercise> exercises = Multimap();

  Future<void> load() async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final exList = assetManifest
        .listAssets()
        .where((string) => string.startsWith("assets/ex/"))
        .toList();
    for (var key in exList) {
      print("load $key");
      var json = await rootBundle.loadString(key);
      var exercise = Exercise(json);
      exercises.add(exercise.group, exercise);
    }
  }
}
