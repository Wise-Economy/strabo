import 'dart:convert';

class GUser {
  GUser({
    this.googleId,
    this.fullName,
    this.profilePhoto,
    this.email,
    this.googleSecretToken,
  });

  String googleId;
  String fullName;
  String profilePhoto;
  String email;
  String googleSecretToken;

  GUser copyWith({
    String googleId,
    String fullName,
    String profilePhoto,
    String email,
    String googleSecretToken,
  }) =>
      GUser(
        googleId: googleId ?? this.googleId,
        fullName: fullName ?? this.fullName,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        email: email ?? this.email,
        googleSecretToken: googleSecretToken ?? this.googleSecretToken,
      );

  factory GUser.fromRawJson(String str) => GUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GUser.fromJson(Map<String, dynamic> json) => GUser(
    googleId: json["google_id"],
    fullName: json["full_name"],
    profilePhoto: json["profile_photo"],
    email: json["email"],
    googleSecretToken: json["google_secret_token"],
  );

  Map<String, dynamic> toJson() => {
    "google_id": googleId,
    "full_name": fullName,
    "profile_photo": profilePhoto,
    "email": email,
    "google_secret_token": googleSecretToken,
  };
}