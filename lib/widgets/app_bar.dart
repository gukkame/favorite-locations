import 'package:flutter/material.dart';

import '../modules/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSize {
  @override
  final Size preferredSize;
  final String title;
  static const padding = 15;

  const CustomAppBar({Key? key, required this.title})
      : preferredSize = const Size.fromHeight(kToolbarHeight + padding),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: AppBar(
          toolbarHeight: kToolbarHeight + padding,
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23.0,
            ),
            textAlign: TextAlign.center,
          ),
          shadowColor: Colors.transparent,
        ));
  }

  @override
  Widget get child => Container();
}
