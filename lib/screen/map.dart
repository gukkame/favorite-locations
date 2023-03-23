import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:map_markers/permisions.dart';

import '../modules/fav_place_storage.dart';
import '../modules/map_data.dart';
import '../modules/place.dart';
import '../widgets/search_bar.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentLocation = LatLng(59.3530117, 27.4133083);
  List<Place> favLocations = [];
  late GoogleMapController mapController;
  var tappedOnMarker = false;

  var addToFav = false;
  Icon icon = Icon(Icons.favorite_border);

  late Place lastTappedMarker = Place(title: '');
  final dataStorage = DataStorage();
  CameraPosition camera =
      CameraPosition(target: LatLng(59.3530117, 27.4133083), zoom: 12);

  void _onMapCreated(GoogleMapController controller) async {
    favLocations = await dataStorage.getDataFromJSON();
    setState(() {
      favLocations = favLocations;
    });
    mapController = controller;
  }

  Future<void> _onTapMap(LatLng latLng) async {
    final mapData = MapData();

    lastTappedMarker = await mapData.getTapLocation(latLng);

    setState(() {
      addToFav = false;
      icon = Icon(Icons.favorite_border);

      lastTappedMarker = lastTappedMarker;
      tappedOnMarker = true;
    });
  }

  void addToFavorites() {
    if (addToFav == false) {
      setState(() {
        favLocations.add(lastTappedMarker);
        icon = Icon(Icons.favorite);
        addToFav = true;
      });
    } else {
      setState(() {
        favLocations.remove(lastTappedMarker);
        addToFav = false;
        icon = Icon(Icons.favorite_border);
      });
    }
    dataStorage.writeData(favLocations);
    dataStorage.updateData(favLocations);
  }

  void updateLocation(Place place) {
    setState(() {
      lastTappedMarker = place;
      currentLocation = LatLng(place.lat!, place.lng!);
      tappedOnMarker = true;
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 15.0,
        ),
      ));
    });
  }

  @override
  void initState() {
    final userPerm = Permision();
    userPerm.getUserCurrentLocation().then((value) {
      setState(() {
        currentLocation = LatLng(value.latitude, value.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 12),
          SearchLocation(
            lastTappedMarker: updateLocation,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: camera,
              mapType: MapType.normal,
              myLocationEnabled: true,
              compassEnabled: true,
              onTap: _onTapMap,
              markers: convertPlacesToMarkers(favLocations),
            ),
          ),
          Positioned(
              child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: tappedOnMarker ? 100 : 0,
            decoration: BoxDecoration(color: Colors.white30),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (tappedOnMarker == true) Text(lastTappedMarker.title),
                  ElevatedButton.icon(
                      onPressed: () {
                        addToFavorites();
                      },
                      icon: icon,
                      label: Text('Like'))
                ]),
          ))
        ],
      ),
    );
  }
}
