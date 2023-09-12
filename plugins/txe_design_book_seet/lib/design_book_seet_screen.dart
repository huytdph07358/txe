import 'package:flutter/material.dart';

import 'package:txe_app_bar/vxb_app_bar.dart';
import 'package:txe_backend_domain/backend_domain.dart';
import 'package:txe_uri/vtx_uri.dart';
import 'package:vss_book_seat/vss_book_seat.dart';
import 'package:vss_global_constant/global_constant.dart';
import 'package:vss_ivt_api/api_consumer.dart';
import 'package:vss_ivt_api/api_result_model.dart';


import 'l10n/translate.dart';
import 'model/trip_seat_model.dart';




class DesignBookSeetScreen extends StatefulWidget {
  const DesignBookSeetScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DesignBookSeetScreenState() ;

}

class _DesignBookSeetScreenState extends State<DesignBookSeetScreen> {
  String? tripId;
  List<TripSeatModel> seatData = <TripSeatModel>[];
  List<SeatModel> currentSeatsState = <SeatModel>[];
  List<SeatModel> selectedSeats = [];
  int rowCount = 0;
  int colCount = 5;
  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic> argument =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      tripId = argument['tripId'] ?? '';
    }
    return Scaffold(
      appBar: txeAppBar(
        screenLink: '/txe_design_book_seet/DesignBookSeetScreen',
        title: 'Thiết kế sơ đồ ghế',
      ),
      body: Column(
        children: [
          Expanded(
            child:SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              setState(() {});
                            } else {
                              selectedSeats = selectedSeats
                                  .where((SeatModel element) =>
                              element.valueMemberSeat !=
                                  seatModel.valueMemberSeat)
                                  .toList();
                              setState(() {});
                            }
                          },
                          stateModel: SeatLayoutStateModel(
                            pathDisabledSeat:
                            'assets/images/bookseat/svg_disabled_bus_seat.svg',
                            pathSelectedSeat:
                            'assets/images/bookseat/svg_selected_bus_seats.svg',
                            pathSoldSeat:
                            'assets/images/bookseat/svg_sold_bus_seat.svg',
                            pathUnSelectedSeat:
                            'assets/images/bookseat/svg_unselected_bus_seat.svg',
                            cols: colCount,
                            seatSvgSize: 58,
                            currentSeatsState: currentSeatsState,
                          ),
                        ),
                      ) else Column(
                        children: [
                          GlobalConstant.colDivider,
                          Center(
                            child: Text(
                              'Đang cập nhật',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
              ),
            ),
          ),
        ],
      ),
    );
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
}
