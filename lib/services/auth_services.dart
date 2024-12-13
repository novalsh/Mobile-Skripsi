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
          final userId = responseData['user']['id'] ?? 0; // Ambil userId
          final message = responseData['message'] ?? 'Login successful'; // Ambil message

          // Simpan userId dan message jika diperlukan
          await SecureStorage.saveUserId(userId);
          await SecureStorage.saveMessage(message);

          // Simpan token dan user di secure storage
          await SecureStorage.saveToken(token);
          await SecureStorage.saveUser(userData);
          await SecureStorage.saveEmail(email);

          print('Login successful. Token saved: $token');
          print('User ID: $userId');
          print('Message: $message');

          return User.fromJson(userData, token);
        } else {
          throw Exception('Token atau user tidak ditemukan');
        }
      } else {
        print('Login failed. Status code: ${response.statusCode}');
        throw Exception('Login gagal: ${response.body}');
      }
    } catch (error) {
      print('Error during login: $error');
      rethrow;
    }
  }
}
