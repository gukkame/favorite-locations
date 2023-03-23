import 'package:flutter/material.dart';
import 'package:map_markers/modules/colors.dart';

import '../navigation.dart';

class BottomNavBar extends StatefulWidget {
  late int index;
  BottomNavBar({super.key, required this.index});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  //New
  late int _selectedIndex;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        navigate(context, "/");
        break;
      case 1:
        navigate(context, "/fav");
        break;
      case 2:
        navigate(context, "/info");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _selectedIndex = widget.index;
    return BottomNavigationBar(
      currentIndex: _selectedIndex, //New
      type: BottomNavigationBarType.shifting,
      selectedFontSize: 20,
      selectedIconTheme: IconThemeData(color: primeColor),
      selectedItemColor: primeColor,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'About',
        ),
      ],
      onTap: _onItemTapped,
    );
  }
}
