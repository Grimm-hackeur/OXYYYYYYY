import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'gh_token';
  static const _loginKey = 'gh_login';
  static const _avatarKey = 'gh_avatar';

  static Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  static Future<String?> getToken() => _storage.read(key: _tokenKey);

  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _loginKey);
    await _storage.delete(key: _avatarKey);
  }

  static Future<void> saveUser(String login, String? avatarUrl) async {
    await _storage.write(key: _loginKey, value: login);
    if (avatarUrl != null) {
      await _storage.write(key: _avatarKey, value: avatarUrl);
    }
  }

  static Future<String?> getLogin() => _storage.read(key: _loginKey);
  static Future<String?> getAvatar() => _storage.read(key: _avatarKey);
}
