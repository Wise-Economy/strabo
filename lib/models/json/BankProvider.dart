class BankProvider {
  String id;
  String name;
  String logoUrl;

  BankProvider({this.id, this.name, this.logoUrl});

  BankProvider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logoUrl = json['logo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo_url'] = this.logoUrl;
    return data;
  }
}