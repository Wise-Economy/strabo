class ConnectionData {
  String id;
  String secret;
  String providerId;
  String providerCode;
  String providerName;
  String customerId;

  ConnectionData(
      {this.id,
        this.secret,
        this.providerId,
        this.providerCode,
        this.providerName,
        this.customerId});

  ConnectionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    secret = json['secret'];
    providerId = json['provider_id'];
    providerCode = json['provider_code'];
    providerName = json['provider_name'];
    customerId = json['customer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['secret'] = this.secret;
    data['provider_id'] = this.providerId;
    data['provider_code'] = this.providerCode;
    data['provider_name'] = this.providerName;
    data['customer_id'] = this.customerId;
    return data;
  }
}
