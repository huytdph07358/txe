// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripModel _$TripModelFromJson(Map<String, dynamic> json) => TripModel()
  ..id = json['id'] as String?
  ..tripCode = json['tripCode'] as String?
  ..departureDate = json['departureDate'] as int?
  ..departureTime = json['departureTime'] as String?
  ..vehicleId = json['vehicleId'] as String?
  ..vehicleName = json['vehicleName'] as String?
  ..vehicleNote = json['vehicleNote'] as String?
  ..lineCode = json['lineCode'] as String?
  ..lineName = json['lineName'] as String?
  ..note = json['note'] as String?
  ..duration = json['duration'] as int?
  ..vehicleType = json['vehicleType'] as int?
  ..seatPolicy = json['seatPolicy'] as int?
  ..enterpriseId = json['enterpriseId'] as String?
  ..enterpriseCode = json['enterpriseCode'] as String?
  ..enterpriseName = json['enterpriseName'] as String?
  ..licensePlate = json['licensePlate'] as String?;

Map<String, dynamic> _$TripModelToJson(TripModel instance) => <String, dynamic>{
      'id': instance.id,
      'tripCode': instance.tripCode,
      'departureDate': instance.departureDate,
      'departureTime': instance.departureTime,
      'vehicleId': instance.vehicleId,
      'vehicleName': instance.vehicleName,
      'vehicleNote': instance.vehicleNote,
      'lineCode': instance.lineCode,
      'lineName': instance.lineName,
      'note': instance.note,
      'duration': instance.duration,
      'vehicleType': instance.vehicleType,
      'seatPolicy': instance.seatPolicy,
      'enterpriseId': instance.enterpriseId,
      'enterpriseCode': instance.enterpriseCode,
      'enterpriseName': instance.enterpriseName,
      'licensePlate': instance.licensePlate,
    };
