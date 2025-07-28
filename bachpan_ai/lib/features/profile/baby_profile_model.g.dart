// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baby_profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BabyProfileAdapter extends TypeAdapter<BabyProfile> {
  @override
  final int typeId = 0;

  @override
  BabyProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BabyProfile(
      name: fields[0] as String,
      gender: fields[1] as String,
      dob: fields[2] as DateTime,
      age: fields[3] as int,
      weight: fields[4] as double,
      photoPath: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BabyProfile obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.gender)
      ..writeByte(2)
      ..write(obj.dob)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.photoPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BabyProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
