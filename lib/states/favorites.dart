import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:map_markers/modules/colors.dart';
import 'package:map_markers/modules/fetch.dart';
import 'package:map_markers/modules/navigate.dart';
import 'package:map_markers/widgets/app_bar.dart';

class Favorites extends StatefulWidget {
  final String title;

  const Favorites({super.key, required this.title});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Data> _dataList = [];

  @override
  void initState() {
    fetchData("data.json").then((value) => setState(() => {_dataList = value}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 1,
          childAspectRatio: 5,
          mainAxisSpacing: 10.0,
          shrinkWrap: true,
          children: [
            for (var data in _dataList)
              FavoriteLocation(
                data: data,
                delete: (title) async {
                  var newData = await removeTitle(title);
                  setState(() {
                    _dataList = newData;
                  });
                },
              ),
            Container(
              alignment: Alignment.topCenter,
              child: _dataList.isNotEmpty
                  ? Text(
                      "Hint: double tap to remove",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.lerp(primeColor, secondaryColor, 0.5),
                      ),
                    )
                  : Text(
                      "Go explore the world!",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Color.lerp(primeColor, secondaryColor, 0.4),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class FavoriteLocation extends StatelessWidget {
  late final String title;
  late final double lat;
  late final double lng;
  late final Function delete;

  FavoriteLocation({super.key, required Data data, required this.delete}) {
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
                  onDoubleTap: () => delete(title),
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
                  onTap: () =>
                      navigate(context, "/", args: {"lat": lat, "lng": lng}),
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
