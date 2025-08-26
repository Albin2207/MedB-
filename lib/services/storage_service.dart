import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medb_app/models/auth_model.dart';

class StorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Keys for storing data
  static const String _accessTokenKey = 'access_token';
  static const String _loginKeyKey = 'login_key';
  static const String _userDetailsKey = 'user_details';
  static const String _menuDataKey = 'menu_data';
  static const String _isLoggedInKey = 'is_logged_in';

  // Store login data
  Future<void> storeLoginData(LoginResponse loginResponse) async {
    try {
      await Future.wait([
        _storage.write(key: _accessTokenKey, value: loginResponse.accessToken),
        _storage.write(key: _loginKeyKey, value: loginResponse.loginKey),
        _storage.write(
          key: _userDetailsKey,
          value: json.encode(loginResponse.userDetails.toJson()),
        ),
        _storage.write(
          key: _menuDataKey,
          value: json.encode(loginResponse.menuData.map((m) => m.toJson()).toList()),
        ),
        _storage.write(key: _isLoggedInKey, value: 'true'),
      ]);
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
        final Map<String, dynamic> userDetailsMap = json.decode(userDetailsJson);
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
        final menuData = menuDataList.map((menu) => MenuData.fromJson(menu)).toList();
        print('Storage: Retrieved ${menuData.length} menu modules');
        print('Storage: Modules: ${menuData.map((m) => '${m.moduleName} (${m.menus.length} items)').toList()}');
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

  // Clear specific keys
  Future<void> clearLoginData() async {
    try {
      await Future.wait([
        _storage.delete(key: _accessTokenKey),
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
  }}