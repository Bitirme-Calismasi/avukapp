import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constant.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key, required this.appTitle, this.backButtonIsActive = true});
  final String appTitle;
  final bool? backButtonIsActive;
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  // ignore: todo
  // TODO: implement preferredSize
  // ! Normalde kDefault olarak 56.0 ama bunu 70.0 yaptım
  Size get preferredSize => const Size.fromHeight(70.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.appTitle,
        style: GoogleFonts.cutiveMono(
          color: kCreamColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: kNavyBlueColor,
      titleTextStyle: const TextStyle(
        color: kCreamColor,
        fontSize: 18,
      ),
      leading: widget.backButtonIsActive == true
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 24,
              ),
              color: kCreamColor,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : const Text(''),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
    );
  }
}
