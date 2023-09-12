import 'package:json_annotation/json_annotation.dart';

part 'employee_model.g.dart';

@JsonSerializable()
class EmployeeModel {
  EmployeeModel();

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);

  String? id;
  String? loginname;
  String? enterpriseId;
  String? enterpriseCode;
  String? enterpriseName;
  bool? isActive;
  String? username;
  String? phoneNumber;
  String? address;

  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);
}

