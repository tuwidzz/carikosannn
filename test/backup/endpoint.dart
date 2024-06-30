class Endpoints {
  static const String host = "10.0.2.2";
  static const String hostPublic = "";

  static const String baseUAS = "http://$host:5000";

  // user
  static const String login = "$baseUAS/api/v1/auth/login";
  static const String createdataKos = "$baseUAS/api/v1/dataKos/create";
  static const String readdataKos = "$baseUAS/api/v1/dataKos/read";
  static const String dataKosDelete = "$baseUAS/api/v1/dataKos/delete";
  static const String dataKosEdit = "$baseUAS/api/v1/dataKos/delete";
}
