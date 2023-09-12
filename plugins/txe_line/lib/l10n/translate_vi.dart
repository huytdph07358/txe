import 'translate.dart';

/// The translations for Vietnamese (`vi`).
class TranslateVi extends Translate {
  TranslateVi([String locale = 'vi']) : super(locale);

  @override
  String get tuyen => 'Tuyến';

  @override
  String get longtext_khongCoTuyenNao => 'Bạn đang không được gán vào tuyến nào để bán vé.';

  @override
  String get zzz => '';
}
