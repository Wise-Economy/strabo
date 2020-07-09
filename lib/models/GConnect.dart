import 'dart:convert';

import '../models/User.dart';

class GConnect {
  GConnect({
    this.isNewUser,
    this.user,
  });

  bool isNewUser;
  User user;

  GConnect copyWith({
    bool isNewUser,
    User user,
  }) =>
      GConnect(
        isNewUser: isNewUser ?? this.isNewUser,
        user: user ?? this.user,
      );

  factory GConnect.fromRawJson(String str) => GConnect.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GConnect.fromJson(Map<String, dynamic> json) => GConnect(
    isNewUser: json["is_new_user"] == null ? null : json["is_new_user"],
    user: json["user_details"] == null ? null : User.fromJson(json["user_details"]),
  );

  Map<String, dynamic> toJson() => {
    "is_new_user": isNewUser == null ? null : isNewUser,
    "user_details": user == null ? null : user.toJson(),
  };
}