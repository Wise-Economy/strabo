class ConnectionsMeta {
  String nextId;
  String nextPage;

  ConnectionsMeta({this.nextId, this.nextPage});

  ConnectionsMeta.fromJson(Map<String, dynamic> json) {
    nextId = json['next_id'];
    nextPage = json['next_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['next_id'] = this.nextId;
    data['next_page'] = this.nextPage;
    return data;
  }
}