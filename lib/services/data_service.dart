// data_service.dart

import 'dart:convert';
import 'package:carikosannn/endpoints/endpoints.dart';
import 'package:http/http.dart' as http;

class DataService {
  static Future<http.Response> sendLoginData(
      String email, String password) async {
    final url = Uri.parse(Endpoints.login);

    final data = {'username': email, 'password': password};

    final response = await http.post(
      url,
      headers: {'Content-type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }
}


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:carikosan/dto/kos.dart';
// import 'dart:convert';

// import 'package:my_app/dto/news.dart';
// import 'package:my_app/dto/balances.dart';
// import 'package:my_app/dto/spendings.dart';
// import 'package:my_app/endpoints/endpoints.dart';
// import 'package:my_app/utils/constants.dart';
// import 'package:my_app/utils/secure_storage_util.dart';

// class DataService {
//   static Future<List<News>> fetchNews() async {
//     final response = await http.get(Uri.parse(Endpoints.news));
//     if (response.statusCode == 200) {
//       final List<dynamic> jsonResponse = jsonDecode(response.body);
//       return jsonResponse.map((item) => News.fromJson(item)).toList();
//     } else {
//       // Handle error
//       throw Exception('Failed to load news');
//     }
//   }

//   static Future<http.Response> sendLoginData(
//       String email, String password) async {
//     final url = Uri.parse(Endpoints.login);
//     final data = {'email': email, 'password': password};

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(data),
//     );

//     return response;
//   }

//   static Future<http.Response> logoutData() async {
//     final url = Uri.parse(Endpoints.logout);
//     final String? accessToken =
//         await SecureStorageUtil.storage.read(key: tokenStoreName);
//     debugPrint("logout with $accessToken");

//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $accessToken',
//       },
//     );

//     return response;
//   }

//   static Future<List<Datas>> fetchDatas() async {
//     final response = await http.get(Uri.parse(Endpoints.datas));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body) as Map<String, dynamic>;
//       return (data['datas'] as List<dynamic>)
//           .map((item) => Datas.fromJson(item as Map<String, dynamic>))
//           .toList();
//     } else {
//       // Handle error
//       throw Exception('Failed to load data');
//     }
//   }

//   // post data to endpoint news
//   static Future<News> createNews(String title, String body) async {
//     final response = await http.post(
//       Uri.parse(Endpoints.news),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'title': title,
//         'body': body,
//       }),
//     );

//     if (response.statusCode == 201) {
//       // Check for creation success (201 Created)
//       final jsonResponse = jsonDecode(response.body);
//       return News.fromJson(jsonResponse);
//     } else {
//       // Handle error
//       throw Exception('Failed to create post: ${response.statusCode}');
//     }
//   }
// }