import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/secure_storage.dart';
import '../models/jadwal_model.dart';

class JadwalService {
  Future<List<JadwalModel>> fetchFoodFishData() async {
    String? token = await SecureStorage.getToken();
    int? userId = await SecureStorage.getUserId();
    SecureStorage secureStorage = SecureStorage();
    String? branchId = await secureStorage.getBranchId();

    if (token == null || token.isEmpty) {
      throw Exception('No token found, please log in again.');
    }

    if (userId == null) {
      throw Exception('No user ID found, please log in again.');
    }

    if (branchId == null || branchId.isEmpty) {
      throw Exception(
          'No branch ID found, please check your account settings.');
    }

    final String url =
        'http://103.127.138.198:8080/api/foodfish/branch/$branchId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => JadwalModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> updateTargetWeight(double targetWeight) async {
    String? token = await SecureStorage.getToken();
    SecureStorage secureStorage = SecureStorage();
    String? branchId = await secureStorage.getBranchId();

    if (token == null || token.isEmpty) {
      throw Exception('No token found, please log in again.');
    }

    final String url = 'http://103.127.138.198:8080/api/targetweight';
    final body = {
      "targetWeight": targetWeight,
    };

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update TargetWeight. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update TargetWeight: $e');
    }
  }
}
