import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class MarkerLocation {
  double latitude;
  double longitude;
  String title;
  String description;

  MarkerLocation({
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.description,
  });

  factory MarkerLocation.fromJson(Map<String, dynamic> json) {
    return MarkerLocation(
      title: json['title'],
      latitude: double.parse(json['lat']),
      longitude: double.parse(json['lng']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lng': longitude,
      'title': title,
      'description': description,
    };
  }
}

void saveMarkerLocation(MarkerLocation location) async {
  final file = File('assets/data.json');

  List<MarkerLocation> locations = await getMarkerLocations();
  locations.add(location);

  List<Map<String, dynamic>> jsonList =
      locations.map((location) => location.toJson()).toList();
  String jsonString = json.encode(jsonList);

  await file.writeAsString(jsonString);
}

Future<List<MarkerLocation>> getMarkerLocations() async {
  String jsonString = await rootBundle.loadString('assets/data.json');
  final data = json.decode(jsonString)['data'] as List<dynamic>;
  return data.map((json) => MarkerLocation(
    title: json['title'],
    latitude: double.parse(json['lat']),
    longitude: double.parse(json['lng']),
    description: json['description'],
  )).toList();
}

Future<List<dynamic>> loadJsonFromAsset() async {
  String jsonString = await rootBundle.loadString('assets/data.json');
  List<dynamic> data = json.decode(jsonString);
  return data;
}
