// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoldTicketModel _$SoldTicketModelFromJson(Map<String, dynamic> json) =>
    SoldTicketModel()
      ..tripId = json['tripId'] as String?
      ..tripCode = json['tripCode'] as String?
      ..lineId = json['lineId'] as String?
      ..lineCode = json['lineCode'] as String?
      ..lineNote = json['lineNote'] as String?
      ..serialNumber = json['serialNumber'] as String?
      ..exportTime = json['exportTime'] as int?
      ..ticketTypeName = json['ticketTypeName'] as String?
      ..passengerName = json['passengerName'] as String?
      ..fare = json['fare'] as int?
      ..seatId = json['seatId'] as String?
      ..seatCode = json['seatCode'] as String?
      ..seatGroupId = json['seatGroupId'] as String?
      ..seatGroupName = json['seatGroupName'] as String?
      ..floorNum = json['floorNum'] as int?
      ..rowNum = json['rowNum'] as int?
      ..colNum = json['colNum'] as int?
      ..sellerUsername = json['sellerUsername'] as String?
      ..paymentCode = json['paymentCode'] as String?;

Map<String, dynamic> _$SoldTicketModelToJson(SoldTicketModel instance) =>
    <String, dynamic>{
      'tripId': instance.tripId,
      'tripCode': instance.tripCode,
      'lineId': instance.lineId,
      'lineCode': instance.lineCode,
      'lineNote': instance.lineNote,
      'serialNumber': instance.serialNumber,
      'exportTime': instance.exportTime,
      'ticketTypeName': instance.ticketTypeName,
      'passengerName': instance.passengerName,
      'fare': instance.fare,
      'seatId': instance.seatId,
      'seatCode': instance.seatCode,
      'seatGroupId': instance.seatGroupId,
      'seatGroupName': instance.seatGroupName,
      'floorNum': instance.floorNum,
      'rowNum': instance.rowNum,
      'colNum': instance.colNum,
      'sellerUsername': instance.sellerUsername,
      'paymentCode': instance.paymentCode,
    };
