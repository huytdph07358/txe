// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) => EmployeeModel()
  ..id = json['id'] as String?
  ..loginname = json['loginname'] as String?
  ..enterpriseId = json['enterpriseId'] as String?
  ..enterpriseCode = json['enterpriseCode'] as String?
  ..enterpriseName = json['enterpriseName'] as String?
  ..isActive = json['isActive'] as bool?
  ..username = json['username'] as String?
  ..phoneNumber = json['phoneNumber'] as String?
  ..address = json['address'] as String?;


Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) => <String, dynamic>{
      'id': instance.id,
      'loginname': instance.loginname,
      'enterpriseId': instance.enterpriseId,
      'enterpriseCode': instance.enterpriseCode,
      'enterpriseName': instance.enterpriseName,
      'isActive': instance.isActive,
      'username': instance.username,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
    };
