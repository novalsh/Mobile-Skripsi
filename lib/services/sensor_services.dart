import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:skripsi_mobile/models/sensor_model.dart';
import 'package:skripsi_mobile/utils/secure_storage.dart';

class SensorService {
  Future<List<SensorModel>> fetchSensorData() async {
    String? token = await SecureStorage.getToken();
    int? userId = await SecureStorage.getUserId();

    if (token == null || token.isEmpty){
      print('No token found, please log in again.');
      throw Exception('No token found, please log in again.');
    }
    if (userId == null){
      print('No user ID found, please log in again.');
      throw Exception('No user ID found, please log in again.');
    }
    final String url = 'http://103.127.138.198:8080/api/sensor/$userId';

    try{
      print('Sending request to API with token: $token');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200){
        List jsonResponse = [json.decode(response.body)];
        List<SensorModel> dataList = jsonResponse.map((data) => SensorModel.fromJson(data)).toList();
        return dataList;
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      if (e is http.ClientException) {
        print('Client error: ${e.message}');
      }
      throw Exception('Failed to load data');
    }
  }
}
