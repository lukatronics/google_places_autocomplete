import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart' if (dart.library.js) 'package:dio/browser.dart';
import 'package:flutter/foundation.dart';

/// Internal API service class to handle HTTP requests.
///
/// This class provides a singleton instance for making API calls to the Google Places API.
/// It handles platform-specific implementations for both web and mobile.
class DioAPIServices {
  static DioAPIServices get instance => _instance;
  static final DioAPIServices _instance = DioAPIServices._();
  DioAPIServices._() {
    _launchDio();
  }
  final Dio _dio = Dio();

  Dio _launchDio() {
    _dio.interceptors.add(LogInterceptor(
        request: false,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        logPrint: (object) {},
        error: true));

    // Configure based on platform using universal_io
    // This handles both web and mobile platforms seamlessly
    if (!kIsWeb) {
      // For mobile/desktop platforms
      final adapter = IOHttpClientAdapter();
      adapter.createHttpClient = () {
        final client = HttpClient();
        // Only accept valid certificates in production
        if (kDebugMode) {
          client.badCertificateCallback = (cert, host, port) => true;
        }
        return client;
      };
      _dio.httpClientAdapter = adapter;
    }
    // For web, the default BrowserHttpClientAdapter is used

    _dio.options.connectTimeout = const Duration(seconds: 20);
    _dio.options.receiveTimeout = const Duration(seconds: 20);
    _dio.options.sendTimeout = const Duration(seconds: 30);
    _dio.options.followRedirects = false;
    _dio.options.validateStatus = (int? s) {
      if (s != null) {
        return s < 500;
      } else {
        return false;
      }
    };
    return _dio;
  }

  Future<Response?> post(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress);
      return response;
    } on DioException catch (e) {
      debugPrint('Dio Error');
      debugPrint(e.message.toString());
      return null;
    } catch (e) {
      debugPrint('Unknown Error');
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Response?> get(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);
      return response;
    } on DioException catch (e) {
      debugPrint('Dio Error');
      debugPrint(e.message.toString());
      return null;
    } catch (e) {
      debugPrint('Unknown Error');
      debugPrint(e.toString());
      return null;
    }
  }
}
