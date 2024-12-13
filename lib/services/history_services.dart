import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skripsi_mobile/models/history_model.dart';
import '../utils/secure_storage.dart';

class HistoryService {
  Future<List<HistoryModel>> fetchHistoryData() async {
    // Ambil token dan userId dari secure storage
    String? token = await SecureStorage.getToken();
    int? userId = await SecureStorage.getUserId();

    if (token == null || token.isEmpty) {
      print('No token found, please log in again.');
      throw Exception('No token found, please log in again.');
    }

    if (userId == null) {
      print('No user ID found, please log in again.');
      throw Exception('No user ID found, please log in again.');
    }

    // Sesuaikan URL dengan userId
    final String url = 'http://103.127.138.198:8080/api/history/$userId';

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
        // Jika API mengembalikan satu objek, bungkus objek itu dalam list
        List jsonResponse = [json.decode(response.body)];

        List<HistoryModel> dataList = jsonResponse
            .map((data) => HistoryModel.fromJson(data))
            .toList();
        return dataList;
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error occurred during API request: $e');
      if (e is http.ClientException) {
        print('Client error: ${e.message}');
      }
      throw Exception('Failed to load data');
    }
  }
}
