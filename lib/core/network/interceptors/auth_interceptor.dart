import 'package:dio/dio.dart';

import '../token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.tokenStorage,
  });

  final TokenStorage tokenStorage;

  static const _excludedPaths = [
    '/login',
    '/refresh',
    '/register',
  ];

  bool _shouldSkip(String path) {
    return _excludedPaths.any(path.endsWith);
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_shouldSkip(options.path)) {
      return handler.next(options);
    }

    final token = await tokenStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Accept'] = 'application/json';

    options.headers['Accept-Language'] = 'en';

    handler.next(options);
  }
}