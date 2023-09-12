import 'translate.dart';

/// The translations for English (`en`).
class TranslateEn extends Translate {
  TranslateEn([String locale = 'en']) : super(locale);

  @override
  String get chuaXacDinh => 'Undefined';

  @override
  String get chiTietChuyen => 'Trip details';

  @override
  String get soTuyen => 'Line number';

  @override
  String get tenTuyen => 'Line name';

  @override
  String get tu => 'From';

  @override
  String get den => 'Arrive';

  @override
  String get donViKhaiThac => 'Mining unit';

  @override
  String get bienSo => 'License plates';

  @override
  String get ngayXuatPhat => 'Departure date';

  @override
  String get gioXuatPhat => 'Departure time';

  @override
  String get banVe => 'Ticket Sale';

  @override
  String get veDaBan => 'Ticket Sold';

  @override
  String get gio => ':';

  @override
  String get kiemTra => 'Check';

  @override
  String get khongCoChuyenNao => 'There are no trains';

  @override
  String get soDoGhe => 'Seat Diagram';

  @override
  String get ketThucBanVe => 'End of ticket sales for a successful trip';

  @override
  String get thoiGianKhoiHanh => 'Departure time';

  @override
  String get hangTauXe => 'Car carrier';

  @override
  String get zzz => '';
}
