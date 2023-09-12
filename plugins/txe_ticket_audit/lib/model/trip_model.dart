import 'package:json_annotation/json_annotation.dart';

part 'trip_model.g.dart';

@JsonSerializable()
class TripModel {
  TripModel();

  factory TripModel.fromJson(Map<String, dynamic> json) =>
      _$TripModelFromJson(json);

  String? id;
  String? tripCode;
  int? departureDate;
  String? departureTime;
  String? vehicleId;
  String? vehicleName;
  String? vehicleNote;
  String? lineCode;
  String? lineName;
  String? note;
  int? duration;
  int? vehicleType;
  int? seatPolicy;
  String? enterpriseId;
  String? enterpriseCode;
  String? enterpriseName;
  String? licensePlate;
  String? fromStopId;
  String? fromStopCode;
  String? fromStopName;
  String? toStopId;
  String? toStopCode;
  String? toStopName;

  Map<String, dynamic> toJson() => _$TripModelToJson(this);
}

