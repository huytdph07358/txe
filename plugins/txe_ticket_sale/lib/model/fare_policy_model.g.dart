// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_policy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarePolicyModel _$FarePolicyModelFromJson(Map<String, dynamic> json) =>
    FarePolicyModel()
      ..tripId = json['tripId'] as String?
      ..seatGroupId = json['seatGroupId'] as String?
      ..ticketTypeId = json['ticketTypeId'] as String?
      ..fare = json['fare'] as int?
      ..tripCode = json['tripCode'] as String?
      ..lineId = json['lineId'] as String?
      ..ticketTypeCode = json['ticketTypeCode'] as String?
      ..ticketTypeName = json['ticketTypeName'] as String?
      ..isNormal = json['isNormal'] as bool?
      ..ageFrom = json['ageFrom'] as int?
      ..ageTo = json['ageTo'] as int?
      ..seatGroupCode = json['seatGroupCode'] as String?
      ..seatGroupName = json['seatGroupName'] as String?
      ..lineCode = json['lineCode'] as String?
      ..lineName = json['lineName'] as String?;

Map<String, dynamic> _$FarePolicyModelToJson(FarePolicyModel instance) =>
    <String, dynamic>{
      'tripId': instance.tripId,
      'seatGroupId': instance.seatGroupId,
      'ticketTypeId': instance.ticketTypeId,
      'fare': instance.fare,
      'tripCode': instance.tripCode,
      'lineId': instance.lineId,
      'ticketTypeCode': instance.ticketTypeCode,
      'ticketTypeName': instance.ticketTypeName,
      'isNormal': instance.isNormal,
      'ageFrom': instance.ageFrom,
      'ageTo': instance.ageTo,
      'seatGroupCode': instance.seatGroupCode,
      'seatGroupName': instance.seatGroupName,
      'lineCode': instance.lineCode,
      'lineName': instance.lineName,
    };
