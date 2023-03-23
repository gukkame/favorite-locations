import 'package:flutter/material.dart';

import 'pages/favorite.dart';
import 'pages/home.dart';
import 'pages/info.dart';

void main() {
  runApp(const MyApp());
}

const String about =
    "This little app was created by Laura and Gunta! Hope you like it!";
const String title = "Map Markers";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Markers',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/fav': (context) => FavoritePage(),
        '/info': (context) => const Info(
              title: '',
              about: about,
            ),
      },
    );
  }
}
