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