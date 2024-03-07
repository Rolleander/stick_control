import 'package:flutter/services.dart';
import 'package:stick_control/exercise/exercise.dart';

class ExerciseLibrary {
  List<Exercise> exercises = [];

  Future<void> load() async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final exList = assetManifest
        .listAssets()
        .where((string) => string.startsWith("assets/ex/"))
        .toList();
    for (var key in exList) {
      print("load " + key);
      var json = await rootBundle.loadString(key);
      exercises.add(Exercise(json));
    }
  }
}
