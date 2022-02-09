// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fast.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FastAdapter extends TypeAdapter<Fast> {
  @override
  final int typeId = 1;

  @override
  Fast read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Fast(
      start: fields[0] as DateTime,
      end: fields[1] as DateTime,
      targetDuration: fields[2] as Duration,
    );
  }

  @override
  void write(BinaryWriter writer, Fast obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.start)
      ..writeByte(1)
      ..write(obj.end)
      ..writeByte(2)
      ..write(obj.targetDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FastAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
