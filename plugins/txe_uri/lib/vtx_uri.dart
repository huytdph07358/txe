/*
* Class này chỉ chứa các const là các api gọi đến backend tương ứng với tên class
* Tên constant không viết theo chuẩn thông thường là lowerCamelCase nhằm mục đích khi nhìn vào tên (ở nơi sử dụng) có thể dễ dàng nhận biết được api nào được gọi
* Khi replace ký tự _ trong tên constant bằng ký tự / thì ta được đường dẫn api
* */

class VtxUri {
  static const String api_VtxRole_GetMyAuthorize =
      '/api/VtxRole/GetMyAuthorize';
  static const String api_VtxScreen_GetAll = '/api/VtxScreen/GetAll';
  static const String api_VtxPos_Register = '/api/VtxPos/Register';
  static const String api_VtxPos_GetByCode = '/api/VtxPos/GetByCode';
  static const String api_VtxLineEmployee_Get = '/api/VtxLineEmployee/Get';
  static const String api_VtxLine_Get = '/api/VtxLine/Get';
  static const String api_VtxTrip_Get = '/api/VtxTrip/Get';
  static const String api_VtxTripPos_Get = '/api/VtxTripPos/Get';
  static const String api_VtxTripPos_Initialize = '/api/VtxTripPos/Initialize';
  static const String api_VtxTripPos_End = '/api/VtxTripPos/End';
  static const String api_VtxTripPos_TicketSync = '/api/VtxTripPos/TicketSync';
  static const String api_VtxTripPos_CardCheck = '/api/VtxTripPos/CardCheck';
  static const String api_VtxTripSeat_GetByTrip = '/api/VtxTripSeat/GetByTrip';
  static const String api_VtxFarePolicy_GetByTrip = '/api/VtxFarePolicy/GetByTrip';
  static const String api_VtxTrip_TicketSell = '/api/VtxTrip/TicketSell';
  static const String api_VtxVehicle_GetSeatMapImg = '/api/VtxVehicle/GetSeatMapImg';
  static const String api_VtxTrip_TicketCheck = '/api/VtxTrip/TicketCheck';
  static const String api_VtxTicket_Get = '/api/VtxTicket/Get';
  static const String api_VtxEmployee_Get = '/api/VtxEmployee/Get';
  static const String api_VtxTripPos_MonthlyTicketConfirm =
      '/api/VtxTripPos/MonthlyTicketConfirm';
}