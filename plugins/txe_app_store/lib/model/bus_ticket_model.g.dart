// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusTicketModel _$BusTicketModelFromJson(Map<String, dynamic> json) =>
    BusTicketModel()
      ..tripCode = json['tripCode'] as String?
      ..posCode = json['posCode'] as String?
      ..session = json['session'] as String?
      ..order = json['order'] as int?
      ..serialNumber = json['serialNumber'] as String?
      ..qrCode = json['qrCode'] as String?
      ..exportTime = json['exportTime'] as int?
      ..price = (json['price'] as num?)?.toDouble()
      ..transFormType = json['transFormType'] as int?
      ..transCode = json['transCode'] as String?;

Map<String, dynamic> _$BusTicketModelToJson(BusTicketModel instance) =>
    <String, dynamic>{
      'tripCode': instance.tripCode,
      'posCode': instance.posCode,
      'session': instance.session,
      'order': instance.order,
      'serialNumber': instance.serialNumber,
      'qrCode': instance.qrCode,
      'exportTime': instance.exportTime,
      'price': instance.price,
      'transFormType': instance.transFormType,
      'transCode': instance.transCode,
    };
