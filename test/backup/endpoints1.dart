class Endpoints1 {
  static String baseURLLive = "http://127.0.0.1:5000";

  //Fungsi update baseURL
  static void updateBaseURL(String url) {
    baseURLLive = url;
  }

  static String get login => "$baseURLLive/api/v1/auth/login";
  static String get createdataKos => "$baseURLLive/api/v1/dataKos/create";
  static String get readdataKos => "$baseURLLive/api/v1/dataKos/read";
  static String get dataKosDelete => "$baseURLLive/api/v1/dataKos/delete";
}
