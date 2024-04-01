import 'package:hive/hive.dart';

class BaseConfig extends HiveObject {
  String lastGroup = "";
  int lastExerciseIndex = 0;
}

class BaseConfigAdapter extends TypeAdapter<BaseConfig> {
  @override
  final typeId = 1;

  @override
  BaseConfig read(BinaryReader reader) {
    var obj = BaseConfig();
    obj.lastGroup = reader.readString();
    obj.lastExerciseIndex = reader.readInt();
    return obj;
  }

  @override
  void write(BinaryWriter writer, BaseConfig obj) {
    writer.writeString(obj.lastGroup);
    writer.writeInt(obj.lastExerciseIndex);
  }
}
