import 'package:hive/hive.dart';
part 'parent_profile_model.g.dart';

@HiveType(typeId: 1)
class ParentProfile extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String email;
  @HiveField(2)
  String phone;
  @HiveField(3)
  String? photoPath;

  ParentProfile({
    required this.name,
    required this.email,
    required this.phone,
    this.photoPath,
  });
} 