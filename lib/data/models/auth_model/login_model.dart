import 'package:medb_app/data/models/menu_model/menu_model.dart';
import 'package:medb_app/data/models/user_model/user_model.dart';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class LoginResponse {
  final String accessToken;
  final String? refreshToken;
  final String loginKey;
  final UserDetails userDetails;
  final List<MenuData> menuData;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.loginKey,
    required this.userDetails,
    required this.menuData,
  });

  factory LoginResponse.fromJson(
    Map<String, dynamic> json, {
    Map<String, List<String>>? headers,
  }) {
    String loginKey = json['loginKey'] ?? '';

    if (headers != null && headers.containsKey('set-cookie')) {
      final cookies = headers['set-cookie']!;
      for (var cookie in cookies) {
        if (cookie.startsWith('loginKey=')) {
          loginKey = cookie.split(';')[0].split('=')[1];
          break;
        }
      }
    }

    return LoginResponse(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      loginKey: loginKey,
      userDetails: UserDetails.fromJson(json['userDetails'] ?? {}),
      menuData:
          json['menuData'] != null
              ? (json['menuData'] as List)
                  .map((menu) => MenuData.fromJson(menu))
                  .toList()
              : [],
    );
  }
}
