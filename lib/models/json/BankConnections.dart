import 'ConnectionData.dart';
import 'ConnectionsMeta.dart';

class BankConnections {
  List<ConnectionData> data;
  ConnectionsMeta meta;

  BankConnections({this.data, this.meta});

  BankConnections.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ConnectionData>();
      json['data'].forEach((v) {
        data.add(new ConnectionData.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new ConnectionsMeta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    return data;
  }
}