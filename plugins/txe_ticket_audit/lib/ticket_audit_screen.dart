import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vss_card_reader/vss_card_reader.dart';
import 'package:vss_date_time_util/date_time_util.dart';
import 'package:vss_global_constant/global_constant.dart';
import 'package:vss_ivt_api/api_consumer.dart';
import 'package:vss_ivt_api/api_result_model.dart';
import 'package:vss_ivt_api/dot_net_api.dart';
import 'package:vss_locale/language_store.dart';
import 'package:vss_message_util/message_util.dart';
import 'package:vss_navigator/navigator.dart';
import 'package:vss_navigator/navigator.dart';
import 'package:txe_uri/vtx_uri.dart';
import 'package:txe_backend_domain/backend_domain.dart';
import 'package:txe_app_bar/vxb_app_bar.dart';

import 'l10n/translate.dart';
import 'model/trip_model.dart';
import 'qr_scanner.dart';

class TicketAuditScreen extends StatefulWidget {
  const TicketAuditScreen({super.key});

  @override
  State<TicketAuditScreen> createState() => _TicketAuditScreenState();
}

class _TicketAuditScreenState extends State<TicketAuditScreen> {
  final String screenLink = '/txe_ticket_audit/TicketAudit';
  TripModel? tripModel;
  String? qrcode;
  String? serviceCode;
  late bool formSubmittingQrTurn = false;
  final ValueNotifier<bool> submitNotifierQrTurn = ValueNotifier<bool>(false);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DateFormat dateFormat =
      DateFormat.yMd(LanguageStore.localeSelected.languageCode);
  final NumberFormat currencyFormat = NumberFormat.currency(
      locale: LanguageStore.localeSelected.languageCode,
      symbol: 'đ',
      decimalDigits: 0);
  final ValueNotifier<bool> submitNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic?> argument =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic?>;
      tripModel = argument.containsKey('TripData')
          ? TripModel?.fromJson(argument['TripData']!)
          : null;
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Translate translate = lookupTranslate(LanguageStore.localeSelected);
    return Scaffold(
        appBar: txeAppBar(
          title: translate.kiemTraVe,
          screenLink: screenLink,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              padding: const EdgeInsets.all(GlobalConstant.paddingMarginLength),
              child: Column(
                children: <Widget>[
                Row(
                  children: [
                    Text(translate.soTuyen),
                    GlobalConstant.rowDivider,
                    Expanded(
                      child: Text(
                        tripModel?.lineCode ?? '',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                GlobalConstant.colDivider,
                Row(
                  children: [
                    Text(translate.tenTuyen),
                    GlobalConstant.rowDivider,
                    Expanded(
                      child: Text(
                        tripModel?.lineName ?? '',
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
                        tripModel?.fromStopName?? '',
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
                        tripModel?.toStopName??'',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                GlobalConstant.colDivider,
                Row(
                  children: [
                    Text(translate.donViKhaiThac),
                    GlobalConstant.rowDivider,
                    Expanded(
                      child: Text(
                        tripModel?.enterpriseName ?? '',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                GlobalConstant.colDivider,
                Row(
                  children: [
                    Text(translate.ngayXuatPhat),
                    GlobalConstant.rowDivider,
                    Expanded(
                      child: Text(
                        tripModel?.departureDate != null
                            ? dateFormat.format(
                                DateTimeUtil.parse(tripModel?.departureDate)!)
                            : '',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                GlobalConstant.colDivider,
                Row(
                  children: [
                    Text(translate.gioXuatPhat),
                    GlobalConstant.rowDivider,
                    Expanded(
                      child: Text(
                        tripModel?.departureTime != null
                            ? '${tripModel?.departureTime!.toString().substring(0, 2)}${translate.gio}${tripModel?.departureTime!.toString().substring(2, 4)} '
                            : '',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                GlobalConstant.colDivider,
                  GlobalConstant.colDivider,
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () async {
                            qrcode = await popUpPage<String>(
                                TxaQrScannerScreen(
                                  option: 2,
                                ),
                                context);
                            if (qrcode != null) {
                              handleTicketCheck(qrcode.toString());
                            }
                            print('---------------------------${qrcode}');
                            // else {
                            //   MessageUtil.snackbar(context,
                            //       message: translate.qrHetHan, success: false);
                            // }
                          },
                          child: !formSubmittingQrTurn
                              ? const Text('QR vé')
                              : CircularProgressIndicator(
                                  color: colorScheme.onPrimary,
                                ),
                        ),
                      ),
                      GlobalConstant.rowDivider,
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> handleTicketCheck(String Qrcode) async {
   if (formSubmittingQrTurn) {
      return;
    }
   setState(() {
     formSubmittingQrTurn = true;
     submitNotifierQrTurn.value = true;
   });

    final Translate translate = lookupTranslate(LanguageStore.localeSelected);
    final Map<String, Map<String, dynamic>> body = {
      'ApiData': {'tripCode': tripModel?.tripCode ?? '', 'qrCode': Qrcode}
    };
    final ApiResultModel apiResultModel = await ApiConsumer.dotNetApi.post(
        '${BackendDomain.vtx}${VtxUri.api_VtxTrip_TicketCheck}',
        body: body);
   setState(() {
     formSubmittingQrTurn = false;
     submitNotifierQrTurn.value = false;
   });
    if (apiResultModel.Data != null) {
      MessageUtil.snackbar(context,
          message: translate.veLuotHopLe, success: true);
    } else {
      MessageUtil.snackbar(context,
          message: apiResultModel.getMessage(), success: false);
    }
  }
}
