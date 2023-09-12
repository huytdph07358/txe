import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:vss_global_constant/global_constant.dart';
import 'package:vss_ivt_api/api_consumer.dart';
import 'package:vss_ivt_api/api_result_model.dart';
import 'package:vss_locale/language_store.dart';
import 'package:txe_app_bar/vxb_app_bar.dart';
import 'package:txe_backend_domain/backend_domain.dart';

import 'package:txe_uri/vtx_uri.dart';
import 'l10n/translate.dart';
import 'model/sold_ticket_model.dart';

class SoldTicketScreen extends StatefulWidget {
  const SoldTicketScreen({super.key});

  @override
  State<SoldTicketScreen> createState() => _SoldTicketScreenState();
}

class _SoldTicketScreenState extends State<SoldTicketScreen> {
  String? tripCode;
  final Translate translate = lookupTranslate(LanguageStore.localeSelected);
  final DateFormat dateFormatFull =
      DateFormat.yMd(LanguageStore.localeSelected.languageCode).add_Hm();
  final NumberFormat currencyFormat = NumberFormat.currency(
      locale: LanguageStore.localeSelected.languageCode,
      symbol: 'đ',
      decimalDigits: 0);
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchFive();
    controller.addListener(() {
      if(controller.position.pixels == controller.position.maxScrollExtent){
        fetchFive();
      }
    });
  }

  fetchFive(){
    for(int i  = 0; i < 10; i++){
      getSoldTicket();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic> argument =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      tripCode = argument['tripCode'] ?? '';
    }

    return Scaffold(
      appBar: txeAppBar(
        title: translate.veDaBan,
        screenLink: '/txe_ticketsale/SoldTicketScreen',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(GlobalConstant.paddingMarginLength),
          child: Column(
            children: [
              FutureBuilder<List<SoldTicketModel>?>(
                future: getSoldTicket(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<SoldTicketModel>?> snapshot) {
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
                        controller: controller,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                        itemCount: snapshot.data!.length ,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(snapshot.data![index].seatCode ?? ''),
                              ],
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(dateFormatFull.format(snapshot.data![index]
                                    .getDateTimeExportTime()!)),
                                Text(snapshot.data![index].ticketTypeName ?? ''),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(currencyFormat
                                    .format(snapshot.data![index].fare)),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      child = Center(
                        child: Text(translate.banChuaMuaVeNao),
                      );
                    }
                  } else {
                    child = const Center(child: CircularProgressIndicator());
                  }
                  return child;
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<SoldTicketModel>?> getSoldTicket() async {
    List<SoldTicketModel> result = <SoldTicketModel>[];
    final now = DateTime.now();
    var formatterDate = DateFormat('yyyyMMdd000000');
    String actualDate = formatterDate.format(now);

    final ApiResultModel apiResultModel = await ApiConsumer.dotNetCoreApi.get(
      '${BackendDomain.vtx}${VtxUri.api_VtxTicket_Get}',
      param: <String, String>{
          'ApiData.ExportDateTo': actualDate,
          'ApiData.ExportDateFrom': actualDate,
        }
    );

    if (apiResultModel.Data != null) {
      result = (apiResultModel.Data as List)
          .map((e) => SoldTicketModel.fromJson(e as Map<String, dynamic>))
          .toList();
      result.sort((SoldTicketModel a, SoldTicketModel b) =>
          b.exportTime!.compareTo(a.exportTime!));
    }
    return result.isNotEmpty ? result : null;
  }
}
