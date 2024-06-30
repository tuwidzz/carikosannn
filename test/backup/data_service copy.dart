// data_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:carikosannn/dto/kos.dart';
import 'package:carikosannn/endpoints/endpoints.dart';
import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

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

  static Future<bool> deleteKos(int menuId) async {
    final response = await http.delete(
      Uri.parse('${Endpoints.dataKosDelete}/$menuId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response.statusCode == 200;
  }
}

class KosService {
  static Future<List<Kos>> fetchKosList() async {
    final url = Uri.parse(Endpoints.readdataKos);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Kos.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load Kos');
    }
  }
}

class KosManager {
  Future<void> updateKos(Kos kos, {File? imageFile}) async {
    var request = http.MultipartRequest(
        'PUT', Uri.parse('${Endpoints.dataKosEdit}/${kos.id}'));

    request.fields['id_user'] = kos.id.toString();
    request.fields['nama_kos'] = kos.name;
    request.fields['alamat'] = kos.address;
    request.fields['kota'] = kos.city;
    request.fields['harga'] = kos.price.toString();
    request.fields['deskripsi'] = kos.description;
    request.fields['fasilitas'] = kos.facilities;
    request.fields['kontak'] = kos.contact;

    if (imageFile != null) {
      final mimeTypeData =
          lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final file = await http.MultipartFile.fromPath(
        'gambar_kos',
        imageFile.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      );
      request.files.add(file);
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update Kos');
    }
  }
}

class KosManager1 {
  final List<Kos> _kosList = [];

  List<Kos> get kosList => _kosList;

  Future<void> addKos(Kos kos) async {
    final response = await http.post(
      Uri.parse(Endpoints.createdataKos),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_user': kos.id, // Make sure 'id_user' matches the expected key
        'nama_kos': kos.name,
        'alamat': kos.address,
        'kota': kos.city,
        'harga': kos.price,
        'deskripsi': kos.description,
        'fasilitas': kos.facilities,
        'kontak': kos.contact,
        'gambar_kos': kos.imagePath,
      }),
    );

    if (response.statusCode == 200) {
      // Assuming the backend returns the created kos item with an id
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final newKos = Kos.fromJson(responseData);
      _kosList.add(newKos);
    } else {
      throw Exception('Failed to add kos');
    }
  }

  Future<void> updateKos(Kos updatedKos) async {
    final response = await http.put(
      Uri.parse('${Endpoints.dataKosEdit}/${updatedKos.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_user': updatedKos.id,
        'nama_kos': updatedKos.name,
        'alamat': updatedKos.address,
        'kota': updatedKos.city,
        'harga': updatedKos.price,
        'deskripsi': updatedKos.description,
        'fasilitas': updatedKos.facilities,
        'kontak': updatedKos.contact,
        'gambar_kos': updatedKos.imagePath,
      }),
    );

    if (response.statusCode == 200) {
      // Update the local kosList or handle response as needed
      // For example, update the local copy of updatedKos:
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final updatedKos = Kos.fromJson(responseData);

      // Find and update the existing kos in _kosList
      final index = _kosList.indexWhere((kos) => kos.id == updatedKos.id);
      if (index != -1) {
        _kosList[index] = updatedKos;
      }
    } else {
      throw Exception('Failed to update kos');
    }
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