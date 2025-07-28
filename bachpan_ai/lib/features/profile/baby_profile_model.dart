import 'package:hive/hive.dart';
part 'baby_profile_model.g.dart';

@HiveType(typeId: 0)
class BabyProfile extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String gender;
  @HiveField(2)
  DateTime dob;
  @HiveField(3)
  int age;
  @HiveField(4)
  double weight;
  @HiveField(5)
  String? photoPath;

  BabyProfile({
    required this.name,
    required this.gender,
    required this.dob,
    required this.age,
    required this.weight,
    this.photoPath,
  });
} 