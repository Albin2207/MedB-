
import 'package:flutter/material.dart';
import 'package:medb_app/models/auth_model.dart';
import 'package:medb_app/services/auth_services.dart';

import '../services/storage_service.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  AuthState _state = AuthState.initial;
  String _message = '';
  UserDetails? _user;
  List<MenuData> _menuData = [];
  String? _loginKey;

  // Getters
  AuthState get state => _state;
  String get message => _message;
  UserDetails? get user => _user;
  List<MenuData> get menuData => _menuData;
  String? get loginKey => _loginKey;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;

  // Set loading state
  void _setLoading() {
    _state = AuthState.loading;
    notifyListeners();
  }

  // Set error state
  void _setError(String message) {
    _state = AuthState.error;
    _message = message;
    notifyListeners();
  }

  // Set success message
  void _setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  // Initialize authentication state from storage
  Future<void> initializeAuth() async {
    try {
      _setLoading();

      final isLoggedIn = await _storageService.isLoggedIn();
      
      if (isLoggedIn) {
        // Load stored data
        final accessToken = await _storageService.getAccessToken();
        final loginKey = await _storageService.getLoginKey();
        final userDetails = await _storageService.getUserDetails();
        final menuData = await _storageService.getMenuData();

        if (accessToken != null && userDetails != null) {
          // Set access token in API service
          _apiService.setAccessToken(accessToken);
          
          // Update provider state
          _user = userDetails;
          _menuData = menuData;
          _loginKey = loginKey;
          _state = AuthState.authenticated;
          _message = 'Welcome back, ${userDetails.firstName}!';
        } else {
          // Clear invalid stored data
          await _storageService.clearLoginData();
          _state = AuthState.unauthenticated;
        }
      } else {
        _state = AuthState.unauthenticated;
      }
    } catch (e) {
      print('Error initializing auth: $e');
      _state = AuthState.unauthenticated;
    }
    
    notifyListeners();
  }

  // Register user
  Future<bool> register(RegisterRequest request) async {
    try {
      _setLoading();

      final response = await _apiService.register(request);

      if (response.success) {
        _state = AuthState.unauthenticated;
        _setMessage(response.message);
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } catch (e) {
      _setError('Registration failed. Please try again.');
      return false;
    }
  }

  // Login user
  Future<bool> login(LoginRequest request) async {
    try {
      _setLoading();

      final response = await _apiService.login(request);

      if (response.success && response.data != null) {
        final loginResponse = response.data!;

        // Store data in secure storage
        await _storageService.storeLoginData(loginResponse);

        // Update provider state
        _user = loginResponse.userDetails;
        _menuData = loginResponse.menuData;
        _loginKey = loginResponse.loginKey;
        _state = AuthState.authenticated;
        _setMessage('Welcome, ${loginResponse.userDetails.firstName}!');

        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } catch (e) {
      _setError('Login failed. Please try again.');
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      _setLoading();

      // Call logout API
      await _apiService.logout();

      // Clear stored data
      await _storageService.clearLoginData();

      // Reset provider state
      _user = null;
      _menuData = [];
      _loginKey = null;
      _state = AuthState.unauthenticated;
      _setMessage('Logged out successfully');

    } catch (e) {
      // Even if API call fails, clear local data
      await _storageService.clearLoginData();
      _user = null;
      _menuData = [];
      _loginKey = null;
      _state = AuthState.unauthenticated;
      _setMessage('Logged out successfully');
    }
  }

  // Clear current message
  void clearMessage() {
    _message = '';
    notifyListeners();
  }

  // Get grouped menus by module
  Map<String, List<MenuData>> get groupedMenus {
    final Map<String, List<MenuData>> grouped = {};
    
    for (final menu in _menuData) {
      final module = menu.module ?? 'General';
      if (!grouped.containsKey(module)) {
        grouped[module] = [];
      }
      grouped[module]!.add(menu);
    }

    // Sort menus within each module by order
    for (final moduleMenus in grouped.values) {
      moduleMenus.sort((a, b) => a.order.compareTo(b.order));
    }

    return grouped;
  }

  // Get ordered modules
  List<String> get orderedModules {
    final modules = groupedMenus.keys.toList();
    // You can implement custom module ordering logic here
    modules.sort();
    return modules;
  }

  @override
  void dispose() {
    super.dispose();
  }
}