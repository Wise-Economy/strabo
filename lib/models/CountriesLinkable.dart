import 'dart:convert';

import '../models/Country.dart';

class CountriesLinkable {
  CountriesLinkable({
    this.countriesLinkable,
  });

  List<Country> countriesLinkable;

  CountriesLinkable copyWith({
    List<Country> countriesLinkable,
  }) =>
      CountriesLinkable(
        countriesLinkable: countriesLinkable ?? this.countriesLinkable,
      );

  factory CountriesLinkable.fromRawJson(String str) => CountriesLinkable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CountriesLinkable.fromJson(Map<String, dynamic> json) => CountriesLinkable(
        countriesLinkable: json["countries_linkable"] == null
            ? null
            : List<Country>.from(json["countries_linkable"].map((x) => Country.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "countries_linkable":
            countriesLinkable == null ? null : List<dynamic>.from(countriesLinkable.map((x) => x.toJson())),
      };
}
