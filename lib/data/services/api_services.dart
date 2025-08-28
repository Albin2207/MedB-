import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:medb_app/data/models/auth_model/api_responsemodel.dart';
import 'package:medb_app/data/models/auth_model/login_model.dart';
import 'package:medb_app/data/models/auth_model/registration_model.dart';

class ApiService {
  static const String baseUrl = 'https://testapi.medb.co.in/api';
  late final Dio _dio;
  late final CookieJar _cookieJar;
  String? _accessToken;
  String? _refreshToken;

  ApiService() {
    _cookieJar = CookieJar();
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Cookie manager
    _dio.interceptors.add(CookieManager(_cookieJar));

    // Request + Response interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Attach access token for authenticated endpoints
        if (_accessToken != null && 
            !options.path.contains('/auth/login') && 
            !options.path.contains('/auth/register')) {
          options.headers['Authorization'] = 'Bearer $_accessToken';
        }
        
        print('REQUEST: ${options.method} ${options.path}');
        print('HEADERS: ${options.headers}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
        handler.next(response);
      },
      onError: (error, handler) async {
        print('ERROR: ${error.response?.statusCode} ${error.requestOptions.path}');
        print('ERROR MESSAGE: ${error.message}');
        
        // Handle 401 errors for authenticated endpoints
        if (error.response?.statusCode == 401 && 
            !error.requestOptions.path.contains('/auth/login') && 
            !error.requestOptions.path.contains('/auth/register')) {
          print('Token expired or unauthorized. Clear tokens.');
          _accessToken = null;
          _refreshToken = null;
        }
        handler.next(error);
      },
    ));

    // Logging interceptor
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
  }

  void setAccessToken(String? token) => _accessToken = token;
  void setRefreshToken(String? token) => _refreshToken = token;
  
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _dio.post('/auth/login', data: request.toJson());
      
      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        setAccessToken(loginResponse.accessToken);
        // Set refresh token if available in response
        if (loginResponse.refreshToken != null) {
          setRefreshToken(loginResponse.refreshToken);
        }
        return ApiResponse.success('Login successful', data: loginResponse);
      } else {
        final message = response.data['message'] ?? 'Login failed';
        return ApiResponse.error(message);
      }
    } on DioException catch (e) {
      String errorMessage = 'Login failed';
      if (e.response?.data != null && e.response!.data is Map) {
        errorMessage = e.response!.data['message'] ?? 
                     e.response!.data['error'] ?? 
                     errorMessage;
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Server response timeout. Please try again.';
      } else if (e.type == DioExceptionType.unknown) {
        errorMessage = 'No internet connection. Please check your connection.';
      }
      return ApiResponse.error(errorMessage);
    } catch (e) {
      print('Unexpected error in login: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<void>> register(RegisterRequest request) async {
    try {
      final response = await _dio.post('/auth/register', data: request.toJson());
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = response.data['message'] ?? 'User registered successfully.';
        return ApiResponse.success(message);
      } else {
        final message = response.data['message'] ?? 'Registration failed';
        return ApiResponse.error(message);
      }
    } catch (e) {
      print('Unexpected error in register: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // FIXED LOGOUT METHOD
  Future<ApiResponse<void>> logout() async {
    try {
      Map<String, dynamic>? requestData;
      
      // Include refresh token in request body if available
      if (_refreshToken != null) {
        requestData = {'refreshToken': _refreshToken};
      }
      
      final response = await _dio.post(
        '/auth/logout',
        data: requestData,
      );
      
      // Clear tokens regardless of response
      _clearTokens();
      
      if (response.statusCode == 200) {
        final message = response.data['message'] ?? 'Logged out successfully';
        return ApiResponse.success(message);
      } else {
        return ApiResponse.success('Logged out successfully');
      }
    } on DioException catch (e) {
      // Clear tokens even if request fails
      _clearTokens();
      
      print('Logout API error: ${e.response?.statusCode} - ${e.message}');
      
      // Don't treat logout errors as failures - user should still be logged out locally
      return ApiResponse.success('Logged out successfully');
    } catch (e) {
      // Clear tokens even if request fails
      _clearTokens();
      print('Unexpected logout error: $e');
      return ApiResponse.success('Logged out successfully');
    }
  }

  // Helper method to clear tokens and cookies
  void _clearTokens() {
    _accessToken = null;
    _refreshToken = null;
    _cookieJar.deleteAll();
  }

  Future<Response> authenticatedRequest(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final options = Options(method: method);
    return await _dio.request(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}