import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:txe_app_store/login_store.dart';

import 'package:vss_global_constant/global_constant.dart';
import 'package:vss_ivt_api/api_consumer.dart';
import 'package:vss_ivt_api/api_result_model.dart';
import 'package:vss_locale/language_store.dart';
import 'package:txe_app_bar/vxb_app_bar.dart';
import 'package:txe_backend_domain/backend_domain.dart';
import 'package:txe_uri/vtx_uri.dart';
import 'model/trip_model.dart';
import 'l10n/translate.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  final String screenLink = '/txe_trip/TripScreen';
  String? lineCode;
  String? lineName;
  int? type = 1;
  DateTime today = DateTime.now();
  bool isSetMonth = false;
  DateTime month = DateTime.now();
  final DateFormat shortDateFormat =
      DateFormat.yMMM(LanguageStore.localeSelected.languageCode).add_jm();
  final DateFormat dateFormat =
      DateFormat.yMd(LanguageStore.localeSelected.languageCode);
  final NumberFormat currencyFormat = NumberFormat.currency(
      locale: LanguageStore.localeSelected.languageCode,
      symbol: 'đ',
      decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final Translate translate = lookupTranslate(LanguageStore.localeSelected);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, String> argument =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      lineName = argument['lineName'] ?? '';
      lineCode = argument['lineCode'] ?? '';
    };
    if (!isSetMonth) {
      setState(() {
        month = DateTime(today.year, today.month, today.day);
        isSetMonth = true;
      });
    };
    return Scaffold(
      appBar: txeAppBar(
        forceTitle: '${lineName}',
        screenLink: screenLink,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(GlobalConstant.paddingMarginLength),
            child: Column(
              children: [
                FutureBuilder<List<TripModel>?>(
                  future: getTrip(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TripModel>?> snapshot) {
                    Widget child;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      child = const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      child = Text(
                        snapshot.error.toString(),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        child = ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title:
                                  Text(snapshot.data![index].licensePlate ?? ''),
                              trailing: snapshot.data![index].departureTime !=
                                      null
                                  ? Text(
                                      '${snapshot.data![index].departureTime!.substring(0, 2).toString()}${translate.gio}${snapshot.data![index].departureTime!.substring(2, 4).toString()}')
                                  : Text(translate.chuaXacDinh),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/txe_trip/DetailTripScreen',
                                    arguments: <String, dynamic>{
                                      'TripData': snapshot.data![index].toJson()
                                    });
                              },
                            );
                          },
                        );
                      } else {
                        child = Center(
                          child: Text(translate.khongCoChuyenNao),
                        );
                      }
                    } else {
                      child = const Center(child: CircularProgressIndicator());
                    }
                    return child;
                  },
                ),
              ],
            )),
      ),
      bottomNavigationBar: Container(
        color: colorScheme.primary,
        padding: const EdgeInsets.symmetric(
            horizontal: GlobalConstant.paddingMarginLength),
        child: Row(
          children: <Widget>[
            IconButton(
                color: colorScheme.onPrimary,
                onPressed: () {
                  setState(() {
                    month = DateTime(month.year, month.month, month.day - 1);
                  });
                  // }
                },
                icon: const Icon(Icons.skip_previous_outlined)),
            GlobalConstant.rowDivider,
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    dateFormat.format(month),
                    style: textTheme.bodyMedium!.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            GlobalConstant.rowDivider,
            IconButton(
                color: colorScheme.onPrimary,
                onPressed: () {
                  setState(() {
                    month = DateTime(month.year, month.month, month.day + 1);
                  });
                  print(month.toString().replaceAll(RegExp(r'\D'), ''));
                },
                icon: const Icon(Icons.skip_next_outlined)),
          ],
        ),
      ),
    );
  }

  Future<List<TripModel>?> getTrip() async {
    List<TripModel> result = <TripModel>[];
    final monthConvert = month.toString().replaceAll(RegExp(r'\D'), '');
    final ApiResultModel apiResultModel = await ApiConsumer.dotNetCoreApi.get(
        '${BackendDomain.vtx}${VtxUri.api_VtxTrip_Get}',
        param: <String, String>{
          'ApiData.LineCode': lineCode!,
          'ApiData.DepartureDate': monthConvert.substring(0, 14),
          'ApiData.Type': type.toString() ?? '1',
        });
    print(' apiResultModel.Data : ${apiResultModel.Data}');
    if (apiResultModel.Data != null) {
      result = (apiResultModel.Data as List)
          .map((e) => TripModel.fromJson(e as Map<String, dynamic>))
          .toList();
      result.sort((TripModel a, TripModel b) =>
          a.departureTime!.compareTo(b.departureTime!));
    }
    return result.isNotEmpty ? result : null;
  }
}
