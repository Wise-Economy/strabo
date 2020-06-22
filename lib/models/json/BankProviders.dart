import './BankProvider.dart';

class BankProviders {
  List<BankProvider> data;

  BankProviders({this.data});

  BankProviders.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<BankProvider>();
      json['data'].forEach((v) {
        data.add(new BankProvider.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
