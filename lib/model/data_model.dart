
import 'package:hive/hive.dart';
part 'data_model.g.dart';

@HiveType(typeId: 0)
class DataModel {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? birthDate;
  @HiveField(2)
  String? mobileNo;
  @HiveField(3)
  String? gender;
  DataModel({this.name, this.birthDate, this.mobileNo, this.gender});
}