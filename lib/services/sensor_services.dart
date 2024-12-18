import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skripsi_mobile/utils/secure_storage.dart';

import '../models/sensor_model.dart';

class SensorService {
  Future<List<SensorModel>> fetchSensorData(String branchId) async {
    final url = Uri.parse('http://103.127.138.198:8080/api/sensors/branch/$branchId');

    // Ambil token dari SecureStorage
    final token = await SecureStorage.getToken();
    print('Token used in request: $token'); // Log token untuk debug

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Tambahkan token di header
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is List) {
        return data.map((json) => SensorModel.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected response format: ${response.body}');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Token may be invalid or expired');
    } else {
      throw Exception('Failed to load sensor data: ${response.body}');
    }
  }
}
