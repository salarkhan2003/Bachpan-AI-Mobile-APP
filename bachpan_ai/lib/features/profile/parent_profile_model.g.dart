// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParentProfileAdapter extends TypeAdapter<ParentProfile> {
  @override
  final int typeId = 1;

  @override
  ParentProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ParentProfile(
      name: fields[0] as String,
      email: fields[1] as String,
      phone: fields[2] as String,
      photoPath: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ParentProfile obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.photoPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParentProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
