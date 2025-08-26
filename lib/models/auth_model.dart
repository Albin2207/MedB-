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
  final String? userId;
  final String? clinicId;
  final String? doctorId;
  final dynamic doctorClinics;
  final String firstName;
  final String middleName;
  final String lastName;
  final String? age;
  final String? gender;
  final String? designation;
  final String email;
  final String contactNo;
  final String? address;
  final String? city;
  final String? district;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? profilePicture;

  UserDetails({
    this.id,
    this.userId,
    this.clinicId,
    this.doctorId,
    this.doctorClinics,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    this.age,
    this.gender,
    this.designation,
    required this.email,
    required this.contactNo,
    this.address,
    this.city,
    this.district,
    this.state,
    this.country,
    this.postalCode,
    this.profilePicture,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id']?.toString(),
      userId: json['userId']?.toString(),
      clinicId: json['clinicId']?.toString(),
      doctorId: json['doctorId']?.toString(),
      doctorClinics: json['doctorClinics'],
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      age: json['age']?.toString(),
      gender: json['gender'],
      designation: json['designation'],
      email: json['email'] ?? '',
      contactNo: json['contactNo'] ?? '',
      address: json['address'],
      city: json['city'],
      district: json['district'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postalCode'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'clinicId': clinicId,
      'doctorId': doctorId,
      'doctorClinics': doctorClinics,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'age': age,
      'gender': gender,
      'designation': designation,
      'email': email,
      'contactNo': contactNo,
      'address': address,
      'city': city,
      'district': district,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'profilePicture': profilePicture,
    };
  }

  String get fullName => '$firstName $middleName $lastName'.trim();
}

// New model for individual menu items within a module
class MenuItem {
  final String? menuId;
  final String menuName;
  final int sortOrder;
  final String? menuIcon;
  final String? actionName;
  final String? controllerName;
  final Map<String, dynamic> rights;

  MenuItem({
    this.menuId,
    required this.menuName,
    required this.sortOrder,
    this.menuIcon,
    this.actionName,
    this.controllerName,
    this.rights = const {},
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      menuId: json['menuId']?.toString(),
      menuName: json['menuName'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
      menuIcon: json['menuIcon'],
      actionName: json['actionName'],
      controllerName: json['controllerName'],
      rights: json['rights'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuId': menuId,
      'menuName': menuName,
      'sortOrder': sortOrder,
      'menuIcon': menuIcon,
      'actionName': actionName,
      'controllerName': controllerName,
      'rights': rights,
    };
  }
}

// Updated MenuData model to match API response
class MenuData {
  final String? moduleId;
  final String moduleName;
  final int sortOrder;
  final String? moduleIcon;
  final List<MenuItem> menus;

  MenuData({
    this.moduleId,
    required this.moduleName,
    required this.sortOrder,
    this.moduleIcon,
    this.menus = const [],
  });

factory MenuData.fromJson(Map<String, dynamic> json) {
  print('DEBUG: Parsing MenuData from JSON: $json');
  
  List<MenuItem> parsedMenus = [];
  
  if (json['menus'] != null && json['menus'] is List) {
    final menusList = json['menus'] as List;
    print('DEBUG: Found ${menusList.length} menus in module');
    
    parsedMenus = menusList.map((menuJson) {
      return MenuItem.fromJson(menuJson as Map<String, dynamic>);
    }).toList();
  } else {
    print('DEBUG: No menus found or menus is not a List. Raw menus: ${json['menus']}');
  }

  return MenuData(
    moduleId: json['moduleId']?.toString(),
    moduleName: json['moduleName'] ?? '',
    sortOrder: json['sortOrder'] ?? 0,
    moduleIcon: json['moduleIcon'],
    menus: parsedMenus,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'moduleId': moduleId,
      'moduleName': moduleName,
      'sortOrder': sortOrder,
      'moduleIcon': moduleIcon,
      'menus': menus.map((menu) => menu.toJson()).toList(),
    };
  }

  // Helper getters for compatibility with existing code
  String? get id => moduleId;
  String get name => moduleName;
  String? get module => moduleName;
  String? get path => null; // Not applicable for modules
  int get order => sortOrder;
  List<MenuData>? get children => null; // Use menus instead
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
      loginKey: loginKey,
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
    return ApiResponse(success: true, message: message, data: data);
  }

  factory ApiResponse.error(String message) {
    return ApiResponse(success: false, message: message);
  }
}