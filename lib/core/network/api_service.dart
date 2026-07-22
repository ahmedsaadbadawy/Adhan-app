import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import 'interceptors/auth_interceptor.dart';
import 'interceptors/refresh_token_interceptor.dart';
import 'token_storage.dart';

class ApiService {
  ApiService({required TokenStorage tokenStorage})
    : dio = Dio(BaseOptions(baseUrl: 'AppConstants.baseUrl')),
      refreshDio = Dio(BaseOptions(baseUrl: 'AppConstants.baseUrl')) {
    dio.interceptors.addAll([
      AuthInterceptor(tokenStorage: tokenStorage),
      RefreshTokenInterceptor(
        dio: dio,
        refreshDio: refreshDio,
        tokenStorage: tokenStorage,
      ),
      if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  final Dio dio;
  final Dio refreshDio;
}
