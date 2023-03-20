import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class Data {
  final String title;
  final double lat;
  final double lng;

  Data({required this.title, required this.lat, required this.lng});
}

Future<List<Data>> fetchData(String localUrl) async {
  final data = await readJsonFile(localUrl);
  return createDataList(data);
}

Future<List<Data>> removeTitle(String title) async {
  final newData = <Map<String, dynamic>>[];
  final Map<String, dynamic> data = await readJsonFile('data.json');

  for (final item in data['data'] as List<dynamic>) {
    final itemTitle = item['title'] as String;
    if (itemTitle != title) {
      newData.add(item as Map<String, dynamic>);
    }
  }
  final String encodedData =
      const JsonEncoder.withIndent('  ').convert({'data': newData});

  await writeJsonToFile(encodedData, "data.json");
  return createDataList(<String, dynamic>{"data": newData});
}

// converts dynamic data to a Data list 
List<Data> createDataList(dynamic data) {
  return List.generate(data["data"].length, (index) {
    return Data(
      title: data["data"][index]["title"],
      lat: data["data"][index]["lat"],
      lng: data["data"][index]["lng"],
    );
  });
}

// reads the content of a file
Future<dynamic> readJsonFile(String localPath) async {
  final dir = await getApplicationDocumentsDirectory();
  final File file = File("${dir.path}$localPath");
  return jsonDecode(await file.readAsString());
}

// writes the given data
Future<void> writeJsonToFile(String data, String localPath) async {
  final dir = await getApplicationDocumentsDirectory();
  final File file = File("${dir.path}$localPath");
  await file.writeAsString(data);
}
