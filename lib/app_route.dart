import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/route_manager.dart';
import 'package:txe_change_password/change_password_screen.dart';
import 'package:txe_config/config_screen.dart';
import 'package:txe_dashboard/dashboard_screen.dart';
import 'package:txe_design_book_seet/design_book_seet_screen.dart';
import 'package:txe_environment_chooser/environment_chooser_screen.dart';
import 'package:txe_line/line_screen.dart';
import 'package:txe_login/login_screen.dart';
import 'package:txe_screen/all_screen.dart';
import 'package:txe_ticket_audit/ticket_audit_screen.dart';
import 'package:txe_ticket_sale/chair_diagram_screen.dart';
import 'package:txe_ticket_sale/multiSelect.dart';
import 'package:txe_ticket_sale/sold_ticket_screen.dart';
import 'package:txe_ticket_sale/ticket_sale_screen.dart';
import 'package:txe_trip/detail_trip_screen.dart';
import 'package:txe_trip/trip_screen.dart';

class AppRoute {
  static List<GetPage<dynamic>> initializeRoute() {
    return [
      GetPage(
        name: '/',
        page: () => const LoginScreen(),
      ),
      GetPage(
        name: '/txe_login/LoginScreen()',
        page: () => const LoginScreen(),
      ),
      GetPage(
        name: '/txe_line/LineScreen()',
        page: () => const LineScreen(),
      ),
      GetPage(
        name: '/txe_screen/AllScreen()',
        page: () => const AllScreen(),
      ),
      GetPage(
        name: '/txe_change_password/ChangePasswordScreen',
        page: () => const ChangePasswordScreen(),
      ),
      GetPage(
        name: '/txe_config/ConfigScreen',
        page: () => const ConfigScreen(),
      ),
      GetPage(
        name: '/txe_environment_chooser/EnvironmentChooserScreen',
        page: () => const EnvironmentChooserScreen(),
      ),
      GetPage(
        name: '/txe_dashboard/DashboardScreen',
        page: () => const DashboardScreen(),
      ),
      GetPage(
        name: '/txe_line/LineScreen',
        page: () => const LineScreen(),
      ),
      GetPage(
        name: '/txe_trip/TripScreen',
        page: () => const TripScreen(),
      ),
      GetPage(
        name: '/txe_trip/DetailTripScreen',
        page: () => const DetailTripScreen(),
      ),
      GetPage(
        name: '/txe_ticket_sale/TicketSaleScreen',
        page: () => const TicketSaleScreen(),
      ),
      GetPage(
        name: '/txe_ticket_sale/ChairDiagramScreen',
        page: () => const ChairDiagramScreen(),
      ),
      GetPage(
        name: '/txe_ticket_sale/SoldTicketScreen',
        page: () => const SoldTicketScreen(),
      ),
      GetPage(
        name: '/tva_vtx_ticket/VtxSeatScreen',
        page: () => const VtxSeatScreen(),
      ),
      GetPage(
        name: '/txe_ticket_audit/TicketAudit',
        page: () => const TicketAuditScreen(),
      ),
      GetPage(
        name: '/txe_design_book_seet/DesignBookSeetScreen',
        page: () => const DesignBookSeetScreen(),
      ),
    ];
  }
}
