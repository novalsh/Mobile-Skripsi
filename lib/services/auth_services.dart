import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skripsi_mobile/models/user.dart';
import 'package:skripsi_mobile/utils/secure_storage.dart';

class AuthService {
  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://103.127.138.198:8080/api/mobile/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['token'] != null && responseData['user'] != null) {
          final token = responseData['token'] as String;
          final userData = responseData['user'] as Map<String, dynamic>;

          // Save token and user in secure storage
          await SecureStorage.saveToken(token);
          await SecureStorage.saveUser(User.fromJson(userData, token));
          await SecureStorage.saveEmail(email);

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
