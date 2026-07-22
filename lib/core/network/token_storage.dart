import '../helpers/secure_cache_helper.dart';

class TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  Future<void> saveAccessToken(String token) async {
    await SecureCacheHelper.saveData(key: _accessTokenKey, value: token);
  }

  Future<void> saveRefreshToken(String token) async {
    await SecureCacheHelper.saveData(key: _refreshTokenKey, value: token);
  }

  Future<String?> getAccessToken() async {
    return await SecureCacheHelper.getData(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await SecureCacheHelper.getData(key: _refreshTokenKey);
  }

  Future<void> clearAccessToken() async {
    await SecureCacheHelper.removeData(key: _accessTokenKey);
  }

  Future<void> clearRefreshToken() async {
    await SecureCacheHelper.removeData(key: _refreshTokenKey);
  }

  Future<void> clear() async {
    await clearAccessToken();
    await clearRefreshToken();
  }
}
