// endpoints.dart

class Endpoints {
  static const String host = "10.0.2.2";
  static const String hostPublic = "";

  static const String baseUAS = "http://$host:5000";

  // user
  static const String login = "$baseUAS/api/v1/auth/login";
}
