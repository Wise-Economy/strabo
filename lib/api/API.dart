import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/GUser.dart';
import '../models/User.dart';

class Server {
  final baseURL = "http://ec2-13-229-88-171.ap-southeast-1.compute.amazonaws.com";
  final Map<String, String> headers = {"Accept": "application/json", "Content-type": "application/json"};

  Future<http.Response> googleConnect(GUser gUser) async {
    String body = gUser.toRawJson();
    print("googleConnect: $body");
    http.Response response = await http.post(
      '$baseURL/backend/users/google_connect',
      headers: headers,
      body: body,
    );
    print('${response.body}');
    return response;
  }

  Future<http.Response> register(User user, String sessionId) async {
    String body = user.toRawJson();
    headers.putIfAbsent("Cookie", () => 'sessionid=$sessionId');
    print(headers.toString());
    http.Response response = await http.put(
      '$baseURL/backend/users/register',
      headers: headers,
      body: body,
    );
    print('${response.body}');
    return response;
  }

  Future<http.Response> fetchEnablesCountries() async {
    http.Response response = await http.get(
      '$baseURL/backend/users/get_enabled_countries',
      headers: headers,
    );
    print('${response.body}');
    return response;
  }

  Future<http.Response> fetchLinkableCountries(String sessionId) async {
    headers.putIfAbsent("Cookie", () => 'sessionid=$sessionId');
    http.Response response = await http.get(
      '$baseURL/backend/global_home_screen/countries_linkable/show',
      headers: headers,
    );
    print('${response.body}');
    return response;
  }

  Future<http.Response> fetchConnectSession(String sessionId, int forCountry) async {
    headers.putIfAbsent("Cookie", () => 'sessionid=$sessionId');
    http.Response response = await http.get(
      '$baseURL/backend/saltedge/connect?country_id=$forCountry',
      headers: headers,
    );
    print('${response.body}');
    return response;
  }

  Future<http.Response> bankConnectionSuccess(String sessionId, int userConnectionId, String seConnectionId) async {
    String body = jsonEncode({'user_connection_id': userConnectionId, 'se_connection_id': seConnectionId});
    headers.putIfAbsent("Cookie", () => 'sessionid=$sessionId');
    http.Response response =
        await http.post('$baseURL/backend/saltedge/callbacks/connection_success', headers: headers, body: body);
    print('${response.body}');
    return response;
  }
}
