// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_seat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripSeatModel _$TripSeatModelFromJson(Map<String, dynamic> json) =>
    TripSeatModel()
      ..tripId = json['tripId'] as String?
      ..seatId = json['seatId'] as String?
      ..isAvailable = json['isAvailable'] as bool?
      ..status = json['status'] as int?
      ..vehicleId = json['vehicleId'] as String?
      ..seatGroupId = json['seatGroupId'] as String?
      ..tripCode = json['tripCode'] as String?
      ..seatCode = json['seatCode'] as String?
      ..floorNum = json['floorNum'] as int?
      ..rowNum = json['rowNum'] as int?
      ..colNum = json['colNum'] as int?
      ..seatGroupCode = json['seatGroupCode'] as String?
      ..seatGroupName = json['seatGroupName'] as String?
      ..color = json['color'] as String?;

Map<String, dynamic> _$TripSeatModelToJson(TripSeatModel instance) =>
    <String, dynamic>{
      'tripId': instance.tripId,
      'seatId': instance.seatId,
      'isAvailable': instance.isAvailable,
      'status': instance.status,
      'vehicleId': instance.vehicleId,
      'seatGroupId': instance.seatGroupId,
      'tripCode': instance.tripCode,
      'seatCode': instance.seatCode,
      'floorNum': instance.floorNum,
      'rowNum': instance.rowNum,
      'colNum': instance.colNum,
      'seatGroupCode': instance.seatGroupCode,
      'seatGroupName': instance.seatGroupName,
      'color': instance.color,
    };
