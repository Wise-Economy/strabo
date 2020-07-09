import 'dart:convert';

class CountryList {
  CountryList({
    this.countries,
  });

  List<Country> countries;

  CountryList copyWith({
    List<Country> country,
  }) =>
      CountryList(
        countries: country ?? this.countries,
      );

  factory CountryList.fromRawJson(String str) => CountryList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CountryList.fromJson(Map<String, dynamic> json) => CountryList(
    countries: json["enabled_countries_list"] == null ? null : List<Country>.from(json["enabled_countries_list"].map((x) => Country.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "enabled_countries_list": countries == null ? null : List<dynamic>.from(countries.map((x) => x.toJson())),
  };
}

class Country {
  Country({
    this.countryId,
    this.countryName,
  });

  int countryId;
  String countryName;

  Country copyWith({
    int countryId,
    String countryName,
  }) =>
      Country(
        countryId: countryId ?? this.countryId,
        countryName: countryName ?? this.countryName,
      );

  factory Country.fromRawJson(String str) => Country.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    countryId: json["country_id"] == null ? null : json["country_id"],
    countryName: json["country_name"] == null ? null : json["country_name"],
  );

  Map<String, dynamic> toJson() => {
    "country_id": countryId == null ? null : countryId,
    "country_name": countryName == null ? null : countryName,
  };
}
