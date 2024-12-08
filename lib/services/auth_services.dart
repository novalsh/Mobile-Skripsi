import 'dart:convert'; // Untuk mengonversi data ke JSON
import 'package:http/http.dart' as http;
import 'package:skripsi_mobile/models/user.dart';
import 'package:skripsi_mobile/utils/secure_storage.dart';

class AuthService {
  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.18.19:83/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

       
        if (responseData['token'] != null && responseData['user'] != null) {
          final token = responseData['token'];
          final userData = responseData['user'];

          
          await SecureStorage.saveToken(token);

          
          return User.fromJson(userData, token);
        } else {
          throw Exception('Token atau user tidak ditemukan');
        }
      } else {
        throw Exception('Login gagal: ${response.body}');
      }
    } catch (error) {
      print('Error during login: $error');
      rethrow;
    }
  }
}

