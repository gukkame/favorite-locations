import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

Future<List<Data>> fetchData(String localUrl) async {
  final String response = await rootBundle.loadString(localUrl);
  final data = await json.decode(response);

  return List.generate(data["data"].length, (index) {
    return Data(
      title: data["data"][index]["title"],
      lat: data["data"][index]["lat"],
      lng: data["data"][index]["lng"],
    );
  });
}

class Data {
  final String title;
  final double lat;
  final double lng;

  Data({required this.title, required this.lat, required this.lng});
}