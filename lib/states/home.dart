import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import '../modules/navigate.dart';
import '../widgets/app_bar.dart';

import 'markers.dart';

const kGoogleApiKey = 'AIzaSyCp5EfjwJY4StgxAWjIIKim2tJ0N8L2TUw';

class MyHomePage extends StatefulWidget {
  final String title;
  late Arguments args;

  MyHomePage(BuildContext context, {super.key, required this.title}) {
    args = Arguments(context);
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GoogleMapController mapController;
  late LatLng currentLocation;
  final _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  final Mode _mode = Mode.overlay;
  String titleOfPlace = "";
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    titleOfPlace = widget.title;
    currentLocation = const LatLng(0, 0);
    if (widget.args.lat != null && widget.args.lng != null) {
      currentLocation = LatLng(widget.args.lat ?? 0, widget.args.lng ?? 0);
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _onTapMap(LatLng position) async {
    final result = await _places.searchNearbyWithRadius(
      Location(lat: position.latitude, lng: position.longitude),
      1000,
    );

    if (result.status == "OK" && result.results.isNotEmpty) {
      final place = result.results.first;
      final name = place.name;
      final description = place.formattedAddress;
      setState(() {
        titleOfPlace = name;
      });
      // TODO: Display the name and description on the screen
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    List<MarkerLocation> locations = await getMarkerLocations();

    for (MarkerLocation location in locations) {
      final marker = Marker(
        markerId: MarkerId(location.title),
        position: LatLng(location.latitude, location.longitude),
        infoWindow: InfoWindow(
          title: location.title,
          snippet: location.description,
        ),
      );
      setState(() {
        markers.add(marker);
      });
    }
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
      throw Exception("ERROR$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _handlePressButton() async {
    void onError(PlacesAutocompleteResponse response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.errorMessage ?? 'Unknown error'),
        ),
      );
    }

    final p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: 'eng',
      components: [Component(Component.country, 'ee')],
      resultTextStyle: Theme.of(context).textTheme.subtitle1,
    );

    await displayPrediction(p, ScaffoldMessenger.of(context));
  }

  Future<void> displayPrediction(
      Prediction? p, ScaffoldMessengerState messengerState) async {
    if (p == null) {
      return;
    }
    final _places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    final detail = await _places.getDetailsByPlaceId(p.placeId!);
    final geometry = detail.result.geometry!;
    final lat = geometry.location.lat;
    final lng = geometry.location.lng;

    setState(() {
      currentLocation = LatLng(lat, lng);
    });
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 15.0,
      ),
    ));

    messengerState.showSnackBar(
      SnackBar(
        content: Text('${p.description} - $lat/$lng'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: titleOfPlace),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentLocation,
                  zoom: 12,
                ),
                markers: markers.toSet(),
                mapType: MapType.normal,
                myLocationEnabled: true,
                compassEnabled: true,
                onMapCreated: _onMapCreated,
                onTap: _onTapMap,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _handlePressButton,
              child: const Text('Search places'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
