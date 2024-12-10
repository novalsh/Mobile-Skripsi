import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skripsi_mobile/models/user.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Save token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Get token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Save user
  static Future<void> saveUser(User user) async {
    await _storage.write(
      key: 'user',
      value: jsonEncode({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'role': user.role,
        'branch_id': user.branchId,
      }),
    );
  }

  // Save email
  static Future<void> saveEmail(String email) async {
    await _storage.write(key: 'email', value: email);
  }

  // Get user
  static Future<User?> getUser() async {
    String? userJson = await _storage.read(key: 'user');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return User(
        id: userMap['id'] ?? 0,
        name: userMap['name'] ?? 'Unknown',
        email: userMap['email'] ?? 'unknown@example.com',
        role: userMap['role'] ?? 'Unknown',
        branchId: userMap['branch_id'] ?? 0,
        token: await getToken() ?? '',
      );
    }
    return null;
  }

  // Get email
  static Future<String?> getEmail() async {
    return await _storage.read(key: 'email');
  }

  // Delete token
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  // Delete user
  static Future<void> deleteUser() async {
    await _storage.delete(key: 'user');
  }

  // Delete email
  static Future<void> deleteEmail() async {
    await _storage.delete(key: 'email');
  }
}
