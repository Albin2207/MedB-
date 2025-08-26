// lib/models/auth_models.dart

class RegisterRequest {
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String contactNo;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.contactNo,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'contactNo': contactNo,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class UserDetails {
  final String? id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String contactNo;

  UserDetails({
    this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.contactNo,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id']?.toString(),
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      contactNo: json['contactNo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'contactNo': contactNo,
    };
  }

  String get fullName => '$firstName $middleName $lastName'.trim();
}

class MenuData {
  final String? id;
  final String name;
  final String? module;
  final String? path;
  final int order;
  final List<MenuData>? children;

  MenuData({
    this.id,
    required this.name,
    this.module,
    this.path,
    required this.order,
    this.children,
  });

  factory MenuData.fromJson(Map<String, dynamic> json) {
    return MenuData(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      module: json['module'],
      path: json['path'],
      order: json['order'] ?? 0,
      children: json['children'] != null
          ? (json['children'] as List)
              .map((child) => MenuData.fromJson(child))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'module': module,
      'path': path,
      'order': order,
      'children': children?.map((child) => child.toJson()).toList(),
    };
  }
}

class LoginResponse {
  final String accessToken;
  final String loginKey;
  final UserDetails userDetails;
  final List<MenuData> menuData;

  LoginResponse({
    required this.accessToken,
    required this.loginKey,
    required this.userDetails,
    required this.menuData,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] ?? '',
      loginKey: json['loginKey'] ?? '',
      userDetails: UserDetails.fromJson(json['userDetails'] ?? {}),
      menuData: json['menuData'] != null
          ? (json['menuData'] as List)
              .map((menu) => MenuData.fromJson(menu))
              .toList()
          : [],
    );
  }
}

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.success(String message, {T? data}) {
    return ApiResponse(
      success: true,
      message: message,
      data: data,
    );
  }

  factory ApiResponse.error(String message) {
    return ApiResponse(
      success: false,
      message: message,
    );
  }
}