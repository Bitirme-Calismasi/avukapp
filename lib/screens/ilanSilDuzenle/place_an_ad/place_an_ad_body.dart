import 'package:flutter/material.dart';
import '../../../constant/app_bar_widget.dart';
import '../../../manager/navigator_manager.dart';
import '../../../widgets/my_custom_list_tile.dart';
import 'screens/place_an_ad_list_page.dart';
import 'screens/place_an_ad_page.dart';
import 'screens/place_an_ad_settings_page.dart';

class PlaceAnAdBody extends StatefulWidget {
  const PlaceAnAdBody({super.key});

  @override
  State<PlaceAnAdBody> createState() => _PlaceAnAdBodyState();
}

class _PlaceAnAdBodyState extends State<PlaceAnAdBody> {
  final String _editIcon = "assets/icons/profile_design.svg";
  final String _shareIcon = "assets/icons/share.svg";
  final String _listIcon = "assets/icons/list.svg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appTitle: "İlan Ayarları"),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Column(
          children: [
            GestureDetector(
              child: MyCustomListTileWidget(
                backgroundUrl: _shareIcon,
                titleName: "İlan Ver",
              ),
              onTap: () {
                NavigatorManager().navigatToWidget(
                  context,
                  const PlaceAnAdPage(),
                );
              },
            ),
            const SizedBox(height: 10),
            GestureDetector(
              child: MyCustomListTileWidget(
                backgroundUrl: _listIcon,
                titleName: "İlanlarım",
              ),
              onTap: () {
                NavigatorManager().navigatToWidget(
                  context,
                  const PlaceAnAdList(),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
