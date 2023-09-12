import 'package:json_annotation/json_annotation.dart';
import 'package:vss_date_time_util/date_time_util.dart';

part 'bus_ticket_model.g.dart';

@JsonSerializable()
class BusTicketModel {
  BusTicketModel();

  factory BusTicketModel.fromJson(Map<String, dynamic> json) =>
      _$BusTicketModelFromJson(json);

  String? tripCode;
  String? posCode;
  String? session;
  int? order;

  String? serialNumber;
  String? qrCode;
  int? exportTime;
  double? price;
  int? transFormType;
  String? transCode;

  Map<String, dynamic> toJson() => _$BusTicketModelToJson(this);

  DateTime? getDateTimeExportTime() {
    return DateTimeUtil.parse(exportTime);
  }
}
