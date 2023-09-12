import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:txe_app_store/login_store.dart';
import 'package:vss_global_constant/global_constant.dart';
import 'package:vss_locale/language_store.dart';
import 'package:txe_app_bar/vxb_app_bar.dart';
import 'model/trip_model.dart';
import 'package:vss_date_time_util/date_time_util.dart';
import 'l10n/translate.dart';

class DetailTripScreen extends StatefulWidget {
  const DetailTripScreen({super.key, this.tripcode});

  final tripcode;

  @override
  State<DetailTripScreen> createState() => _DetailTripScreenState();
}

class _DetailTripScreenState extends State<DetailTripScreen> {
  TripModel? TripData;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DateFormat dateFormat =
      DateFormat.yMd(LanguageStore.localeSelected.languageCode);
  final NumberFormat currencyFormat = NumberFormat.currency(
      locale: LanguageStore.localeSelected.languageCode,
      symbol: 'đ',
      decimalDigits: 0);
  final ValueNotifier<bool> submitNotifierStart = ValueNotifier<bool>(false);
  late bool formSubmittingStart = false;
  final ValueNotifier<bool> submitNotifierDisplay = ValueNotifier<bool>(false);
  late bool formSubmittingDisplay = false;
  final ValueNotifier<bool> submitNotifierEnd = ValueNotifier<bool>(false);
  late bool formSubmittingEnd = false;

  @override
  Widget build(BuildContext context) {
    print(LoginStore.acsTokenModel?.TokenCode);
    final Translate translate = lookupTranslate(LanguageStore.localeSelected);
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic> argument =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      TripData = argument.containsKey('TripData')
          ? TripModel.fromJson(argument['TripData']!)
          : null;
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: txeAppBar(
        title: translate.chiTietChuyen,
        screenLink: '/txe_trip/DetailTripScreen',
        forceTitle: translate.chiTietChuyen,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(GlobalConstant.paddingMarginLength),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                GlobalConstant.colDivider,
                Row(
                  children: [
                    Text(translate.tenTuyen),
                    GlobalConstant.rowDivider,
                    Expanded(
                      child: Text(
                        TripData?.lineName ?? '',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                GlobalConstant.colDivider,
                Row(
                  children: [
                    Text(translate.tu),
                    GlobalConstant.rowDivider,
                    Expanded(
                      child: Text(
                        TripData?.fromStopName ?? '',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                GlobalConstant.colDivider,
                Row(
                  children: [
                    Text(translate.den),
                    GlobalConstant.rowDivider,
                    Expanded(
                      child: Text(
                        TripData?.toStopName ?? '',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                GlobalConstant.colDivider,
                Row(
                  children: [
                    Text(translate.hangTauXe),
                    GlobalConstant.rowDivider,
                    Expanded(
                      child: Text(
                        TripData?.enterpriseName ?? '',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                GlobalConstant.colDivider,
                Row(
                  children: [
                    Text(translate.bienSo),
                    GlobalConstant.rowDivider,
                    Expanded(
                      child: Text(
                        TripData?.licensePlate ?? '',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                GlobalConstant.colDivider,
                Row(
                  children: [
                    Text(translate.thoiGianKhoiHanh),
                    GlobalConstant.rowDivider,
                    Expanded(
                      child: Text(
                        TripData?.departureDate != null
                            ? '${dateFormat.format(
                                DateTimeUtil.parse(TripData?.departureDate)!)} ${TripData?.departureTime!.toString().substring(0, 2)}${translate.gio}${TripData?.departureTime!.toString().substring(2, 4)} '
                            : '',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                GlobalConstant.colDivider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: submitNotifierEnd,
                          builder:
                          (BuildContext context, bool val, Widget? child) {
                          return FilledButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              print(' click End');
                              btnCheck();
                            }
                          },
                          child: !formSubmittingEnd
                          ? Text(translate.kiemTra)
                              : CircularProgressIndicator(
                          color: colorScheme.onPrimary,
                           ),
                          );
                        },
                      ),
                    ),
                    GlobalConstant.rowDivider,
                    Expanded(
                      flex: 1,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/txe_ticket_sale/TicketSaleScreen',
                              arguments: <String, String>{
                                'TripId': TripData?.id ?? '',
                                'vehicleId': TripData?.vehicleId ?? '',
                              });
                        },
                        child: Text(translate.banVe),
                      ),
                    ),
                  ],
                ),
                GlobalConstant.colDivider,
                Row(
                  children: [
                  if (TripData?.tripCode != null)
                    Expanded(
                      flex: 1,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/txe_ticket_sale/SoldTicketScreen',
                              arguments: <String, String>{
                                'tripCode': TripData?.tripCode ?? '',
                              });
                        },
                        child: Text(translate.veDaBan),
                      ),
                    ),
                    GlobalConstant.rowDivider,
                    Expanded(
                      flex: 1,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/txe_ticket_sale/ChairDiagramScreen',
                              arguments: <String, String>{
                                'vehicleId': TripData?.vehicleId ?? '',
                              });
                        },
                        child: Text(translate.soDoGhe),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> btnCheck() async {
    Navigator.pushNamed(context, '/txe_ticket_audit/TicketAudit',
        arguments: <String, dynamic>{
          'TripData': TripData!.toJson(),
        });
  }

}
