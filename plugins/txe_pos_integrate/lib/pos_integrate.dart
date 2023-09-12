import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';
import 'package:vss_locale/language_store.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PosIntegrate {
  static Future<bool> init() async {
    const MethodChannel channel = MethodChannel('txe_pos_integrate');
    channel.setMethodCallHandler(_methodCallHandler);
    String deviceInfo = '';
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (kIsWeb) {
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidDeviceInfo deviceData = await deviceInfoPlugin.androidInfo;
      deviceInfo = deviceData.brand; //Aisino
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {}

    final Map<String, Object> argInput = {
      'listenerId': 0,
      'deviceInfo': deviceInfo,
    };
    await channel.invokeMethod('init', argInput);
    return true;
  }

  static Future<bool> logon() async {
    const MethodChannel channel = MethodChannel('txe_pos_integrate');
    channel.setMethodCallHandler(_methodCallHandler);

    final Map<String, Object> argInput = {
      'listenerId': 0,
    };
    //await channel.invokeMethod('logon', argInput);
    return true;
  }

  static Future<bool> payment() async {
    const MethodChannel channel = MethodChannel('txe_pos_integrate');
    channel.setMethodCallHandler(_methodCallHandler);
    final Map<String, Object> argInput = {
      'listenerId': 0,
      'amount': 50000,
      'printOption': 0,
      'extraData': 'test payment',
    };

    await channel.invokeMethod('payment', argInput);
    return true;
  }

  static Future<bool> print(Map<String, dynamic> json, String? lineName ) async {
    // await payment(); //TODO
    final DateFormat dateFormat =
        DateFormat.yMd(LanguageStore.localeSelected.languageCode);
    final DateFormat dateHouse =
        DateFormat.Hm(LanguageStore.localeSelected.languageCode);
    final NumberFormat currencyFormat = NumberFormat.currency(
        locale: LanguageStore.localeSelected.languageCode,
        symbol: '',
        decimalDigits: 0);
    const MethodChannel channel = MethodChannel('txe_pos_integrate');
    channel.setMethodCallHandler(_methodCallHandler);
    final Map<String, Object> argInput = {
      'listenerId': 0,
      'printOption': 0,
      'qrCode': json['qrCode'].toString(),
      'serialNumber': '0',
      'exportTime': dateFormat.format(DateTime.now()),
      'exportHour': dateHouse.format(DateTime.now()),
      'seatCode' : json['seatCode'].toString(),
      'price': currencyFormat.format(json['fare']).toString(),
      'licensePlate': 'licensePlate',
      'lineName': lineName.toString(),
    };

    await channel.invokeMethod('print', argInput);
    return true;
  }

  static Future<String?> readCard() async {
    String? cardData = '';
    const MethodChannel channel = MethodChannel('txe_pos_integrate');
    channel.setMethodCallHandler(_methodCallHandler);
    final Map<String, Object> argInput = {
      'listenerId': 0,
    };
    await channel.invokeMethod('readCard', argInput);
    return cardData;
  }

  static Future<String?> readSam() async {
    String? samData = '';
    const MethodChannel channel = MethodChannel('txe_pos_integrate');
    channel.setMethodCallHandler(_methodCallHandler);
    final Map<String, Object> argInput = {
      'listenerId': 0,
    };
    await channel.invokeMethod('readSam', argInput);
    return samData;
  }

  static Future<void> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'callBackListener':
        //_callbacksById[call.arguments['listenerId']]!(call.arguments['args']);
        break;
      default:
        log("TestFairy: Ignoring invoke from native. This normally shouldn't happen.");
    }
  }
}
