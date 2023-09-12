import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:txe_app_bar/vxb_app_bar.dart';
import 'package:txe_backend_domain/backend_domain.dart';
import 'package:txe_pos_integrate/pos_integrate.dart';
import 'package:txe_uri/vtx_uri.dart';
import 'package:vss_book_seat/vss_book_seat.dart';
import 'package:vss_card_reader/vss_card_reader.dart';
import 'package:vss_global_constant/global_constant.dart';
import 'package:vss_ivt_api/api_consumer.dart';
import 'package:vss_ivt_api/api_result_model.dart';
import 'package:vss_locale/language_store.dart';
import 'package:vss_message_util/message_util.dart';
import 'package:vss_navigator/navigator.dart';

import 'l10n/translate.dart';
import 'model/fare_policy_model.dart';
import 'model/ticket_sell_model.dart';
import 'model/trip_seat_model.dart';
import 'qr_scanner.dart';

class VtxSeatScreen extends StatefulWidget {
  const VtxSeatScreen({super.key});

  @override
  State<VtxSeatScreen> createState() => _VtxSeatScreenState();
}

class _VtxSeatScreenState extends State<VtxSeatScreen> {
  String? tripId;
  String? ticketTypeId;
  final FocusNode focusNode = FocusNode();
  FarePolicyModel? ticketTypeData;
  List<TripSeatModel> seatData = <TripSeatModel>[];
  List<FarePolicyModel> farePolicyList = <FarePolicyModel>[];
  String? seatGroupId;
  String? ticketTypeCode;
  TicketSellModel? ticketSellModel;
  TicketSellModel? ticketSell;
  bool isResetSeatModel = true;
  bool isCallApi = false;
  final String screenLink = '/tva_vtx_ticket/VtxSeatScreen';
  final NumberFormat currencyFormat = NumberFormat.currency(
      locale: LanguageStore.localeSelected.languageCode,
      symbol: 'đ',
      decimalDigits: 0);
  List<SeatModel> currentSeatsState = <SeatModel>[];

  int rowCount = 0;
  int colCount = 5;
  int thanhTien = 0;
  int giaGhe = 0;
  bool tap = false;
  String serviceCode = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late bool formSubmitting = false;
  final ValueNotifier<bool> submitNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> submitNotifierStart = ValueNotifier<bool>(false);
  // List<FarePolicyModel> farePolicyList = <FarePolicyModel>[];
  List<FarePolicyModel> result = <FarePolicyModel>[];
  List<TicketSellModel> resultTicketSellModel = <TicketSellModel>[];


  List<SeatModel> selectedSeats = [];

  // @override
  // void initState() {
  //   getTripSeat();
  //   getFarePolicy();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic> argument =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      tripId = argument['tripid'] ?? '';
      ticketTypeData = argument.containsKey('ticketTypeData')
          ? FarePolicyModel.fromJson(argument['ticketTypeData'])
          : null;
    }
    if (isCallApi == false) {
      getTripSeat();
      getFarePolicy();
      isCallApi = true;
    }
    int soGhe = selectedSeats.length;

    initSeatState();
    
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Translate translate = lookupTranslate(LanguageStore.localeSelected);
    return Scaffold(
      appBar: txeAppBar(
        title: translate.chonGhe,
        screenLink: screenLink,
        forceTitle: translate.chonGhe,
      ),
      body: Column(
        children: [
          if (!tap)
            CardReaderScreen(
              option: 2,
              // cosBackendDomain: BackendDomain.bus,
              nfcReaderResultDataCallback:
              nfcReaderResultDataCallback,
            )
          else
            Container(),
          Expanded(
            child:SingleChildScrollView(
              child: Container(
                // padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    GlobalConstant.colDivider,
                    if (seatData.length > 0) SizedBox(
                      width: double.maxFinite,
                      child: SeatLayoutWidget(
                        onSeatStateChanged: (SeatModel seatModel) {
                          ScaffoldMessenger.of(context)
                              .hideCurrentSnackBar();
                          if (seatModel.seatState ==
                              SeatState.selected) {
                            // setState(() {
                              selectedSeats.add(seatModel);
                            // });
                            Totalamount();
                            setState(() {});
                          } else {
                            selectedSeats = selectedSeats
                                .where((SeatModel element) =>
                                    element.valueMemberSeat !=
                                    seatModel.valueMemberSeat)
                                .toList();
                            Totalamount();
                            setState(() {});
                          }
                        },
                        stateModel: SeatLayoutStateModel(
                          pathDisabledSeat:
                              'assets/images/bookseat/disabled_seat.png',
                          pathSelectedSeat:
                              'assets/images/bookseat/selected_seats.png',
                          pathSoldSeat:
                              'assets/images/bookseat/sold_seat.png',
                          pathUnSelectedSeat:
                              'assets/images/bookseat/unselected_seat.png',
                          cols: colCount,
                          seatSvgSize: 64,
                          isDisplayWithGroup : true,
                          currentSeatsState: currentSeatsState,
                        ),
                      ),
                    ) else Column(
                          children: [
                            GlobalConstant.colDivider,
                            Center(
                              child: CircularProgressIndicator(
                                color:
                                colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                  ],
                )
              ), 
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: <Widget>[
                GlobalConstant.colDivider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // GlobalConstant.rowDivider,
                    buildInkWell(
                        0xFF4B93B2, translate.daBan, 0xFF4B93B2),
                    buildInkWell(
                       0xFFAFAFA , translate.choCon, 0xFF148214),
                    buildInkWell(
                        0xFF148214, translate.dangChon, 0xFF148214),
                    // buildInkWell(
                    //     0xFF9E9E9E, translate.chuMoBan, 0xFF9E9E9E),
                  ],
                ),
                GlobalConstant.colDivider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(translate.soGhe),
                    Text('${selectedSeats.length}'),
                  ],
                ),
                GlobalConstant.rowDivider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(translate.soTien),
                    // Text(
                    //     '${currencyFormat.format(ticketTypeData!.fare! * selectedSeats.length)}'),
                    Text(currencyFormat.format(thanhTien))
                  ],
                ),
                GlobalConstant.colDivider,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: submitNotifierStart,
                        builder: (BuildContext context, bool val, Widget? child) {
                          return FilledButton(
                              onPressed: () async {
                                final String? cardService = await popUpPage<String>(
                                    TxaQrScannerScreen(
                                      option: 1,
                                    ),
                                    context);
                                if (cardService != null) {
                                  final String serviceCode = cardService;
                                  nfcReaderResultDataCallback(serviceCode);
                                }
                              },
                              child: !tap
                              ? Text(translate.qrthe)
                              : CircularProgressIndicator(
                                  color:
                                      colorScheme.onPrimary,
                                ),);
                        },
                      ),
                    ),
                    GlobalConstant.rowDivider,
                    Expanded(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ValueListenableBuilder(
                          valueListenable: submitNotifierStart,
                          builder: (BuildContext context, bool val, Widget? child) {
                            return FilledButton(
                                onPressed: () async {
                                  if (tap) {
                                    return;
                                  }
                                  setState(() {
                                    tap = true;
                                    submitNotifier.value = true;
                                  });
                                  final ApiResultModel apiFarePolicyModel =
                                      await ApiConsumer.dotNetCoreApi.get(
                                          '${BackendDomain.vtx}${VtxUri.api_VtxFarePolicy_GetByTrip}',
                                          param: <String, String>{
                                        'ApiData.TripId': tripId!,
                                      });
                                  if (apiFarePolicyModel.Data != null) {
                                    result = (apiFarePolicyModel.Data as List)
                                        .map((e) => FarePolicyModel.fromJson(
                                            e as Map<String, dynamic>))
                                        .toList()
                                        .where((FarePolicyModel element) =>
                                            element.seatGroupId == ticketTypeData!.seatGroupId &&
                                            element.ticketTypeCode == ticketTypeData!.ticketTypeCode)
                                        .toList();
                                  }
                                  // farePolicyModel = result.toList().first;
                                  final seatId = selectedSeats
                                      .map(
                                        (e) => e.valueMemberSeat,
                                      )
                                      .toList();
                                  var tickets = [];
                                  for (var seat in seatId) {
                                    tickets.add({
                                      'seatId': seat,
                                      'ticketTypeId': ticketTypeData!.ticketTypeId
                                    });
                                  }
                                  final Map<String, dynamic> param = {
                                    'ApiData': {
                                      'tripId': ticketTypeData!.tripId,
                                      'transFormType': 1,
                                      'serviceCode': '',
                                      'seats': tickets
                                    }
                                  };
                                  final ApiResultModel apiTicketSell =
                                      await ApiConsumer.dotNetApi.post(
                                          '${BackendDomain.vtx}${VtxUri.api_VtxTrip_TicketSell}',
                                          body: param);
                                  setState(() {
                                    tap = false;
                                    submitNotifier.value = false;
                                  });
                                  if (apiTicketSell.Data != null) {
                                    ticketSellModel = TicketSellModel.fromJson(apiTicketSell.Data);
                                    // for (int i = 0; i < apiTicketSell.Data['tickets'].length; i++)
                                      int i = 0;
                                      ticketSell = TicketSellModel.fromJson(apiTicketSell.Data['tickets'][i]);
                                      print('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm${apiTicketSell.Data['tickets'][i]}');
          
                                      if(selectedSeats.length > 1){
                                        // print("<<<<<<<<<<<<<<<<<<<<<<<<<<<object>>>>>>>>>>>>>>>>>>>>>>>>>>>${apiTicketSell.Data['tickets'][i]['qrCode']}");
                                        PosIntegrate.print(ticketSell!.toJson(),ticketSellModel!.lineName);
                                        print('innnnnnnnnnnnnn${i}');
                                        showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            final TextTheme textTheme = Theme.of(context).textTheme;
                                            final ColorScheme colorScheme = Theme.of(context).colorScheme;
                                            return Container(
                                              height: 200,
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    translate.inVe,
                                                    style: textTheme.titleLarge!.copyWith(
                                                      color: colorScheme.primary,
                                                    ),
                                                  ),
                                                  GlobalConstant.colDivider,
                                                  GlobalConstant.colDivider,
                                                  GlobalConstant.colDivider,
                                                  GlobalConstant.colDivider,
                                                  GlobalConstant.colDivider,
                                                  GlobalConstant.colDivider,
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: FilledButton(
                                                      child: Text(translate.inVe),
                                                      onPressed: () {
                                                        i++;
                                                        ticketSell = TicketSellModel.fromJson(apiTicketSell.Data['tickets'][i]);
                                                        if(i < apiTicketSell.Data['tickets'].length){

                                                          if(i == apiTicketSell.Data['tickets'].length -1){
                                                            Navigator.pop(context);
                                                            Navigator.pop(context);
                                                            // print("<<<<<<<<<<<<<<<<<<<<<<<<<<<eeeeee>>>>>>>>>>>>>>>>>>>>>>>>>>>${apiTicketSell.Data['tickets'][i]['qrCode']}456"); 
                                                            PosIntegrate.print(ticketSell!.toJson(),ticketSellModel!.lineName);
                                                          }else{
                                                            // print("<<<<<<<<<<<<<<<<<<<<<<<<<<<eeeeee>>>>>>>>>>>>>>>>>>>>>>>>>>>${apiTicketSell.Data['tickets'][i]['qrCode']}");
                                                            // print('innnnnnnnnnnnnn${apiTicketSell.Data['tickets'][i]['qrCode']}');
                                                            PosIntegrate.print(ticketSell!.toJson(),ticketSellModel!.lineName);
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        );
                                      } else {
                                        PosIntegrate.print(ticketSell!.toJson(),ticketSellModel!.lineName);
                                        Navigator.pop(context);
                                      }  
                                    
                                    MessageUtil.snackbar(context,
                                        message: translate.thanhCong, success: true);
                                    // print('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm${apiTicketSell.Data['tickets'].length}');
                                    // final seatId = apiTicketSell.Data
                                    //   .map(
                                    //     (e) => e.qrCode,
                                    //   )
                                    //   .toList();
                                    //   print(seatId);
                                    // Navigator.pop(context);
                                  } else {
                                    MessageUtil.snackbar(context,
                                        message: apiTicketSell.getMessage() ?? '',
                                        success: false);
                                  }
                                },
                                child: !tap
                                ? Text(translate.tienMat)
                                : CircularProgressIndicator(
                                    color:
                                        colorScheme.onPrimary,
                                ),);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                GlobalConstant.colDivider,
              ],
            ),
          ),
        ],
      )
    );
  }

  void initSeatState() {
    currentSeatsState = <SeatModel>[];
    seatData.forEach((element) {
      currentSeatsState.add(SeatModel(
          seatState: element.status == 1
                  ? SeatState.unselected
              : SeatState.sold,
          seatGroupFare: convertMoney(element.seatGroupId) ?? 0,
          displayNameSeat: element.seatCode.toString(),
          valueMemberSeat: element.seatId,
          seatGroupId: element.seatGroupId,
          seatGroupName: element.seatGroupName.toString()));
    });
  }

  convertMoney(String? value) {
    int? money;
    for (int i = 0; i < farePolicyList.length; i++) {
      print(farePolicyList[i].seatGroupId == value &&
          farePolicyList[i].ticketTypeId == ticketTypeData?.ticketTypeId);
      print('value:${value}');
      if (farePolicyList[i].seatGroupId == value &&
          farePolicyList[i].ticketTypeId == ticketTypeData?.ticketTypeId) {
        money = farePolicyList[i]!.fare!;
        // '${(farePolicyList[i]!.fare!.toString()).substring(0, (farePolicyList[i]!.fare!.toString()).length - 3)}k';
        return money;
      }
    }
    // Tongtien = Tongtien + result!.fare!;
  }

  void Totalamount() {
   int Tongtien = 0 ;
    for (int i = 0; i < selectedSeats.length; i++) {
     final String value = selectedSeats[i].seatGroupId;
     for(int i=0; i<farePolicyList.length;i++){
       if(farePolicyList[i].seatGroupId == value && farePolicyList[i].ticketTypeId==ticketTypeData?.ticketTypeId){
         Tongtien = Tongtien + farePolicyList[i].fare!;
       }
     }
    }
    // setState(() {
      thanhTien = Tongtien;
    // });
  }

  Future<List<TripSeatModel>?> getTripSeat() async {
    List<TripSeatModel> result = <TripSeatModel>[];
    final ApiResultModel apiResultModel = await ApiConsumer.dotNetCoreApi.get(
        '${BackendDomain.vtx}${VtxUri.api_VtxTripSeat_GetByTrip}',
        param: <String, String>{
          'ApiData.TripId': tripId ?? '',
        });
    if (apiResultModel.Data != null) {
      result = (apiResultModel.Data as List)
        .map((e) => TripSeatModel.fromJson(e as Map<String, dynamic>))
        // .toList()
        // .where((TripSeatModel element) =>
        //     element.seatGroupId == ticketTypeData?.seatGroupId)
        .toList();
    }
    setState(() {
      seatData = result;
    });
  }

  Future<void> getFarePolicy() async {
    print(tripId);
    final ApiResultModel apiResultModel = await ApiConsumer.dotNetCoreApi.get(
        '${BackendDomain.vtx}${VtxUri.api_VtxFarePolicy_GetByTrip}',
        param: <String, String>{
          'ApiData.TripId': tripId ?? '',
        });
    if (apiResultModel.Data != null) {
      farePolicyList = (apiResultModel.Data as List)
          .map((e) => FarePolicyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    // setState(() {
    //   farePolicyDropdownValue = farePolicyList.first;
    // });
  }

  buildInkWell(int color, String name, int colorBorder) {
    return InkWell(
      child: Row(children: <Widget>[
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: Color(color),
            border: Border.all(width: 1, color: Color(colorBorder)),
          ),
        ),
        GlobalConstant.rowDivider,
        Text(
          name,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ]),
      onTap: () async {},
    );
  }

  Future<void> nfcReaderResultDataCallback(String serviceCode) async {
    print("<<<<<<<<<<<<<<<<<<<<object>>>>>>>>>>>>>>>>>>>>");
    final Translate translate = lookupTranslate(LanguageStore.localeSelected);
    if (tap) {
      return;
    }
    setState(() {
      tap = true;
      submitNotifier.value = true;
    });

    final ApiResultModel apiResultModel = await ApiConsumer.dotNetCoreApi.get(
        '${BackendDomain.vtx}${VtxUri.api_VtxFarePolicy_GetByTrip}',
        param: <String, String>{
          'ApiData.TripId': tripId!,
        });
    if (apiResultModel.Data != null) {
      result = (apiResultModel.Data as List)
          .map((e) => FarePolicyModel.fromJson(e as Map<String, dynamic>))
          .toList()
          .where((FarePolicyModel element) =>
              element.seatGroupId == ticketTypeData!.seatGroupId &&
              element.ticketTypeCode == ticketTypeData!.ticketTypeCode)
          .toList();
    }
    // farePolicyModel = result.toList().first;

    if (serviceCode.isNotEmpty) {
      final seatId = selectedSeats
      .map(
        (e) => e.valueMemberSeat,
      )
      .toList();
      var tickets = [];
      for (var seat in seatId) {
        tickets.add(
            {'seatId': seat, 'ticketTypeId': ticketTypeData!.ticketTypeId});
      }

      final Map<String, dynamic> param = {
        'ApiData': {
          'tripId': ticketTypeData!.tripId,
          'transFormType': 2,
          'serviceCode': serviceCode,
          'seats': tickets,
        }
      };
      final ApiResultModel apiResultModel = await ApiConsumer.dotNetApi.post(
          '${BackendDomain.vtx}${VtxUri.api_VtxTrip_TicketSell}',
          body: param);

      if (apiResultModel.Data != null) {
       ticketSellModel = TicketSellModel.fromJson(apiResultModel.Data);
       int i = 0;
        ticketSell = TicketSellModel.fromJson(apiResultModel.Data['tickets'][i]);
        print('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm${apiResultModel.Data['tickets'][i]}');

        if(selectedSeats.length > 1){
          // print("<<<<<<<<<<<<<<<<<<<<<<<<<<<eeeeee>>>>>>>>>>>>>>>>>>>>>>>>>>>${apiResultModel.Data['tickets'][i]['qrCode']}");
          PosIntegrate.print(ticketSell!.toJson(),ticketSellModel!.lineName);
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              final TextTheme textTheme = Theme.of(context).textTheme;
              final ColorScheme colorScheme = Theme.of(context).colorScheme;
              return Container(
                height: 200,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      translate.inVe,
                      style: textTheme.titleLarge!.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    GlobalConstant.colDivider,
                    GlobalConstant.colDivider,
                    GlobalConstant.colDivider,
                    GlobalConstant.colDivider,
                    GlobalConstant.colDivider,
                    GlobalConstant.colDivider,
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        child: Text(translate.inVe),
                        onPressed: () {
                          i++;
                          ticketSell = TicketSellModel.fromJson(apiResultModel.Data['tickets'][i]);
                          if(i < apiResultModel.Data['tickets'].length){

                            if(i == apiResultModel.Data['tickets'].length -1){
                              Navigator.pop(context);
                              Navigator.pop(context);
                              // print("<<<<<<<<<<<<<<<<<<<<<<<<<<<eeeeee>>>>>>>>>>>>>>>>>>>>>>>>>>>${apiTicketSell.Data['tickets'][i]['qrCode']}456"); 
                              PosIntegrate.print(ticketSell!.toJson(),ticketSellModel!.lineName);
                            }else{
                              // print("<<<<<<<<<<<<<<<<<<<<<<<<<<<eeeeee>>>>>>>>>>>>>>>>>>>>>>>>>>>${apiTicketSell.Data['tickets'][i]['qrCode']}");
                              // print('innnnnnnnnnnnnn${apiTicketSell.Data['tickets'][i]['qrCode']}');
                              PosIntegrate.print(ticketSell!.toJson(),ticketSellModel!.lineName);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          );
        } else {
          Navigator.pop(context);
          PosIntegrate.print(ticketSell!.toJson(),ticketSellModel!.lineName);
        }  
      } else {
        MessageUtil.snackbar(context,
            message: apiResultModel.getMessage() ?? '', success: false);
      }
    } else {
      MessageUtil.snackbar(context, message: translate.thatBai, success: false);
    }
    setState(() {
      tap = false;
      submitNotifier.value = false;
    });
  }

}