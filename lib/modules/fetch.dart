import 'dart:convert';
import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;

// Fetch data from an api
class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  // Fetch single data object
  Future<dynamic> fetchData(String url) async {
    final response = await http.get(Uri.parse('$baseUrl$url'));
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
    final response = await http.get(Uri.parse('$baseUrl$url'));
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
