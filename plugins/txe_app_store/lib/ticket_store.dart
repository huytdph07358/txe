import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'model/bus_ticket_model.dart';
import 'sale_store.dart';

class TicketStore {
  static IOSOptions _getIOSOptions() => const IOSOptions(
        accountName: 'demo',
      );

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  static int _order = 0;

  static int get order {
    _order++;
    return _order;
  }

  static final List<BusTicketModel> _ticket = <BusTicketModel>[];
  static const String _ticketKey = 'txe_app_store.TicketStore._ticketKey';

  static Future<void> init() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? value = await storage.read(
        key: _ticketKey,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
    _ticket.clear();
    if (value != null) {
      _ticket.addAll((jsonDecode(value) as List)
          .map((e) => BusTicketModel.fromJson(e))
          .toList());
      _ticket.sort(
          (BusTicketModel a, BusTicketModel b) => a.order!.compareTo(b.order!));
      _order = _ticket.last.order!;
    }
  }

  static Future<void> addTicket({required BusTicketModel value}) async {
    _ticket.add(value);
    final String storageValue =
        jsonEncode(_ticket.map((BusTicketModel e) => e.toJson()).toList());
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.write(
      key: _ticketKey,
      value: storageValue,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  static List<BusTicketModel> getTicket() {
    return List<BusTicketModel>.from(
        _ticket); //clone ra list mới để không cho bên ngoài tự ý sửa dữ liệu trong danh sách
  }

  static Future<void> deleteTicket() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.delete(key: _ticketKey);
    _ticket.clear();
    _order = 0;
    SaleStore.setTripCode('');
    SaleStore.setSession('');
  }

  static int getTicketCount() {
    return _ticket.length;
  }
}
