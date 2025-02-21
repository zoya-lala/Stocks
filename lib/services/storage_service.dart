import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: "auth_token", value: token);
  }

  static Future<String?> getToken() async {
    String? token = await _storage.read(key: "auth_token");
    return token;
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: "auth_token");
  }
}
