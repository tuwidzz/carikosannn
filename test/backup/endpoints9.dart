// endpoints.dart

import 'package:carikosannn/component/constants.dart';
import 'package:carikosannn/utils/secure_storage_util.dart';

class Endpoints {
  //uas
  // static String baseUAS = '127.0.0.1:5000';
  static String baseUAS = '10.0.2.2';
  // static String baseUAS = '192.168.1.24';

  static String login = '';
  static String createdataKos = '';
  static String readdataKos = '';
  static String dataKosDelete = '';
  static String dataKosEdit = '';

  static Future<void> initializeURLs() async {
    try {
      baseUAS = await SecureStorageUtil.storage.read(key: baseURL) ?? '';
      if (baseUAS.isNotEmpty) {
        if (!baseUAS.startsWith('http://') && !baseUAS.startsWith('https://')) {
          // Assuming default to http if scheme is missing
          baseUAS = 'http://$baseUAS';
        }
        login = "$baseUAS/api/v1/auth/login";
        createdataKos = "$baseUAS/api/v1/dataKos/create";
        readdataKos = "$baseUAS/api/v1/dataKos/read";
        dataKosDelete = "$baseUAS/api/v1/dataKos/delete";
        dataKosEdit = "$baseUAS/api/v1/dataKos/update";
      } else {
        // Handle the case where the base URL is not set or invalid
        throw Exception('Base URL is empty');
      }
    } catch (e) {
      // Handle any errors that might occur during reading from storage
      // ignore: avoid_print
      print('Error initializing URLs: $e');
      rethrow; // Re-throwing to ensure calling code can handle this error if needed
    }
  }
}
