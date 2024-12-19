import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skripsi_mobile/models/jadwal_model.dart';
import '../utils/secure_storage.dart';

class JadwalService {
  Future<List<JadwalModel>> fetchFoodFishData() async {
    String? token = await SecureStorage.getToken();
    int? userId = await SecureStorage.getUserId(); 
    SecureStorage secureStorage = SecureStorage();
    String? branchId = await secureStorage.getBranchId();

    if (token == null || token.isEmpty) {
      print('No token found, please log in again.');
      throw Exception('No token found, please log in again.');
    }

    if (userId == null) {
      print('No user ID found, please log in again.');
      throw Exception('No user ID found, please log in again.');
    }

    if (branchId == null || branchId.isEmpty) {
      print('No branch ID found, please check your account settings.');
      throw Exception('No branch ID found, please check your account settings.');
    }

    final String url = 'http://103.127.138.198:8080/api/foodfish/branch/$branchId';

    try {
      print('Sending request to API: $url');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body); // Expecting a list
        return jsonResponse.map((data) => JadwalModel.fromJson(data)).toList();
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred during API request: $e');
      throw Exception('Failed to load data: $e');
    }
  }
}
