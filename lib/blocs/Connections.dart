import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import '../common/constants.dart';
import '../models/json/ConnectionData.dart';
import '../models/json/BankConnections.dart';
import '../models/json/ConnectSession.dart';
import '../models/json/ConnectSessionData.dart';

class Connections {
  final _connectionsController = BehaviorSubject<List<ConnectionData>>();

  Stream<List<ConnectionData>> get connections => _connectionsController.stream;

  get fetch => _connectionsController.sink.add;

  get last => _connectionsController.value;

  fetchConnections() async {
    final Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "App-id": "${Constants.SERVICE_APP_ID}",
      "Secret": "${Constants.SERVICE_SECRET}",
    };
    final http.Response response = await http
        .get('https://www.saltedge.com/api/v5/connections?customer_id=${Constants.CUSTOMER_ID}', headers: headers);
    List<ConnectionData> banks = BankConnections.fromJson(jsonDecode(response.body)).data;
    if (!_connectionsController.isClosed) fetch(banks);
  }

  Future<String> fetchConnectSession() async {
    final Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "App-id": "${Constants.SERVICE_APP_ID}",
      "Secret": "${Constants.SERVICE_SECRET}",
    };
    final Map<String, dynamic> body = {
      "data": {
        "customer_id": "${Constants.CUSTOMER_ID}",
        "return_connection_id": true,
        "consent": {
          "scopes": ["account_details", "transactions_details"]
        },
        "attempt": {
          "fetch_scopes": ["accounts", "transactions"]
        }
      }
    };
    http.Response response = await http.post('https://www.saltedge.com/api/v5/connect_sessions/create',
        headers: headers, body: jsonEncode(body));
    print('ResponseCode:${response.statusCode}');
    if (response.statusCode == 200) {
      ConnectSessionData data = ConnectSession.fromJson(jsonDecode(response.body)).data;
      return data.connectUrl;
    }
    return null;
  }

  dispose() {
    _connectionsController.close();
  }
}
