// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LineModel _$LineModelFromJson(Map<String, dynamic> json) => LineModel()
  ..id = json['id'] as String?
  ..lineCode = json['lineCode'] as String?
  ..lineName = json['lineName'] as String?
  ..note = json['note'] as String?
  ..duration = json['duration'] as int?
  ..vehicleType = json['vehicleType'] as int?
  ..seatPolicy = json['seatPolicy'] as int?
  ..isActive = json['isActive'] as bool?
  ..enterpriseId = json['enterpriseId'] as String?
  ..enterpriseCode = json['enterpriseCode'] as String?
  ..enterpriseName = json['enterpriseName'] as String?;

Map<String, dynamic> _$LineModelToJson(LineModel instance) => <String, dynamic>{
      'id': instance.id,
      'lineCode': instance.lineCode,
      'lineName': instance.lineName,
      'note': instance.note,
      'duration': instance.duration,
      'vehicleType': instance.vehicleType,
      'seatPolicy': instance.seatPolicy,
      'isActive': instance.isActive,
      'enterpriseId': instance.enterpriseId,
      'enterpriseCode': instance.enterpriseCode,
      'enterpriseName': instance.enterpriseName,
    };
