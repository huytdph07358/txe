import 'package:json_annotation/json_annotation.dart';
import 'package:vss_date_time_util/date_time_util.dart';

part 'sold_ticket_model.g.dart';

@JsonSerializable()
class SoldTicketModel {
  SoldTicketModel();
  factory SoldTicketModel.fromJson(Map<String, dynamic> json) => _$SoldTicketModelFromJson(json);
  String? tripId;
  String? tripCode;
  String? lineId;
  String? lineCode;
  String? lineNote;
  String? serialNumber;
  int? exportTime;
  String? ticketTypeName;
  String? passengerName;
  int? fare;
  String? seatId;
  String? seatCode;
  String? seatGroupId;
  String? seatGroupName;
  int? floorNum;
  int? rowNum;
  int? colNum;
  String? sellerUsername;
  String? paymentCode;

  Map<String, dynamic> toJson() => _$SoldTicketModelToJson(this);

  DateTime? getDateTimeExportTime() {
    return DateTimeUtil.parse(exportTime);
  }
}

