import 'translate.dart';

/// The translations for English (`en`).
class TranslateEn extends Translate {
  TranslateEn([String locale = 'en']) : super(locale);

  @override
  String get tuyen => 'Route';

  @override
  String get longtext_khongCoTuyenNao => 'You are not assigned to any route to sell tickets.';

  @override
  String get zzz => '';
}
