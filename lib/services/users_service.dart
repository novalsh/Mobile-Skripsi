import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skripsi_mobile/models/user.dart';
import 'package:skripsi_mobile/utils/secure_storage.dart';

class UserService {
  final String baseUrl = 'http://103.127.138.198:8080';

  Future<List<User>> getUsers() async {
    final url = Uri.parse('$baseUrl/api/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((user) => User.fromJson(user, '')).toList(); // Tambahkan argumen kedua
    } else {
      throw Exception('Failed to fetch users: ${response.body}');
    }
  }

  Future<User?> getUserById(int id) async {
    final url = Uri.parse('$baseUrl/api/users/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data, ''); // Tambahkan argumen kedua
    } else {
      throw Exception('Failed to fetch user: ${response.body}');
    }
  }

  Future<User?> createUser(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/api/users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data, ''); // Tambahkan argumen kedua
    } else {
      throw Exception('Failed to create user: ${response.body}');
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> updatedData) async {
    final url = Uri.parse('$baseUrl/api/users/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  Future<void> deleteUser(int id) async {
    final url = Uri.parse('$baseUrl/api/users/$id');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user: ${response.body}');
    }
  }

 Future<List<User>> getUsersByToken(String token) async {
    final url = Uri.parse('$baseUrl/api/user-by-token');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((user) => User.fromJson(user, token)).toList();
    } else {
      throw Exception('Failed to fetch users by token: ${response.body}');
    }
  }

  Future<void> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/api/forgot-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to initiate forgot password: ${response.body}');
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    final url = Uri.parse('$baseUrl/api/reset-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'newPassword': newPassword}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reset password: ${response.body}');
    }
  }

  Future<void> verifyToken(String token) async {
    final url = Uri.parse('$baseUrl/api/verify-token');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to verify token: ${response.body}');
    }
  }
  Future<void> updatePassword(int id, String oldPassword, String newPassword) async {
  final url = Uri.parse('$baseUrl/api/users/$id/password');
  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update password: ${response.body}');
  }
}

}
