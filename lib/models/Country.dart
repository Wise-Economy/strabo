import 'dart:convert';

class Country {
  Country({
    this.countryId,
    this.countryName,
    this.hasAccountsLinked,
    this.accountsLinkingInProgress,
  });

  int countryId;
  String countryName;
  bool hasAccountsLinked;
  bool accountsLinkingInProgress;

  Country copyWith({
    int countryId,
    String countryName,
    bool hasAccountsLinked,
    bool accountsLinkingInProgress,
  }) =>
      Country(
        countryId: countryId ?? this.countryId,
        countryName: countryName ?? this.countryName,
        hasAccountsLinked: hasAccountsLinked ?? this.hasAccountsLinked,
        accountsLinkingInProgress: accountsLinkingInProgress ?? this.accountsLinkingInProgress,
      );

  factory Country.fromRawJson(String str) => Country.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    countryId: json["country_id"] == null ? null : json["country_id"],
    countryName: json["country_name"] == null ? null : json["country_name"],
    hasAccountsLinked: json["has_accounts_linked"] == null ? null : json["has_accounts_linked"],
    accountsLinkingInProgress: json["accounts_linking_in_progress"] == null ? null : json["accounts_linking_in_progress"],
  );

  Map<String, dynamic> toJson() => {
    "country_id": countryId == null ? null : countryId,
    "country_name": countryName == null ? null : countryName,
    "has_accounts_linked": hasAccountsLinked == null ? null : hasAccountsLinked,
    "accounts_linking_in_progress": accountsLinkingInProgress == null ? null : accountsLinkingInProgress,
  };
}
