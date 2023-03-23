

import 'package:flutter/material.dart';
import 'package:map_markers/modules/place.dart';
import 'package:map_markers/navigation.dart';

import '../modules/colors.dart';

class FavoriteLocation extends StatelessWidget {
  late final String title;
  late final double lat;
  late final double lng;
  late final Function delete;

  FavoriteLocation({super.key, required Place data, required this.delete}) {
    title = data.title;
    lat = data.lat!;
    lng = data.lng!;
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
                  child: 
                  Container(
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
