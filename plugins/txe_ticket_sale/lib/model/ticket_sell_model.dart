import 'package:json_annotation/json_annotation.dart';

part 'ticket_sell_model.g.dart';

@JsonSerializable()
class TicketSellModel {
  TicketSellModel();

  factory TicketSellModel.fromJson(Map<String, dynamic> json) =>
      _$TicketSellModelFromJson(json);

  String? tripId;
  String? tripCode;
  int? departureDate;
  String? departureTime;
  String? lineCode;
  String? lineName;
  int? arrivalTime;
  String? licensePlate;
  String? vehicleName;
  int? vehicleType;
  String? enterpriseCode;
  String? enterpriseName;

  String? ticketId;	
  String? serialNumber;	
  String? qrCode;
  int? exportTime;
  int? fare;	
  String? ticketTypeId;	
  String? ticketTypeCode;	
  String? ticketTypeName;	
  String? seatCode;	
  String? seatGroupId;	
  String? seatGroupCode;
  String? seatGroupName;	
  int? floorNum;	
  int? rowNum;	
  int? colNum;	
  Map<String, dynamic> toJson() => _$TicketSellModelToJson(this);
}
