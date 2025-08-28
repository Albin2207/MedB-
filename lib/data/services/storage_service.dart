import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medb_app/data/models/auth_model/login_model.dart';
import 'package:medb_app/data/models/menu_model/menu_model.dart';
import 'package:medb_app/data/models/user_model/user_model.dart';

class StorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Keys for storing data
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey =
      'refresh_token'; // Add refresh token key
  static const String _loginKeyKey = 'login_key';
  static const String _userDetailsKey = 'user_details';
  static const String _menuDataKey = 'menu_data';
  static const String _isLoggedInKey = 'is_logged_in';

  // Store login data - UPDATED to include refresh token
  Future<void> storeLoginData(LoginResponse loginResponse) async {
    try {
      final futures = <Future>[
        _storage.write(key: _accessTokenKey, value: loginResponse.accessToken),
        _storage.write(key: _loginKeyKey, value: loginResponse.loginKey),
        _storage.write(
          key: _userDetailsKey,
          value: json.encode(loginResponse.userDetails.toJson()),
        ),
        _storage.write(
          key: _menuDataKey,
          value: json.encode(
            loginResponse.menuData.map((m) => m.toJson()).toList(),
          ),
        ),
        _storage.write(key: _isLoggedInKey, value: 'true'),
      ];

      // Add refresh token if available
      if (loginResponse.refreshToken != null) {
        futures.add(
          _storage.write(
            key: _refreshTokenKey,
            value: loginResponse.refreshToken!,
          ),
        );
      }

      await Future.wait(futures);

      print('Storage: Successfully stored login data');
      print('Storage: Menu modules stored: ${loginResponse.menuData.length}');
    } catch (e) {
      print('Error storing login data: $e');
      rethrow;
    }
  }

  // Get access token
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }

  // Get refresh token - NEW METHOD
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      print('Error getting refresh token: $e');
      return null;
    }
  }

  // Get login key
  Future<String?> getLoginKey() async {
    try {
      return await _storage.read(key: _loginKeyKey);
    } catch (e) {
      print('Error getting login key: $e');
      return null;
    }
  }

  // Get user details
  Future<UserDetails?> getUserDetails() async {
    try {
      final userDetailsJson = await _storage.read(key: _userDetailsKey);
      if (userDetailsJson != null) {
        final Map<String, dynamic> userDetailsMap = json.decode(
          userDetailsJson,
        );
        return UserDetails.fromJson(userDetailsMap);
      }
      return null;
    } catch (e) {
      print('Error getting user details: $e');
      return null;
    }
  }

  // Get menu data
  Future<List<MenuData>> getMenuData() async {
    try {
      final menuDataJson = await _storage.read(key: _menuDataKey);
      if (menuDataJson != null) {
        final List<dynamic> menuDataList = json.decode(menuDataJson);
        final menuData =
            menuDataList.map((menu) => MenuData.fromJson(menu)).toList();
        print('Storage: Retrieved ${menuData.length} menu modules');
        return menuData;
      }
      return [];
    } catch (e) {
      print('Error getting menu data: $e');
      return [];
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final isLoggedIn = await _storage.read(key: _isLoggedInKey);
      return isLoggedIn == 'true';
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Clear all stored data (for logout)
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      print('Storage: Cleared all data');
    } catch (e) {
      print('Error clearing storage: $e');
    }
  }

  // Clear specific keys - UPDATED to include refresh token
  Future<void> clearLoginData() async {
    try {
      await Future.wait([
        _storage.delete(key: _accessTokenKey),
        _storage.delete(key: _refreshTokenKey), // Clear refresh token
        _storage.delete(key: _loginKeyKey),
        _storage.delete(key: _userDetailsKey),
        _storage.delete(key: _menuDataKey),
        _storage.delete(key: _isLoggedInKey),
      ]);
      print('Storage: Cleared login data');
    } catch (e) {
      print('Error clearing login data: $e');
    }
  }

  // Update access token (for token refresh scenarios)
  Future<void> updateAccessToken(String newToken) async {
    try {
      await _storage.write(key: _accessTokenKey, value: newToken);
      print('Storage: Updated access token');
    } catch (e) {
      print('Error updating access token: $e');
      rethrow;
    }
  }

  // Update refresh token - NEW METHOD
  Future<void> updateRefreshToken(String newToken) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: newToken);
      print('Storage: Updated refresh token');
    } catch (e) {
      print('Error updating refresh token: $e');
      rethrow;
    }
  }

  // Save user details
  Future<void> saveUserDetails(UserDetails user) async {
    try {
      await _storage.write(
        key: _userDetailsKey,
        value: json.encode(user.toJson()),
      );
      print('Storage: Saved updated user details');
    } catch (e) {
      print('Error saving user details: $e');
      rethrow;
    }
  }
}
