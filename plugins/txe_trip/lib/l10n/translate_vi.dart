import 'translate.dart';

/// The translations for Vietnamese (`vi`).
class TranslateVi extends Translate {
  TranslateVi([String locale = 'vi']) : super(locale);

  @override
  String get chuaXacDinh => 'Chưa xác định';

  @override
  String get chiTietChuyen => 'Chi tiết chuyến xe';

  @override
  String get soTuyen => 'Số tuyến';

  @override
  String get tenTuyen => 'Tên tuyến';

  @override
  String get tu => 'Từ';

  @override
  String get den => 'Đến';

  @override
  String get donViKhaiThac => 'Đơn vị khai thác';

  @override
  String get bienSo => 'Biển số ';

  @override
  String get ngayXuatPhat => 'Ngày xuất phát';

  @override
  String get gioXuatPhat => 'Giờ xuất phát';

  @override
  String get banVe => 'Bán vé';

  @override
  String get veDaBan => 'Vé đã bán';

  @override
  String get gio => ':';

  @override
  String get kiemTra => 'Kiểm tra';

  @override
  String get khongCoChuyenNao => 'Không có chuyến nào';

  @override
  String get soDoGhe => 'Sơ đồ ghế';

  @override
  String get ketThucBanVe => 'Kết thúc bán vé cho chuyến thành công';

  @override
  String get thoiGianKhoiHanh => 'Thời gian khởi hành';

  @override
  String get hangTauXe => 'Hãng tàu xe';

  @override
  String get zzz => '';
}
