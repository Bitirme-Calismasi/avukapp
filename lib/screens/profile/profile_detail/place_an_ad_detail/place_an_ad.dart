import 'package:avukapp/constant/constant.dart';
import 'package:flutter/material.dart';
import '../../../../constant/app_bar_widget.dart';
import '../../../ilanSilDuzenle/place_an_ad/place_an_ad_body.dart';

class PlaceAnAd extends StatelessWidget {
  const PlaceAnAd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appTitle: "İlan Ayarları"),
      body: Padding(
        padding: const PagePadding.symtcHrztNormal() +
            const EdgeInsets.only(top: 20),
        child: const PlaceAnAdBody(),
      ),
    );
  }
}
