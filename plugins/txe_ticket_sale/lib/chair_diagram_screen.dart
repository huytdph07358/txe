import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:txe_app_bar/vxb_app_bar.dart';
import 'package:txe_app_store/login_store.dart';
import 'package:txe_backend_domain/backend_domain.dart';
import 'package:txe_uri/vtx_uri.dart';
import 'package:vss_cache_network_image/vss_cache_network_image.dart';
import 'package:vss_ivt_api/api_consumer.dart';
import 'package:vss_ivt_api/api_result_model.dart';
import 'package:vss_locale/language_store.dart';

import 'l10n/translate.dart';
import 'model/seat_mapImg_model.dart';


class ChairDiagramScreen extends StatefulWidget {
  const ChairDiagramScreen({
      super.key, this.vehicleId,
    });
  final String? vehicleId;
  @override
  State<StatefulWidget> createState() {
    return _ChairDiagramScreenState();
  }
}

class _ChairDiagramScreenState extends State<ChairDiagramScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<SeatMapImageModel> result = <SeatMapImageModel>[];
  SeatMapImageModel? seatMapImageModel;
  String? vehicleId;
  final String screenLink = '/txe_ticket_sale/ChairDiagramScreen';

  @override
  void initState() {
    super.initState();
  }
  vehicleIds() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, String> argument =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      vehicleId = argument['vehicleId'] ?? '';
    }
    return vehicleId.toString();
  }
  @override
   Widget build(BuildContext context) {
    final Translate translate = lookupTranslate(LanguageStore.localeSelected);
    getSeatMapImage();
    String? uriAvatarImage = '';
    print('111111111111111111111111111${widget.vehicleId}');
    return Scaffold(
      appBar: txeAppBar(
        screenLink: screenLink,
        title: translate.soDoGhe,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                enableInfiniteScroll: result.length == 1 ? false : true,
                height: MediaQuery.of(context).size.height,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }
              ),
              items: result
              .map((SeatMapImageModel value) {
                uriAvatarImage = "${BackendDomain.fss}${value.url?.replaceAll(r"\\", "/").replaceAll(r"\", "/")}";
              return Center(child:cacheNetworkImageComponent(
                uriAvatarImage,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width ,
                // holderImage: 'assets/images/not_avatar.jpg',
              ));
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: result.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            )
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     ...Iterable<int>.generate(result.length).map(
          //       (int pageIndex) => Flexible(
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          //           child: ElevatedButton(
          //             onPressed: () => _controller.animateToPage(pageIndex),
          //             child: Text('${pageIndex + 1}'),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
  
  


  Future<void> getSeatMapImage() async {
    final ApiResultModel apiResultModel = await ApiConsumer.dotNetCoreApi.get(
        '${BackendDomain.vtx}${VtxUri.api_VtxVehicle_GetSeatMapImg}',
         param: <String, String>{
          'ApiData.VehicleId': vehicleIds(),
        }
        );
        print('?>?>?>?>?>?>?>?>>>>>>>>>>>>${apiResultModel.Data}');
    if (apiResultModel.Data != null) {
      result = (apiResultModel.Data as List)
          .map((element) =>
              SeatMapImageModel.fromJson(element as Map<String, dynamic>))
          .toList();
    }
    setState(() {
      seatMapImageModel = result.first;
    });
  }
}
