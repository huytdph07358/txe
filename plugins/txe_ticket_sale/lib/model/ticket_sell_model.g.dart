// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_sell_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketSellModel _$TicketSellModelFromJson(Map<String, dynamic> json) =>
    TicketSellModel()
      ..tripId = json['tripId'] as String?
      ..tripCode = json['tripCode'] as String?
      ..departureDate = json['departureDate'] as int?
      ..departureTime = json['departureTime'] as String?
      ..lineCode = json['lineCode'] as String?
      ..lineName = json['lineName'] as String?
      ..arrivalTime = json['arrivalTime'] as int?
      ..licensePlate = json['licensePlate'] as String?
      ..vehicleName = json['vehicleName'] as String?
      ..vehicleType = json['vehicleType'] as int?
      ..enterpriseCode = json['enterpriseCode'] as String?
      ..enterpriseName = json['enterpriseName'] as String?
      ..ticketId = json['ticketId'] as String?
      ..serialNumber = json['serialNumber'] as String?
      ..qrCode = json['qrCode'] as String?
      ..exportTime = json['exportTime'] as int?
      ..fare = json['fare'] as int?
      ..ticketTypeId = json['ticketTypeId'] as String?
      ..ticketTypeCode = json['ticketTypeCode'] as String?
      ..ticketTypeName = json['ticketTypeName'] as String?
      ..seatCode = json['seatCode'] as String?
      ..seatGroupId = json['seatGroupId'] as String?
      ..seatGroupCode = json['seatGroupCode'] as String?
      ..seatGroupName = json['seatGroupName'] as String?
      ..floorNum = json['floorNum'] as int?
      ..rowNum = json['rowNum'] as int?
      ..colNum = json['colNum'] as int?;

Map<String, dynamic> _$TicketSellModelToJson(TicketSellModel instance) =>
    <String, dynamic>{
      'tripId': instance.tripId,
      'tripCode': instance.tripCode,
      'departureDate': instance.departureDate,
      'departureTime': instance.departureTime,
      'lineCode': instance.lineCode,
      'lineName': instance.lineName,
      'arrivalTime': instance.arrivalTime,
      'licensePlate': instance.licensePlate,
      'vehicleName': instance.vehicleName,
      'vehicleType': instance.vehicleType,
      'enterpriseCode': instance.enterpriseCode,
      'enterpriseName': instance.enterpriseName,
      'ticketId': instance.ticketId,
      'serialNumber': instance.serialNumber,
      'qrCode': instance.qrCode,
      'exportTime': instance.exportTime,
      'fare': instance.fare,
      'ticketTypeId': instance.ticketTypeId,
      'ticketTypeCode': instance.ticketTypeCode,
      'ticketTypeName': instance.ticketTypeName,
      'seatCode': instance.seatCode,
      'seatGroupId': instance.seatGroupId,
      'seatGroupCode': instance.seatGroupCode,
      'seatGroupName': instance.seatGroupName,
      'floorNum': instance.floorNum,
      'rowNum': instance.rowNum,
      'colNum': instance.colNum,
    };
