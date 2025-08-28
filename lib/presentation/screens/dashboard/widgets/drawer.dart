// widgets/dashboard/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:medb_app/data/models/menu_model/menu_model.dart';
import 'package:medb_app/provider/auth_provider.dart';
import 'package:medb_app/presentation/screens/dashboard/widgets/icon_helper.dart';
import 'package:medb_app/core/theme.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const DrawerHeader(),
          Expanded(
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return DrawerMenuItems(menuData: authProvider.menuData);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Center(
        child: SizedBox(
          height: 80,
          child: Image.asset('assets/medbsmalllogo.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class DrawerMenuItems extends StatefulWidget {
  final List<MenuData> menuData;

  const DrawerMenuItems({super.key, required this.menuData});

  @override
  State<DrawerMenuItems> createState() => _DrawerMenuItemsState();
}

class _DrawerMenuItemsState extends State<DrawerMenuItems> {
  String? _expandedModule;

  @override
  Widget build(BuildContext context) {
    if (widget.menuData.isEmpty) {
      return const EmptyMenuState();
    }

    final sortedModules = List<MenuData>.from(widget.menuData);
    sortedModules.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children:
          sortedModules
              .map(
                (module) => ModuleMenuItem(
                  module: module,
                  isExpanded: _expandedModule == module.moduleName,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _expandedModule = expanded ? module.moduleName : null;
                    });
                  },
                ),
              )
              .toList(),
    );
  }
}

class EmptyMenuState extends StatelessWidget {
  const EmptyMenuState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_open, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No modules available',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class ModuleMenuItem extends StatelessWidget {
  final MenuData module;
  final bool isExpanded;
  final Function(bool) onExpansionChanged;

  const ModuleMenuItem({
    super.key,
    required this.module,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (module.menus.isEmpty) {
      return SingleModuleItem(module: module);
    }

    return Column(
      children: [
        // Main module item with container styling
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 230, 227, 227), // Light grey background
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!, width: 0.5),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ListTile(
            leading: IconHelper.getModuleIcon(module.moduleName, context),
            title: Text(
              module.moduleName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            // Remove the default trailing icon
            trailing: const SizedBox.shrink(),
            onTap: () {
              onExpansionChanged(!isExpanded);
            },
          ),
        ),
        // Sub-menu items (if expanded)
        if (isExpanded)
          ...module.menus.map(
            (menu) => SubMenuItem(menu: menu, moduleName: module.moduleName),
          ),
      ],
    );
  }
}

class SingleModuleItem extends StatelessWidget {
  final MenuData module;

  const SingleModuleItem({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconHelper.getModuleIcon(module.moduleName, context),
      title: Text(
        module.moduleName,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        // Handle single item tap
      },
    );
  }
}

class SubMenuItem extends StatelessWidget {
  final MenuItem menu;
  final String moduleName;

  const SubMenuItem({super.key, required this.menu, required this.moduleName});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 72, right: 16),
      leading: Icon(
        IconHelper.getMenuIcon(menu.menuName),
        color: Colors.grey[600],
        size: 18,
      ),
      title: Text(
        menu.menuName,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${menu.menuName} from $moduleName tapped'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      },
    );
  }
}
