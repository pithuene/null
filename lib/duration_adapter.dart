import 'package:hive/hive.dart';

class DurationAdapter extends TypeAdapter<Duration> {
  int typeId = 223;

  Duration read(BinaryReader reader) {
    return Duration(seconds: reader.read());
  }

  void write(BinaryWriter writer, Duration obj){
    writer.write(obj.inSeconds);
  }
}
