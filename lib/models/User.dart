import 'dart:convert';

class User {
  User({
    this.fullName,
    this.dateOfBirth,
    this.phoneNumber,
    this.email,
    this.residenceCountry,
    this.profilePhoto,
  });

  String fullName;
  String dateOfBirth;
  String phoneNumber;
  String email;
  ResidenceCountry residenceCountry;
  String profilePhoto;

  User copyWith({
    String fullName,
    String dateOfBirth,
    String phoneNumber,
    String email,
    ResidenceCountry residenceCountry,
    String profilePhoto,
  }) =>
      User(
        fullName: fullName ?? this.fullName,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        residenceCountry: residenceCountry ?? this.residenceCountry,
        profilePhoto: profilePhoto ?? this.profilePhoto,
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    fullName: json["full_name"] == null ? null : json["full_name"],
    dateOfBirth: json["date_of_birth"] == null ? null : json["date_of_birth"],
    phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
    email: json["email"] == null ? null : json["email"],
    residenceCountry: json["residence_country"] == null ? null : ResidenceCountry.fromJson(json["residence_country"]),
    profilePhoto: json["profile_photo"] == null ? null : json["profile_photo"],
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName == null ? null : fullName,
    "date_of_birth": dateOfBirth == null ? null : dateOfBirth,
    "phone_number": phoneNumber == null ? null : phoneNumber,
    "email": email == null ? null : email,
    "residence_country": residenceCountry == null ? null : residenceCountry.toJson(),
    "profile_photo": profilePhoto == null ? null : profilePhoto,
  };
}

class ResidenceCountry {
  ResidenceCountry({
    this.countryId,
    this.countryName,
  });

  int countryId;
  String countryName;

  ResidenceCountry copyWith({
    int countryId,
    String countryName,
  }) =>
      ResidenceCountry(
        countryId: countryId ?? this.countryId,
        countryName: countryName ?? this.countryName,
      );

  factory ResidenceCountry.fromRawJson(String str) => ResidenceCountry.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResidenceCountry.fromJson(Map<String, dynamic> json) => ResidenceCountry(
    countryId: json["country_id"] == null ? null : json["country_id"],
    countryName: json["country_name"] == null ? null : json["country_name"],
  );

  Map<String, dynamic> toJson() => {
    "country_id": countryId == null ? null : countryId,
    "country_name": countryName == null ? null : countryName,
  };
}