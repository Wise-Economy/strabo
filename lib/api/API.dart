import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/GUser.dart';
import '../models/User.dart';

class OurServer {
  final baseURL = "http://ec2-13-229-88-171.ap-southeast-1.compute.amazonaws.com/backend/users";
  final Map<String, String> headers = {"Accept": "application/json", "Content-type": "application/json"};

  Future<http.Response> googleConnect(GUser gUser) async {
    String body = gUser.toRawJson();
    print("googleConnect: $body");
    http.Response response = await http.post(
      '$baseURL/google_connect',
      headers: headers,
      body: body,
    );
    return response;
  }

  Future<http.Response> register(User user, String sessionId) async {
    String body = user.toRawJson();
    headers.putIfAbsent("Cookie", () => 'sessionid=$sessionId');
    print(headers.toString());
    http.Response response = await http.put(
      '$baseURL/register',
      headers: headers,
      body: body,
    );
    return response;
  }

  Future<http.Response> fetchEnablesCountries() async {
    http.Response response = await http.put(
      '$baseURL/get_enabled_countries',
      headers: headers,
    );
    return response;
  }
}
