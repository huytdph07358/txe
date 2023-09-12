import 'package:json_annotation/json_annotation.dart';
part 'trip_seat_model.g.dart';


@JsonSerializable()
class TripSeatModel {
  TripSeatModel();

  factory TripSeatModel.fromJson(Map<String, dynamic> json) =>
      _$TripSeatModelFromJson(json);

  String? tripId;
  String? seatId;
  bool? isAvailable;
  int? status;
  String? vehicleId;
  String? seatGroupId;
  String? tripCode;
  String? seatCode;
  int? floorNum;
  int? rowNum;
  int? colNum;
  String? seatGroupCode;
  String? seatGroupName;
  String? color;

  Map<String, dynamic> toJson() => _$TripSeatModelToJson(this);

}