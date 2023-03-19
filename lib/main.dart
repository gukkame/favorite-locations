import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_markers/widgets/my_app.dart';

import 'states/favorites.dart';
import 'states/home.dart';
import 'modules/colors.dart';
import 'states/info.dart';

const String about =
    "This little app was created by Laura and Gunta! Hope you like it!";

void main() {
  runApp(const MyApp(
    title: "Map Makers",
  ));
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
      initialRoute: "/fav",
      routes: {
        "/": (context) => MyHomePage(context, title: title),
        "/info": (context) => Info(
              title: title,
              about: about,
            ),
        "/fav": (context) => Favorites(
              title: title,
            ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
