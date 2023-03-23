import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../modules/colors.dart';
import '../modules/fav_place_storage.dart';
import '../modules/place.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/favorite_place.dart';
import '../widgets/nav_bar.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late List<Place> listOfPlaces;
  late DataStorage storage;

  void removeLike(Place place) {
    setState(() {
      listOfPlaces = storage.removePlace(place);
    });
  }

  @override
  void initState() {
    super.initState();
    storage = DataStorage();
    listOfPlaces = storage.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 1,
          childAspectRatio: 5,
          mainAxisSpacing: 10.0,
          shrinkWrap: true,
          children: [
            for (var data in listOfPlaces)
              FavoriteLocation(
                data: data,
                delete: (title) async {
                  removeLike(data);
                },
              ),
            Container(
              alignment: Alignment.topCenter,
              child: listOfPlaces.isNotEmpty
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
      bottomNavigationBar: BottomNavBar(index: 1),
    );
  }
}
