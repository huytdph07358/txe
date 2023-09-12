import 'package:flutter/material.dart';
import 'package:vss_global_constant/global_constant.dart';
import 'package:vss_ivt_api/api_consumer.dart';
import 'package:vss_ivt_api/api_result_model.dart';
import 'package:vss_locale/language_store.dart';
import 'package:txe_app_bar/vxb_app_bar.dart';
import 'package:txe_app_store/login_store.dart';
import 'package:txe_app_store/not_found_screen.dart';
import 'package:txe_app_store/screen_store.dart';
import 'package:txe_authorize/not_authorize.dart';
import 'package:txe_authorize/role_enum.dart';
import 'package:txe_authorize/role_store.dart';
import 'package:txe_backend_domain/backend_domain.dart';
import 'package:txe_uri/vtx_uri.dart';
import 'model/employee_model.dart';

import 'l10n/translate.dart';
import 'model/line_model.dart';

class LineScreen extends StatefulWidget {
  const LineScreen({super.key});

  @override
  State<LineScreen> createState() => _LineScreenState();
}

class _LineScreenState extends State<LineScreen> {
  final String screenLink = '/txe_line/LineScreen';

  @override
  Widget build(BuildContext context) {
    final Translate translate = lookupTranslate(LanguageStore.localeSelected);


    return Scaffold(
        appBar: txeAppBar(
          title: translate.tuyen,
          screenLink: screenLink,
        ),
        body: Container(
          padding: const EdgeInsets.all(GlobalConstant.paddingMarginLength),
          child: FutureBuilder<List<LineModel>?>(
            future: getLine(),
            builder: (BuildContext context,
                AsyncSnapshot<List<LineModel>?> snapshot) {
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
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(snapshot.data![index].lineName ?? ''),
                        subtitle: Text(snapshot.data![index].enterpriseName ?? ''),
                        onTap: () {
                          Navigator.pushNamed(context, '/txe_trip/TripScreen',
                              arguments: <String, String>{
                                'lineCode': snapshot.data![index].lineCode!,
                                'lineName': snapshot.data![index].lineName!
                              });
                        },
                      );
                    },
                  );
                } else {
                  child = Text(translate.longtext_khongCoTuyenNao,
                      textAlign: TextAlign.center);
                }
              } else {
                child = const Center(child: CircularProgressIndicator());
              }
              return child;
            },
          ),
        ));
  }

  Future<List<LineModel>?> getLine() async {
    List<LineModel> result = <LineModel>[];
    List<EmployeeModel> employee = <EmployeeModel>[];
    EmployeeModel employeeModel;
    print('<<<<<<<<<<<<<object>>>>>>>>>>>>>');
    final ApiResultModel apiEmployeeModel = await ApiConsumer.dotNetCoreApi.get(
        '${BackendDomain.vtx}${VtxUri.api_VtxEmployee_Get}',
      );
    employee = (apiEmployeeModel.Data as List)
        .map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>))
        .toList();
    employeeModel = employee.toList().first;
    final ApiResultModel apiResultModel = await ApiConsumer.dotNetCoreApi.get(
        '${BackendDomain.vtx}${VtxUri.api_VtxLine_Get}',
        param: <String, String>{
          'ApiData.EnterpriseId':'${employeeModel.enterpriseId}',
          }
        );
    if (apiResultModel.Data != null) {
      print('apiResultModel.Data getLine :${apiResultModel.Data}');
      result = (apiResultModel.Data as List)
          .map((e) => LineModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return result.isNotEmpty ? result : null;
  }
}
