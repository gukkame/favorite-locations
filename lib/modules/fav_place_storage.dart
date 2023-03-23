import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:map_markers/modules/place.dart';
import 'package:path_provider/path_provider.dart';

//Storage for List<Place>
class DataStorage {
  List<Place> places = [];

  static final DataStorage _singleton = DataStorage._internal();

  factory DataStorage() {
    return _singleton;
  }

  DataStorage._internal();

  List<Place> getData() {
    return places;
  }

  List<Place> removePlace(Place place) {
    places.remove(place);
    writeData(places);
    return places;
  }

  void updateData(List<Place> newData) {
    places = newData;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
  }

  Future<List<Place>> getDataFromJSON() async {
    final file = await _localFile;

    final jsonString = await file.readAsString();

    final data = json.decode(jsonString);
    final List<Place> locations = List<Place>.from(data.map((x) => Place(
          title: x["title"],
          description: x["description"],
          lat: double.parse(x["lat"].toString()),
          lng: double.parse(x["lng"].toString()),
        )));
    places = locations;
    return locations;
  }

  Future<File> writeData(List<Place> places) async {
    final file = await _localFile;

    final jsonList = places.map((place) => place.toJson()).toList();
    final jsonString = json.encode(jsonList);

    return file.writeAsString(jsonString);
  }
}
