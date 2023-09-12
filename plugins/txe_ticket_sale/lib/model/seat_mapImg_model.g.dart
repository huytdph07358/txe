// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_mapImg_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeatMapImageModel _$SeatMapImageModelFromJson(Map<String, dynamic> json) =>
    SeatMapImageModel()
      ..id = json['id'] as String?
      ..vehicleId = json['vehicleId'] as String?
      ..note = json['note'] as String?
      ..url = json['url'] as String?
      ..numOrder = json['numOrder'] as int?;

Map<String, dynamic> _$SeatMapImageModelToJson(SeatMapImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'note': instance.note,
      'url': instance.url,
      'numOrder': instance.numOrder,
    };
