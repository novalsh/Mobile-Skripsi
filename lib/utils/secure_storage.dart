import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  // Simpan token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  // Ambil token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Simpan email
  static Future<void> saveEmail(String email) async {
    await _storage.write(key: 'email', value: email);
  }

  // Simpan user
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _storage.write(key: 'user', value: jsonEncode(user));
  }

  // Simpan userId
  static Future<void> saveUserId(int userId) async {
    await _storage.write(key: 'userId', value: userId.toString());
  }

  // Ambil userId
  static Future<int?> getUserId() async {
    String? userId = await _storage.read(key: 'userId');
    return userId != null ? int.tryParse(userId) : null;
  }

  // Simpan message
  static Future<void> saveMessage(String message) async {
    await _storage.write(key: 'message', value: message);
  }

  // Ambil message
  static Future<String?> getMessage() async {
    return await _storage.read(key: 'message');
  }
  static Future<void> clearToken() async {
  print('Clearing token from secure storage...');
  await _storage.delete(key: 'token');
}

}
