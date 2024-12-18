import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skripsi_mobile/models/history_model.dart';
import '../utils/secure_storage.dart';

class HistoryService {
  // Fetch History Data by Token
  Future<List<HistoryModel>> fetchHistoryDataByToken() async {
    String? token = await SecureStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No token found, please log in again.');
    }

    final String url = 'http://103.127.138.198:8080/api/historys/token';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      print('History API Response Status Code: ${response.statusCode}');
      print('History API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse JSON response
        List<dynamic> jsonResponse = json.decode(response.body);

        // Map response data to HistoryModel list
        List<HistoryModel> histories =
            jsonResponse.map((data) => HistoryModel.fromJson(data)).toList();

        return histories;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchHistoryDataByToken: $e');
      throw Exception('Failed to load data: $e');
    }
  }

  // Create History
  Future<void> createHistory({
    required int sensorId,
    required String description,
    required String date,
    required int branchId,
    required int userId,
  }) async {
    final String? token = await SecureStorage.getToken();
    if (token == null) {
      throw Exception("Token not found. Please log in.");
    }

    final String url = 'http://103.127.138.198:8080/api/history';

    final Map<String, dynamic> payload = {
      "sensor_id": sensorId,
      "description": description,
      "date": date,
      "user_id": userId,
      "branch_id": branchId,
    };

    // Debugging Payload
    print("Payload sent to server: $payload");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(payload),
    );

    // Debugging Respons Server
    print("Server Response: ${response.body}");
    if (response.statusCode != 201) {
      throw Exception("Failed to create history: ${response.body}");
    }
  }
}
