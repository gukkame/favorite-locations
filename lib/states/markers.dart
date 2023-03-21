import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class MarkerLocation {
  double latitude;
  double longitude;
  String title;
  String formatted_address;

  MarkerLocation({
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.formatted_address,
  });

  factory MarkerLocation.fromJson(Map<String, dynamic> json) {
    return MarkerLocation(
      title: json['title'],
      latitude: json['lat'],
      longitude: json['lng'],
      formatted_address: json['formatted_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lng': longitude,
      'title': title,
      'formatted_address': formatted_address,
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

// get markers location from JSON
Future<List<MarkerLocation>> getMarkerLocations() async {
  String jsonString = await rootBundle.loadString('assets/data.json');
  final data = json.decode(jsonString)['data'] as List<dynamic>;
  return data
      .map((json) => MarkerLocation(
            title: json['title'],
            latitude: json['lat'],
            longitude: json['lng'],
            formatted_address: json['formatted_address'],
          ))
      .toList();
}