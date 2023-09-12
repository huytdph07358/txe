import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:txe_line/line_screen.dart';
import 'package:txe_screen/all_screen.dart';
import 'package:vss_locale/language_store.dart';


import 'home_screen.dart';
import 'l10n/translate.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  final List<Widget> dashboardPage = <Widget>[
    const HomeScreen(),
    const LineScreen(),
    const AllScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: () async {
        bool? isChoiseQuit = await confirmQuit();
        return isChoiseQuit ?? false;
      },
      child: Scaffold(
        body: dashboardPage.elementAt(selectedIndex),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: colorScheme.primary,
          color: colorScheme.onPrimary,
          style: TabStyle.flip,
          items: const <TabItem<dynamic>>[
            TabItem(
              icon: Icons.home,
            ),
            TabItem(
              icon: Icons.directions_bus_outlined,
            ),
            // TabItem(
            //   icon: Icons.receipt_long_outlined,
            // ),
            // TabItem(
            //   icon: Icons.loyalty_outlined,
            // ),
            TabItem(
              icon: Icons.view_module_outlined,
            ),
          ],
          initialActiveIndex: 0,
          onTap: (int i) => {
            setState(() {
              selectedIndex = i;
            })
          },
        ),
      ),
    );
  }

  Future<bool> confirmQuit() async {
    final Translate translate = lookupTranslate(LanguageStore.localeSelected);
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              translate.xacNhan,
            ),
            content: Text(
              translate.banMuonTatPhanMem,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  finish(context);
                },
                child: Text(
                  translate.boQua,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                  translate.dongY,
                ),
              )
            ],
          );
        });
  }
}
