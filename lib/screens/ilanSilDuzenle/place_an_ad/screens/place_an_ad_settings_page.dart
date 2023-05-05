import 'package:flutter/material.dart';

import '../../../../constant/app_bar_widget.dart';

class PlaceAnAdSettings extends StatefulWidget {
  const PlaceAnAdSettings({super.key});

  @override
  State<PlaceAnAdSettings> createState() => _PlaceAnAdSettingsState();
}

class _PlaceAnAdSettingsState extends State<PlaceAnAdSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appTitle: "İlan Düzenle"),
      body: Column(
        children: const [
          Text("data"),
        ],
      ),
    );
  }
}
