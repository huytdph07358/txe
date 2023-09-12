import 'package:json_annotation/json_annotation.dart';

part 'line_model.g.dart';

@JsonSerializable()
class LineModel {
  LineModel();

  factory LineModel.fromJson(Map<String, dynamic> json) =>
      _$LineModelFromJson(json);

  String? id;
  String? lineCode;
  String? lineName;
  String? note;
  int? duration;
  int? vehicleType;
  int? seatPolicy;
  bool? isActive;
  String? enterpriseId;
  String? enterpriseCode;
  String? enterpriseName;

  Map<String, dynamic> toJson() => _$LineModelToJson(this);
}
