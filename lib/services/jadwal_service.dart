import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skripsi_mobile/models/jadwal_model.dart';
import '../utils/secure_storage.dart';

class JadwalService {
  // URL dasar tanpa user_id
  Future<List<JadwalModel>> fetchFoodFishData() async {
    String? token = await SecureStorage.getToken();
    int? userId = await SecureStorage.getUserId(); // Ambil user_id dari secure storage

    if (token == null || token.isEmpty) {
      print('No token found, please log in again.');
      throw Exception('No token found, please log in again.');
    }

    if (userId == null) {
      print('No user ID found, please log in again.');
      throw Exception('No user ID found, please log in again.');
    }

    final String url = 'http://103.127.138.198:8080/api/foodfish/$userId';

    try {
      print('Sending request to API with token: $token');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Jika API mengembalikan satu objek (bukan list), bungkus objek itu dalam list
        List jsonResponse = [json.decode(response.body)];

        List<JadwalModel> dataList = jsonResponse
            .map((data) => JadwalModel.fromJson(data))
            .toList();
        return dataList;
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error occurred during API request: $e');
      throw Exception('Failed to load data');
    }
  }
}
