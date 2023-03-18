import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../main.dart';
import '../states/loading.dart';

class LoadMyApp extends StatelessWidget {
  final String title;
  final Future<dynamic> fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetch,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Loading();
          } else {
            switch (snapshot.hasData) {
              case true:
                return StateManager(title: title, data: snapshot.data);
              default:
                throw Exception("Failed to get app data");
            }
          }
        });
  }

  const LoadMyApp({super.key, required this.title, required this.fetch});
}

class MyApp extends StatelessWidget {
  final String title;
  @override
  Widget build(BuildContext context) => StateManager(title: title);
  const MyApp({super.key, required this.title});
}
