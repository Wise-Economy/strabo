class ConnectSessionData {
  String expiresAt;
  String connectUrl;

  ConnectSessionData({this.expiresAt, this.connectUrl});

  ConnectSessionData.fromJson(Map<String, dynamic> json) {
    expiresAt = json['expires_at'];
    connectUrl = json['connect_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expires_at'] = this.expiresAt;
    data['connect_url'] = this.connectUrl;
    return data;
  }
}