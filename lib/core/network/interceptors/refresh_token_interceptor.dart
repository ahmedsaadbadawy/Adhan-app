import 'package:dio/dio.dart';

import '../token_storage.dart';

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor({
    required this.dio,
    required this.refreshDio,
    required this.tokenStorage,
  });

  final Dio dio; // used to retry the original request (has interceptors)
  final Dio refreshDio; // used only for the /refresh call (no interceptors)
  final TokenStorage tokenStorage;

  static const _retriedKey = 'already_retried';

  bool _isRefreshing = false;
  Future<String?>? _refreshFuture;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    if (err.requestOptions.path.contains('/refresh')) {
      return handler.next(err);
    }

    // Already retried once and still got a 401 → don't loop, just fail.
    if (err.requestOptions.extra[_retriedKey] == true) {
      return handler.next(err);
    }

    if (_isRefreshing) {
      final token = await _refreshFuture;

      if (token == null) {
        return handler.next(err);
      }

      return _retry(err, token, handler);
    }

    _isRefreshing = true;
    _refreshFuture = _refreshToken();

    final token = await _refreshFuture;

    _isRefreshing = false;

    if (token == null) {
      await tokenStorage.clear();
      
      // + authRepository.logout();

      return handler.next(err);
    }

    return _retry(err, token, handler);
  }

  Future<void> _retry(
    DioException err,
    String token,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;

    request.headers['Authorization'] = 'Bearer $token';
    request.extra[_retriedKey] = true;

    try {
      final response = await dio.fetch(request);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<String?> _refreshToken() async {
    final refreshToken = await tokenStorage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      final response = await refreshDio.post(
        '/refresh',
        data: {'refreshToken': refreshToken},
      );

      final data = response.data as Map<String, dynamic>;

      final accessToken = data['accessToken'] as String?;
      final newRefreshToken = data['refreshToken'] as String?;

      if (accessToken == null || newRefreshToken == null) {
        return null;
      }

      await tokenStorage.saveAccessToken(accessToken);
      await tokenStorage.saveRefreshToken(newRefreshToken);

      return accessToken;
    } on DioException {
      return null;
    }
  }
}
