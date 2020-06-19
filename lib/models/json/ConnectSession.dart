import 'ConnectSessionData.dart';

class ConnectSession {
  ConnectSessionData data;

  ConnectSession({this.data});

  ConnectSession.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ConnectSessionData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}