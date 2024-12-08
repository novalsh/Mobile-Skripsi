import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skripsi_mobile/models/user.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

 
  static Future<String?> getToken() async {
    String? token = await _storage.read(key: 'jwt_token');
    print('Token from storage: $token'); 
    return token;
  }

  static Future<void> saveUser(User user) async {
    await _storage.write(
        key: 'user',
        value: jsonEncode({
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'role': user.role,
        }));
  }


  
  static Future<User?> getUser() async {
    String? userJson = await _storage.read(key: 'user');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return User(
        id: userMap['id'],
        name: userMap['name'],
        email: userMap['email'],
        role: userMap['role'],
        token: await getToken() ?? '',
      );
    }
    return null;
  }

  
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  
  static Future<void> deleteUser() async {
    await _storage.delete(key: 'user');
  }
}
