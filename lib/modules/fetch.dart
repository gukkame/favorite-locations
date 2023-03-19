import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<List<Data>> fetchData(String localUrl) async {
  final String resp = await rootBundle.loadString(localUrl);
  final data = await json.decode(resp);
  return createDataList(data);
}

class Data {
  final String title;
  final double lat;
  final double lng;

  Data({required this.title, required this.lat, required this.lng});
}

Future<List<Data>> removeTitle(String title) async {
  final newData = <Map<String, dynamic>>[];

  final String contents = await rootBundle.loadString('assets/data.json');
  final data = jsonDecode(contents) as Map<String, dynamic>;

  debugPrint("eh");

  for (final item in data['data'] as List<dynamic>) {
    final itemTitle = item['title'] as String;
    if (itemTitle != title) {
      newData.add(item as Map<String, dynamic>);
    }
  }

  final String encodedData =
      const JsonEncoder.withIndent('  ').convert({'data': newData});
  final file = File('assets/data.json');
  await file.writeAsString(encodedData);

  return createDataList(<String, dynamic>{"data": newData});
}

List<Data> createDataList(dynamic data) {
  return List.generate(data["data"].length, (index) {
    return Data(
      title: data["data"][index]["title"],
      lat: data["data"][index]["lat"],
      lng: data["data"][index]["lng"],
    );
  });
}
