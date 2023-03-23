import 'package:flutter/material.dart';

import '../modules/colors.dart';

class NavBar extends StatelessWidget implements PreferredSize {
  @override
  final Size preferredSize;
  static const padding = 10;
  const NavBar({super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight + padding);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: kToolbarHeight + padding,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: primeGradient,
            ),
          ),
          title: const Text(
            "Map Marker",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            textAlign: TextAlign.center,
          ),
          shadowColor: Colors.transparent,
        ));
  }

  @override
  Widget get child => Container();
}
