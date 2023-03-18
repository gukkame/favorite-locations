import 'package:flutter/material.dart';
import 'package:map_markers/modules/navigate.dart';

import '../modules/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSize {
  @override
  final Size preferredSize;
  final String title;
  static const padding = 10;

  const CustomAppBar({Key? key, required this.title})
      : preferredSize = const Size.fromHeight(kToolbarHeight + padding),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: AppBar(
          toolbarHeight: kToolbarHeight + padding,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: primeGradient,
            ),
          ),
          actions: const [DropDown()],
          title: Text(
            title,
            style: const TextStyle(
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

class DropDown extends StatelessWidget {
  const DropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case "Home":
            navigate(context, "/");
            break;
          case "About":
            navigate(context, "/info");
            break;
          case "Favorites":
            navigate(context, "/fav");
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: "Home",
            child: MenuContext(title: "Home", icon: Icons.home)),
          const PopupMenuItem(
            value: "Favorites",
            child: MenuContext(title: "Favorites", icon: Icons.favorite)),
          const PopupMenuItem(
            value: "About",
            child: MenuContext(title: "About", icon: Icons.group)),
        ];
      },
      offset: const Offset(0, kToolbarHeight),
      icon: Icon(
        Icons.menu,
        color: primeColor.withOpacity(0.7),
      ),
    );
  }
}

class MenuContext extends StatelessWidget {
  final String title;
  final IconData icon;

  const MenuContext({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          icon,
          color: primeColor,
        ),
        Text(
          title,
          style:
              const TextStyle(color: primeColor, fontWeight: FontWeight.w700),
        )
      ],
    );
  }
}
