import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/scaffold.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GoogleMapController mapController;
  late LatLng currentLocation;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _getCurrentLocation() async {
    Position position = await getUserCurrentLocation();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: SafeArea(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLocation,
              zoom: 12,
            ),
            markers: Set.from([
              Marker(
                markerId: MarkerId("current-location"),
                position: currentLocation ?? const LatLng(37.77483, -122.41942),
                infoWindow: InfoWindow(title: "You are here"),
              )
            ]),
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            onMapCreated: _onMapCreated,
          ),
        ),
      ),
    );
  }
}
