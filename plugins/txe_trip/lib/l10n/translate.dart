import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'translate_en.dart';
import 'translate_vi.dart';

/// Callers can lookup localized strings with an instance of Translate
/// returned by `Translate.of(context)`.
///
/// Applications need to include `Translate.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/translate.dart';
///
/// return MaterialApp(
///   localizationsDelegates: Translate.localizationsDelegates,
///   supportedLocales: Translate.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the Translate.supportedLocales
/// property.
abstract class Translate {
  Translate(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static Translate of(BuildContext context) {
    return Localizations.of<Translate>(context, Translate)!;
  }

  static const LocalizationsDelegate<Translate> delegate = _TranslateDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @chuaXacDinh.
  ///
  /// In en, this message translates to:
  /// **'Undefined'**
  String get chuaXacDinh;

  /// No description provided for @chiTietChuyen.
  ///
  /// In en, this message translates to:
  /// **'Trip details'**
  String get chiTietChuyen;

  /// No description provided for @soTuyen.
  ///
  /// In en, this message translates to:
  /// **'Line number'**
  String get soTuyen;

  /// No description provided for @tenTuyen.
  ///
  /// In en, this message translates to:
  /// **'Line name'**
  String get tenTuyen;

  /// No description provided for @tu.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get tu;

  /// No description provided for @den.
  ///
  /// In en, this message translates to:
  /// **'Arrive'**
  String get den;

  /// No description provided for @donViKhaiThac.
  ///
  /// In en, this message translates to:
  /// **'Mining unit'**
  String get donViKhaiThac;

  /// No description provided for @bienSo.
  ///
  /// In en, this message translates to:
  /// **'License plates'**
  String get bienSo;

  /// No description provided for @ngayXuatPhat.
  ///
  /// In en, this message translates to:
  /// **'Departure date'**
  String get ngayXuatPhat;

  /// No description provided for @gioXuatPhat.
  ///
  /// In en, this message translates to:
  /// **'Departure time'**
  String get gioXuatPhat;

  /// No description provided for @banVe.
  ///
  /// In en, this message translates to:
  /// **'Ticket Sale'**
  String get banVe;

  /// No description provided for @veDaBan.
  ///
  /// In en, this message translates to:
  /// **'Ticket Sold'**
  String get veDaBan;

  /// No description provided for @gio.
  ///
  /// In en, this message translates to:
  /// **':'**
  String get gio;

  /// No description provided for @kiemTra.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get kiemTra;

  /// No description provided for @khongCoChuyenNao.
  ///
  /// In en, this message translates to:
  /// **'There are no trains'**
  String get khongCoChuyenNao;

  /// No description provided for @soDoGhe.
  ///
  /// In en, this message translates to:
  /// **'Seat Diagram'**
  String get soDoGhe;

  /// No description provided for @ketThucBanVe.
  ///
  /// In en, this message translates to:
  /// **'End of ticket sales for a successful trip'**
  String get ketThucBanVe;

  /// No description provided for @thoiGianKhoiHanh.
  ///
  /// In en, this message translates to:
  /// **'Departure time'**
  String get thoiGianKhoiHanh;

  /// No description provided for @hangTauXe.
  ///
  /// In en, this message translates to:
  /// **'Car carrier'**
  String get hangTauXe;

  /// No description provided for @zzz.
  ///
  /// In en, this message translates to:
  /// **''**
  String get zzz;
}

class _TranslateDelegate extends LocalizationsDelegate<Translate> {
  const _TranslateDelegate();

  @override
  Future<Translate> load(Locale locale) {
    return SynchronousFuture<Translate>(lookupTranslate(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_TranslateDelegate old) => false;
}

Translate lookupTranslate(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return TranslateEn();
    case 'vi': return TranslateVi();
  }

  throw FlutterError(
    'Translate.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
