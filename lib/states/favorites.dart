import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:map_markers/states/loading.dart';
import 'package:map_markers/widgets/app_bar.dart';

class Favorites extends StatelessWidget {
  final String title;

  const Favorites({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: Future.delayed(Duration(seconds: 2)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<dynamic> resp = snapshot.data;
              return Column(
                children: [
                  for (var data in resp) Container(),
                ],
              );
            } else {
              return const CircleLoadingAnimation();
            }
          },
        ),
      ),
    );
  }
}
