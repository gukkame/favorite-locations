import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:map_markers/modules/colors.dart';
import 'package:map_markers/modules/fetch.dart';
import 'package:map_markers/states/loading.dart';
import 'package:map_markers/widgets/app_bar.dart';

class Favorites extends StatefulWidget {
  final String title;

  const Favorites({super.key, required this.title});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: fetchData("assets/data.json"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Data> resp = snapshot.data ?? [];
              return GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 5,
                mainAxisSpacing: 10.0,
                shrinkWrap: true,
                children: [
                  for (var data in resp) FavoriteLocation(data: data),
                  Container(
                    alignment: Alignment.topCenter,
                      child: resp.isNotEmpty
                          ? Text(
                              "Hint: double tap to remove",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color:
                                    Color.lerp(primeColor, secondaryColor, 0.5),
                              ),
                            )
                          : Text(
                              "Go explore the world!",
                              style: TextStyle(
                                fontSize: 30.0,
                                color:
                                    Color.lerp(primeColor, secondaryColor, 0.4),
                              ),
                            ))
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

class FavoriteLocation extends StatelessWidget {
  late final String title;
  late final double lat;
  late final double lng;

  FavoriteLocation({super.key, required Data data}) {
    title = data.title;
    lat = data.lat;
    lng = data.lng;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: primeGradient,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: primeColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.start,
                ),
                const Spacer(),
                GestureDetector(
                  onDoubleTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Color.lerp(primeColor, secondaryColor, 0.45)),
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.block,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Color.lerp(primeColor, secondaryColor, 0.45)),
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.location_on, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
