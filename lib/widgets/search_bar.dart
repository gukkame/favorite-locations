import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import 'package:flutter/material.dart';
import 'package:map_markers/modules/colors.dart';

import '../modules/map_data.dart';
import '../modules/place.dart';

class SearchLocation extends StatefulWidget {
  final Function(Place) lastTappedMarker;

  SearchLocation({Key? key, required this.lastTappedMarker}) : super(key: key);

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  late GoogleMapController mapController;
  late LatLng currentLocation;
  late Place lastTappedMarker = Place(title: '');
  Mode _mode = Mode.overlay;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(primeColor)),
      onPressed: _handlePressButton,
      child: const Text('Search places'),
    );
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
      startText: "johvi",
      language: 'eng',
      components: [Component(Component.country, 'ee')],
      resultTextStyle: Theme.of(context).textTheme.subtitle1,
    );

    await displayPrediction(p, ScaffoldMessenger.of(context));
  }

//display preditions of searching1`
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
    final name = detail.result.name;
    final description = detail.result.formattedAddress;

    setState(() {
      currentLocation = LatLng(lat, lng);
      widget.lastTappedMarker(
          Place(title: name, description: description, lat: lat, lng: lng));
    });
  }
}
