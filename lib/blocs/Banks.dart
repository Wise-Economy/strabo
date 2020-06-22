import 'dart:async';
import 'dart:convert';

import '../common/constants.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import '../models/json/BankProvider.dart';
import '../models/json/BankProviders.dart';

class Banks {
  final _providersController = BehaviorSubject<List<BankProvider>>();

  Stream<List<BankProvider>> get banks => _providersController.stream;

  get fetch => _providersController.sink.add;

  get last => _providersController.value;

  fetchBanks() async {
    final Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "App-id": "${Constants.APP_APP_ID}",
      "Secret": "${Constants.APP_SECRET}",
    };
    final http.Response response = await http.get('https://www.saltedge.com/api/v5/providers', headers: headers);
    List<BankProvider> banks = BankProviders.fromJson(jsonDecode(response.body)).data;
    if (!_providersController.isClosed) fetch(banks);
  }

  dispose() {
    _providersController.close();
  }
}
