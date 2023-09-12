import 'package:json_annotation/json_annotation.dart';
part 'seat_mapImg_model.g.dart';


@JsonSerializable()
class SeatMapImageModel {
  SeatMapImageModel();

  factory SeatMapImageModel.fromJson(Map<String, dynamic> json) =>
      _$SeatMapImageModelFromJson(json);

  String? id;
  String? vehicleId;
  String? note;
  String? url;
  int? numOrder;

  Map<String, dynamic> toJson() => _$SeatMapImageModelToJson(this);

}
