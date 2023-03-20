import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:google_api_headers/google_api_headers.dart';

import '../widgets/scaffold.dart';

import 'markers.dart';

const kGoogleApiKey = 'AIzaSyCp5EfjwJY4StgxAWjIIKim2tJ0N8L2TUw';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  var titleOfPlace = "";
  var tappedPlace = false;

  Set<Marker> _marker = {};
  Marker _tappedMarker = Marker(markerId: MarkerId("a"));
  Future<void> _onTapMap(LatLng latLng) async {
    late String _placeId;
    final apiKey = kGoogleApiKey;

    final urlPlaceId =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$apiKey';
    final resPlaceID = await http.get(Uri.parse(urlPlaceId));

    if (resPlaceID.statusCode == 200) {
      final decodedJson = jsonDecode(resPlaceID.body);
      final results = decodedJson['results'];
      if (results.isNotEmpty) {
        _placeId = results[0]['place_id'];
      }
    }
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Cformatted_address%2Cvicinity&place_id=$_placeId&key=$apiKey';
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final decodedJson = jsonDecode(res.body);
      final results = decodedJson['result'];
      if (results.isNotEmpty) {
        final name = results['name'];
        final adress = results['vicinity'];
        final formatted_address = results['formatted_address'];
        final marker = Marker(
            markerId: MarkerId(formatted_address),
            position: LatLng(latLng.latitude, latLng.longitude),
            infoWindow: InfoWindow(
              title: name,
              snippet: formatted_address,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueMagenta),
            onTap: () {
              //* When newly added markers are tapped,

              setState(() {
                _isMarkerTapped = false;
                _tappedMarker = Marker(
                    markerId: MarkerId(formatted_address),
                    position: LatLng(latLng.latitude, latLng.longitude),
                    infoWindow: InfoWindow(
                      title: name,
                      snippet: formatted_address,
                    ),
                    icon: _tappedMarker.icon);
              });
            });
        setState(() {
          _isMarkerTapped = true;
          icon = Icons.favorite_border;
          //first marker is added
          if (markers.isEmpty || tappedPlace == false) {
            markers.add(marker);
            tappedPlace = true;
          } else {
            // remove last one and add new marker to list
            markers.remove(markers.last);
            markers.add(marker);
          }
          _tappedMarker = marker;
        });
      }
    }
    return;
  }

  late GoogleMapController mapController;
  LatLng currentLocation = LatLng(59.3530117, 27.4133083);

//* onFavorites takes in  _tappedMarker, but you change data in markers list
  void _onFavoriteButtonPressed() {
    var isPinkColor = (_tappedMarker.icon.toJson() as List<dynamic>).length;
    setState(() {
      if (isPinkColor == 2) {
        markers.removeWhere((item) => item.markerId == _tappedMarker.markerId);

        Marker temp =
            _tappedMarker.copyWith(iconParam: BitmapDescriptor.defaultMarker);

        _tappedMarker = temp;
        markers.add(temp);

        icon = Icons.favorite;
        tappedPlace = false;
      } else {
        tappedPlace = true;
      }
    });
  }

  List<Marker> markers = [];
  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    List<MarkerLocation> locations = await getMarkerLocations();
    for (MarkerLocation location in locations) {
      final marker = Marker(
          markerId: MarkerId(location.title),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
            title: location.title,
            snippet: location.formatted_address,
          ),
          onTap: () {
            //* When json added markers are tapped
            setState(() {
              _isMarkerTapped = false;
              _tappedMarker = Marker(
                markerId: MarkerId(location.title),
                position: LatLng(location.latitude, location.longitude),
                infoWindow: InfoWindow(
                  title: location.title,
                  snippet: location.formatted_address,
                ),
                icon: BitmapDescriptor.defaultMarker,
              );
            });
          });
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
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Mode _mode = Mode.overlay;
  bool _isMarkerTapped = false;
  IconData icon = Icons.favorite_border;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleOfPlace),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _handlePressButton,
              child: const Text('Search places'),
              // style: ButtonStyle(backgroundColor: ColorFilter.mode( )),
            ),
            const SizedBox(height: 12),
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
            Positioned(
                child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _isMarkerTapped ? 100 : 0,
              decoration: BoxDecoration(color: Colors.white30),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (_isMarkerTapped == true)
                      Text(_tappedMarker.infoWindow.title.toString()),
                    ElevatedButton.icon(
                        onPressed: () {
                          _onFavoriteButtonPressed();
                        },
                        icon: Icon(icon),
                        label: Text('Like'))
                  ]),
            ))
          ],
        ),
      ),
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
}
