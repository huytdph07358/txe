import 'package:flutter/material.dart';
import 'package:txe_app_bar/vxb_app_bar.dart';
import 'package:txe_backend_domain/backend_domain.dart';
import 'package:vss_locale/language_store.dart';
import 'package:vss_qr_scanner/qr_scanner_screen.dart';

import 'l10n/translate.dart';

class TxaQrScannerScreen extends StatefulWidget {
  TxaQrScannerScreen({super.key, this.option});

  int? option;

  @override
  State<TxaQrScannerScreen> createState() => _TxaQrScannerScreenState();
}

class _TxaQrScannerScreenState extends State<TxaQrScannerScreen>
    with WidgetsBindingObserver {
  final String screenLink = '';

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final Translate translate = lookupTranslate(LanguageStore.localeSelected);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SafeArea(
        child: Scaffold(
      appBar: txeAppBar(
        title: 'Quét QR',
        screenLink: screenLink,
      ),
      body: buildBodyColumn(context, translate, textTheme, colorScheme),
    ));
  }

  Widget buildBodyColumn(BuildContext context, Translate translate,
    TextTheme textTheme, ColorScheme colorScheme) {
    return QrScannerScreen(
      cosBackendDomain: BackendDomain.cos,
      option: widget.option,
    );
  }
}
