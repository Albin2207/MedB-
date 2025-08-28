import 'package:flutter/material.dart';
import 'package:medb_app/core/theme.dart';

class IconHelper {
  static Widget getModuleIcon(String moduleName, BuildContext context) {
    final name = moduleName.toLowerCase();
    if (name.contains('patient')) {
      return CircleAvatar(
        backgroundColor: Colors.white,
        radius: 17,
        child: CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 17,
          child: IconButton(
            icon: const Icon(Icons.person, color: Colors.white,size: 20,),
           onPressed: (){},
          ),
        ),
      );
    }
    
    IconData iconData;
    if (name.contains('appointment')) {
      iconData = Icons.event_note;
    } else if (name.contains('billing')) {
      iconData = Icons.receipt_long;
    } else if (name.contains('report')) {
      iconData = Icons.analytics;
    } else {
      iconData = Icons.folder_outlined;
    }
    
    return Icon(iconData, color: AppTheme.primaryColor);
  }

  static IconData getMenuIcon(String menuName) {
    switch (menuName.toLowerCase()) {
      case 'appointments':
        return Icons.event_available;
      case 'health records':
        return Icons.medical_information;
      case 'account':
        return Icons.person;
      default:
        return Icons.circle;
    }
  }
}