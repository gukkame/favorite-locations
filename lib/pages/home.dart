import 'package:flutter/material.dart';

import '../screen/map.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/nav_bar.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: MapScreen(),
      bottomNavigationBar: BottomNavBar(
        index: 0,
      ),
    );
  }
}
