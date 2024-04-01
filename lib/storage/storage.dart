import 'package:hive_flutter/hive_flutter.dart';
import 'package:stick_control/exercise/exercise.dart';
import 'package:stick_control/exercise/exercise_library.dart';
import 'package:stick_control/storage/base_config.dart';
import 'package:stick_control/storage/exercise_statistic.dart';

final Storage storage = Storage();

final class Storage {
  late Box<ExerciseStatistic> exerciseStatistics;
  late Box<BaseConfig> _configBox;
  late BaseConfig config;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExerciseStatisticAdapter());
    Hive.registerAdapter(BaseConfigAdapter());
    exerciseStatistics =
        await Hive.openBox<ExerciseStatistic>("exerciseStatistics");
    _configBox = await Hive.openBox<BaseConfig>("baseConfig");
    if (!_configBox.containsKey(0)) {
      _configBox.put(0, BaseConfig());
    }
    config = _configBox.get(0)!;
  }

  updateConfig() {
    _configBox.put(0, config);
  }

  Map<Exercise, ExerciseStatistic> getExerciseStatistics(
      ExerciseLibrary library) {
    var statistics = exerciseStatistics.toMap();
    var map = <Exercise, ExerciseStatistic>{};
    for (var exercise in library.exercises.values) {
      map[exercise] = statistics[exerciseKey(exercise)] ?? ExerciseStatistic();
    }
    return map;
  }

  ExerciseStatistic getExerciseStatistic(Exercise exercise) {
    var key = exerciseKey(exercise);
    return exerciseStatistics.get(key) ?? ExerciseStatistic();
  }

  updateExerciseStats(Exercise exercise, ExerciseStatistic statistic) {
    exerciseStatistics.put(exerciseKey(exercise), statistic);
  }

  String exerciseKey(Exercise exercise) {
    return "${exercise.group}-${exercise.name}";
  }
}
