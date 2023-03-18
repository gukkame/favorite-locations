import 'dart:convert';
import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;

// Fetch data from an api
class ApiClient {
  final String baseUrl;
  final String initFetch;

  ApiClient({required this.baseUrl, required this.initFetch});

  // get initial list of story ids
  Future<List<String>> get getData async {
    var data = await fetchListData(initFetch);
    return List.generate(data.length, (index) => data[index].toString());
  }

  // get data about a specific story
  Future<List<Data>> getStories(List<String> storyIds) async {
    List<Data> list = <Data>[];

    for (final id in storyIds) {
      try {
        var resp = await fetchData("item/$id");

        if (resp == null) {
          throw Exception("Response was null");
        }

        var data = Map<String, dynamic>.from(resp).map(
          (key, value) => MapEntry(key, value.toString()),
        );

        debugPrint("${data["id"]}");

        list.add(
          Data(
            id: data.containsKey("id") ? data["id"] ?? "ERROR" : "N/A",
          ),
        );
      } catch (e) {
        debugPrint("Error fetching story with ID $id: $e");
        list.add(
          const Data(
            id: "N/A",
          ),
        );
      }
    }

    return list;
  }

  // Fetch single data object
  Future<dynamic> fetchData(String url) async {
    final response = await http.get(Uri.parse('$baseUrl$url.json'));
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody;
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Fetch data that is in a list
  Future<List<dynamic>> fetchListData(String url) async {
    debugPrint('$baseUrl$url');
    final response = await http.get(Uri.parse('$baseUrl$url.json'));
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class Data {
  final String id;

  const Data({required this.id});
}
