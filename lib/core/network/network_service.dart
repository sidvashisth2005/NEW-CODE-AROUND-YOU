import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../constants/app_constants.dart';
import '../error/failures.dart';
import '../utils/logger.dart';
import '../services/storage_service.dart';

class NetworkService {
  static NetworkService? _instance;
  late Dio _dio;
  final Connectivity _connectivity = Connectivity();
  
  NetworkService._() {
    _initializeDio();
  }
  
  static NetworkService get instance {
    _instance ??= NetworkService._();
    return _instance!;
  }
  
  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.networkTimeout,
      receiveTimeout: AppConstants.networkTimeout,
      sendTimeout: AppConstants.networkTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _addInterceptors();
  }
  
  void _addInterceptors() {
    // Request interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token if available
        final storageService = await StorageService.getInstance();
        final token = await storageService.getUserToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        Logger.networkRequest(
          options.method,
          options.uri.toString(),
          data: options.data,
        );
        
        handler.next(options);
      },
      onResponse: (response, handler) {
        Logger.networkResponse(
          response.statusCode ?? 0,
          response.requestOptions.uri.toString(),
          data: response.data,
        );
        handler.next(response);
      },
      onError: (error, handler) {
        Logger.error(
          'Network error: ${error.message}',
          error: error,
          tag: 'NETWORK',
        );
        handler.next(error);
      },
    ));
    
    // Logging interceptor (only in debug mode)
    if (AppConfig.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
        error: true,
        logPrint: (obj) => Logger.debug(obj.toString(), tag: 'DIO'),
      ));
    }
  }
  
  /// Check if device has internet connection
  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      
      // Additional check with actual network request
      try {
        final response = await _dio.get(
          'https://www.google.com',
          options: Options(
            receiveTimeout: const Duration(seconds: 5),
            sendTimeout: const Duration(seconds: 5),
          ),
        );
        return response.statusCode == 200;
      } catch (e) {
        return false;
      }
    } catch (e) {
      Logger.error('Failed to check internet connection', error: e);
      return false;
    }
  }
  
  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      if (!await hasInternetConnection()) {
        throw const NetworkException(
          message: 'No internet connection available',
          code: 1001,
        );
      }
      
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(
        message: 'Unexpected error occurred: $e',
        code: 1000,
      );
    }
  }
  
  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      if (!await hasInternetConnection()) {
        throw const NetworkException(
          message: 'No internet connection available',
          code: 1001,
        );
      }
      
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(
        message: 'Unexpected error occurred: $e',
        code: 1000,
      );
    }
  }
  
  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      if (!await hasInternetConnection()) {
        throw const NetworkException(
          message: 'No internet connection available',
          code: 1001,
        );
      }
      
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(
        message: 'Unexpected error occurred: $e',
        code: 1000,
      );
    }
  }
  
  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      if (!await hasInternetConnection()) {
        throw const NetworkException(
          message: 'No internet connection available',
          code: 1001,
        );
      }
      
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(
        message: 'Unexpected error occurred: $e',
        code: 1000,
      );
    }
  }
  
  /// Upload file
  Future<Response<T>> uploadFile<T>(
    String path,
    File file, {
    String fileKey = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      if (!await hasInternetConnection()) {
        throw const NetworkException(
          message: 'No internet connection available',
          code: 1001,
        );
      }
      
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        ...?data,
        fileKey: await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });
      
      final response = await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(
        message: 'File upload failed: $e',
        code: 1005,
      );
    }
  }
  
  /// Download file
  Future<Response> downloadFile(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      if (!await hasInternetConnection()) {
        throw const NetworkException(
          message: 'No internet connection available',
          code: 1001,
        );
      }
      
      final response = await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(
        message: 'File download failed: $e',
        code: 1006,
      );
    }
  }
  
  /// Handle Dio errors
  NetworkException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
          code: 1002,
        );
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _getErrorMessageFromResponse(error.response);
        
        if (statusCode != null) {
          if (statusCode >= 400 && statusCode < 500) {
            return NetworkException(
              message: message ?? 'Client error occurred',
              code: statusCode,
            );
          } else if (statusCode >= 500) {
            return NetworkException(
              message: message ?? 'Server error occurred',
              code: statusCode,
            );
          }
        }
        
        return NetworkException(
          message: message ?? 'Network error occurred',
          code: statusCode ?? 1003,
        );
      
      case DioExceptionType.cancel:
        return const NetworkException(
          message: 'Request was cancelled',
          code: 1004,
        );
      
      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'Connection error. Please check your internet connection.',
          code: 1001,
        );
      
      default:
        return NetworkException(
          message: error.message ?? 'Unknown network error occurred',
          code: 1000,
        );
    }
  }
  
  /// Extract error message from response
  String? _getErrorMessageFromResponse(Response? response) {
    try {
      if (response?.data is Map<String, dynamic>) {
        final data = response!.data as Map<String, dynamic>;
        return data['message'] ?? data['error'] ?? data['detail'];
      } else if (response?.data is String) {
        return response!.data as String;
      }
    } catch (e) {
      Logger.warning('Failed to parse error message from response');
    }
    return null;
  }
  
  /// Set auth token
  Future<void> setAuthToken(String token) async {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    
    final storageService = await StorageService.getInstance();
    await storageService.setUserToken(token);
    
    Logger.info('Auth token updated');
  }
  
  /// Clear auth token
  Future<void> clearAuthToken() async {
    _dio.options.headers.remove('Authorization');
    
    final storageService = await StorageService.getInstance();
    await storageService.clearUserToken();
    
    Logger.info('Auth token cleared');
  }
  
  /// Update base URL
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
    Logger.info('Base URL updated to: $baseUrl');
  }
  
  /// Create cancel token
  CancelToken createCancelToken() {
    return CancelToken();
  }
  
  /// Cancel all requests
  void cancelAllRequests([String? reason]) {
    _dio.clear();
    Logger.warning('All network requests cancelled${reason != null ? ': $reason' : ''}');
  }
}

/// Network service extensions for common API patterns
extension NetworkServiceExtensions on NetworkService {
  /// Generic API call with error handling
  Future<T> apiCall<T>(
    Future<Response> Function() apiFunction,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await apiFunction();
      
      if (response.data is Map<String, dynamic>) {
        return fromJson(response.data as Map<String, dynamic>);
      } else {
        throw const ServerException(
          message: 'Invalid response format',
          code: 2001,
        );
      }
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to process server response: $e',
        code: 2000,
      );
    }
  }
  
  /// Generic list API call
  Future<List<T>> apiListCall<T>(
    Future<Response> Function() apiFunction,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await apiFunction();
      
      if (response.data is List) {
        final list = response.data as List;
        return list
            .cast<Map<String, dynamic>>()
            .map((item) => fromJson(item))
            .toList();
      } else if (response.data is Map<String, dynamic>) {
        // Handle paginated responses
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('data') && data['data'] is List) {
          final list = data['data'] as List;
          return list
              .cast<Map<String, dynamic>>()
              .map((item) => fromJson(item))
              .toList();
        }
      }
      
      throw const ServerException(
        message: 'Invalid list response format',
        code: 2002,
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to process server list response: $e',
        code: 2000,
      );
    }
  }
}