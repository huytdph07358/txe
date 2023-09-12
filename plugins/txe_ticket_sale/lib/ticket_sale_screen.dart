import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:txe_app_bar/vxb_app_bar.dart';
import 'package:txe_app_store/login_store.dart';
import 'package:txe_backend_domain/backend_domain.dart';
import 'package:txe_pos_integrate/pos_integrate.dart';
import 'package:txe_uri/vtx_uri.dart';
import 'package:vss_card_reader/vss_card_reader.dart';
import 'package:vss_global_constant/global_constant.dart';
import 'package:vss_ivt_api/api_consumer.dart';
import 'package:vss_ivt_api/api_result_model.dart';
import 'package:vss_locale/language_store.dart';
import 'package:vss_message_util/message_util.dart';
import 'package:vss_navigator/navigator.dart';

import 'chair_diagram_screen.dart';
import 'l10n/translate.dart';
import 'model/fare_policy_model.dart';
import 'model/ticket_sell_model.dart';
import 'model/trip_model.dart';
import 'model/trip_seat_model.dart';
import 'multiSelect.dart';
import 'qr_scanner.dart';
import 'sold_ticket_screen.dart';

class TicketSaleScreen extends StatefulWidget {
  const TicketSaleScreen({
    super.key,
  });

  @override
  State<TicketSaleScreen> createState() => _TicketSaleScreenState();
}

class _TicketSaleScreenState extends State<TicketSaleScreen> {
  final String screenLink = '/txe_ticket_sale/TicketSaleScreen';
  final ValueNotifier<bool> submitNotifier = ValueNotifier<bool>(false);
  bool formSubmitting = false;
  bool tap = false;
  String? categoryCode;
  TripSeatModel? cardDropdownValue;
  FarePolicyModel? farePolicyDropdownValue;
  final FocusNode focusNode = FocusNode();
  List<TripSeatModel> cardList = <TripSeatModel>[];
  final List<TripSeatModel> items = <TripSeatModel>[];
  List<TripSeatModel> _selectedItems = <TripSeatModel>[];
  List<FarePolicyModel> farePolicyList = <FarePolicyModel>[];
  List<FarePolicyModel> result = <FarePolicyModel>[];
  final ValueNotifier<bool> submitNotifierStart = ValueNotifier<bool>(false);
  FarePolicyModel? farePolicyModel;
  TicketSellModel? ticketSellModel;
  TicketSellModel? ticketSells;
  List<TicketSellModel> ticketSell = <TicketSellModel>[];
  List<TripModel> tripModel = <TripModel>[];
  TripModel? tripModels;
  String? seatGroupId;
  String? ticketTypeCode;
  String? tripId;
  String? vehicleId;
  String? lineName;
  int? type = 1;
  DateTime today = DateTime.now();
  bool isSetMonth = false;
  DateTime month = DateTime.now();
  bool isCallApi = false;

  trip() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, String> argument =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      tripId = argument['TripId'] ?? '';
    }
    return tripId.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, String> arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      tripId = arguments['Tripid'] ?? '';
    }
    if (isCallApi == false) {
      getFarePolicy();
      isCallApi = true;
    }
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, String> argument =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      vehicleId = argument['vehicleId'] ?? '';
    }
    print('????????????????????????????${trip()}');
    print(LoginStore.acsTokenModel?.TokenCode);

    final Translate translate = lookupTranslate(LanguageStore.localeSelected);
    final NumberFormat currencyFormat = NumberFormat.currency(
        locale: LanguageStore.localeSelected.languageCode, symbol: 'đ', decimalDigits: 0);
    final int soGhe = _selectedItems.length;

    return Scaffold(
      appBar: txeAppBar(
        screenLink: screenLink,
        title: translate.banVe,
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(GlobalConstant.paddingMarginLength),
        child: Column(
          children: <Widget>[
            GlobalConstant.colDivider,
            chooseCardDropdownButton(labelText: translate.doiTuong),
            GlobalConstant.colDivider,
            Row(
              children: <Widget>[
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: submitNotifierStart,
                    builder: (BuildContext context, bool val, Widget? child) {
                      return FilledButton(
                        onPressed: () async {
                          btnShow();
                        },
                        child: Text(translate.chonGhe));
                    },
                  ),
                ),
              ],
            ),
            GlobalConstant.colDivider,
            // Row(
            //   children: <Widget>[
            //     Expanded(
            //       child: ValueListenableBuilder(
            //         valueListenable: submitNotifierStart,
            //         builder: (BuildContext context, bool val, Widget? child) {
            //           return FilledButton(
            //               onPressed: () async {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (BuildContext context) =>
            //                             ChairDiagramScreen(vehicleId: vehicleId,)));
            //               },
            //               child: Text(translate.soDoGhe));
            //         },
            //       ),
            //     ),
            //     GlobalConstant.rowDivider,
            //     Expanded(
            //       child: ValueListenableBuilder(
            //         valueListenable: submitNotifierStart,
            //         builder: (BuildContext context, bool val, Widget? child) {
            //           return FilledButton(
            //               onPressed: () async {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (BuildContext context) =>
            //                             const SoldTicketScreen()));
            //               },
            //               child: Text(translate.veDaBan));
            //         },
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      )),
    );
  }


  Future<void> btnShow() async {
    Navigator.pushNamed(context, '/tva_vtx_ticket/VtxSeatScreen',
      arguments: <String, dynamic>{
        'tripid': tripId ?? '',
        'ticketTypeData': farePolicyDropdownValue?.toJson(),
      });
    }

  Future<void> getTripSeatModel() async {
    final ApiResultModel apiResultModel = await ApiConsumer.dotNetCoreApi.get(
        '${BackendDomain.vtx}${VtxUri.api_VtxTripSeat_GetByTrip}',
        param: <String, String>{
          'ApiData.TripId': trip(),
        });
    if (apiResultModel.Data != null) {
      cardList = (apiResultModel.Data as List)
          .map((e) => TripSeatModel.fromJson(e as Map<String, dynamic>))
          .toList();
      cardList.sort((TripSeatModel a, TripSeatModel b) =>
          a.seatCode!.compareTo(b.seatCode!));
    }
    setState(() {
      cardDropdownValue = cardList.first;
    });
  }

  Future<void> getFarePolicy() async {
    final ApiResultModel apiResultModel = await ApiConsumer.dotNetCoreApi.get(
        '${BackendDomain.vtx}${VtxUri.api_VtxFarePolicy_GetByTrip}',
        param: <String, String>{
          'ApiData.TripId': trip(),
          'ApiData.SeatGroupCode': '002'
        });
    if (apiResultModel.Data != null) {
      farePolicyList = (apiResultModel.Data as List)
          .map((e) => FarePolicyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    setState(() {
      farePolicyDropdownValue = farePolicyList.first;
    });
  }

  Future<List<FarePolicyModel>?> getFare() async {
    final ApiResultModel apiResultModel = await ApiConsumer.dotNetCoreApi.get(
        '${BackendDomain.vtx}${VtxUri.api_VtxFarePolicy_GetByTrip}',
        param: <String, String>{
          'ApiData.TripId': trip(),
        });
    if (apiResultModel.Data != null) {
      result = (apiResultModel.Data as List)
          .map((e) => FarePolicyModel.fromJson(e as Map<String, dynamic>))
          .toList()
          .where((FarePolicyModel element) =>
              element.seatGroupId == seatGroupId &&
              element.ticketTypeCode == ticketTypeCode)
          .toList();
    }
    return result.isNotEmpty ? result : null;
  }

  Widget chooseCardDropdownButton({
    String? labelText,
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<FarePolicyModel>(
        isExpanded: true,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.transparent,
          labelText: labelText,
        ),
        value: farePolicyDropdownValue,
        onChanged: (FarePolicyModel? value) {
          setState(() {
            farePolicyDropdownValue = value;
            // cardDropdownValue = null;
            // _selectedItems = <TripSeatModel>[];
            // focusNode.requestFocus();
            // seatGroupId = value?.seatGroupId;
            // ticketTypeCode = value?.ticketTypeCode;
          });
          getTripSeatModel();
        },
        items: farePolicyList
            .map<DropdownMenuItem<FarePolicyModel>>((FarePolicyModel value) {
          return DropdownMenuItem<FarePolicyModel>(
            value: value,
            child: Text('${value.ticketTypeName}'),
          );
        }).toList(),
      ),
    );
  }
}
