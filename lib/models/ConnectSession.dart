import 'dart:convert';

class ConnectSession {
  ConnectSession({
    this.expiresAt,
    this.connectUrl,
    this.userConnectionId,
  });

  DateTime expiresAt;
  String connectUrl;
  int userConnectionId;

  ConnectSession copyWith({
    DateTime expiresAt,
    String connectUrl,
    int userConnectionId,
  }) =>
      ConnectSession(
        expiresAt: expiresAt ?? this.expiresAt,
        connectUrl: connectUrl ?? this.connectUrl,
        userConnectionId: userConnectionId ?? this.userConnectionId,
      );

  factory ConnectSession.fromRawJson(String str) => ConnectSession.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConnectSession.fromJson(Map<String, dynamic> json) => ConnectSession(
    expiresAt: json["expires_at"] == null ? null : DateTime.parse(json["expires_at"]),
    connectUrl: json["connect_url"] == null ? null : json["connect_url"],
    userConnectionId: json["user_connection_id"] == null ? null : json["user_connection_id"],
  );

  Map<String, dynamic> toJson() => {
    "expires_at": expiresAt == null ? null : expiresAt.toIso8601String(),
    "connect_url": connectUrl == null ? null : connectUrl,
    "user_connection_id": userConnectionId == null ? null : userConnectionId,
  };
}