import 'package:hive/hive.dart';

class ExerciseStatistic extends HiveObject {
  int time = 0;
  int lastBpm = 100;
}

class ExerciseStatisticAdapter extends TypeAdapter<ExerciseStatistic> {
  @override
  final typeId = 0;

  @override
  ExerciseStatistic read(BinaryReader reader) {
    var statistic = ExerciseStatistic();
    statistic.time = reader.readInt();
    statistic.lastBpm = reader.readInt();
    return statistic;
  }

  @override
  void write(BinaryWriter writer, ExerciseStatistic obj) {
    writer.writeInt(obj.time);
    writer.writeInt(obj.lastBpm);
  }
}
