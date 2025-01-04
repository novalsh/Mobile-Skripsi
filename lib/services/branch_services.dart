import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skripsi_mobile/utils/secure_storage.dart';

import '../models/branch_model.dart';

class BranchService {
  Future<List<BranchModel>> fetchBranchData() async {
    final url = Uri.parse('http://103.127.138.198:8080/api/branch');

    final token = await SecureStorage.getToken();
    print('Token used in request: $token');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response branchData: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is List) {
        return data.map((json) => BranchModel.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected response format: ${response.body}');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Token may be invalid or expired');
    } else {
      throw Exception('Failed to load branch data: ${response.body}');
    }
  }
}