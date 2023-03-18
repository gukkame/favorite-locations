import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_markers/widgets/my_app.dart';

import 'states/home.dart';
import 'modules/colors.dart';

void main() {
  runApp(const MyApp(title: "Map Makers",));
}

class StateManager extends StatelessWidget {
  final String title;
  final dynamic data;

  const StateManager({super.key, required this.title, this.data});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: themeColors,
      initialRoute: "/",
      routes: {
        "/": (context) => MyHomePage(title: title),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

