import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:skripsi_mobile/models/jadwal_model.dart';
import '../utils/secure_storage.dart';

class JadwalService {
  final String url = 'http://103.127.138.198:8088/api/foodfish';

  Future<List<JadwalModel>> fetchFoodFishData() async {
    String? token = await SecureStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No token found, please log in again.');
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => JadwalModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load data');
    }
  }
}
