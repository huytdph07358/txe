import 'package:json_annotation/json_annotation.dart';
part 'fare_policy_model.g.dart';


@JsonSerializable()
class FarePolicyModel {
  FarePolicyModel();

  factory FarePolicyModel.fromJson(Map<String, dynamic> json) =>
      _$FarePolicyModelFromJson(json);

  String? tripId;
  String? seatGroupId;
  String? ticketTypeId;
  int? fare;
  String? tripCode;
  String? lineId;
  String? ticketTypeCode;
  String? ticketTypeName;
  bool? isNormal;
  int? ageFrom;
  int? ageTo;
  String? seatGroupCode;
  String? seatGroupName;
  String? lineCode;
  String? lineName;

  Map<String, dynamic> toJson() => _$FarePolicyModelToJson(this);

}
