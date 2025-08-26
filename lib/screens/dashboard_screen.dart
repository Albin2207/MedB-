import 'package:flutter/material.dart';
import 'package:medb_app/models/auth_model.dart';
import 'package:medb_app/provider/auth_provider.dart';
import 'package:medb_app/utils/theme.dart';
import 'package:provider/provider.dart';

import '../widgets/loading_overlay.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Debug: Print menu data when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      print('Dashboard loaded. Menu data count: ${authProvider.menuData.length}');
      print('Menu modules: ${authProvider.menuData.map((m) => '${m.moduleName} (${m.menus.length} items)').toList()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Navigate to login if unauthenticated
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (authProvider.state == AuthState.unauthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }
        });

        return LoadingOverlay(
          isLoading: authProvider.isLoading,
          child: Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            appBar: AppBar(
              title: const Text('Dashboard'),
              automaticallyImplyLeading: false,
              actions: [
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: _handleLogout,
                      child: const Row(
                        children: [
                          Icon(Icons.logout, color: AppTheme.errorColor),
                          SizedBox(width: AppTheme.paddingS),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: authProvider.user == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(AppTheme.paddingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.paddingL),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: AppTheme.primaryColor,
                                      child: Text(
                                        authProvider.user!.firstName[0].toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppTheme.paddingM),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Welcome back,',
                                            style: AppTheme.bodyMedium.copyWith(
                                              color: AppTheme.textSecondary,
                                            ),
                                          ),
                                          Text(
                                            authProvider.user!.fullName,
                                            style: AppTheme.headingMedium,
                                          ),
                                          Text(
                                            authProvider.user!.email,
                                            style: AppTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppTheme.paddingM),
                                const Divider(),
                                const SizedBox(height: AppTheme.paddingS),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 16,
                                      color: AppTheme.textSecondary,
                                    ),
                                    const SizedBox(width: AppTheme.paddingS),
                                    Text(
                                      authProvider.user!.contactNo,
                                      style: AppTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: AppTheme.paddingL),

                        // Session Info
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.paddingL),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Session Information',
                                  style: AppTheme.headingSmall,
                                ),
                                const SizedBox(height: AppTheme.paddingM),
                                _buildInfoRow(
                                  'User ID',
                                  authProvider.user!.userId ?? authProvider.user!.id ?? 'Not available',
                                ),
                                const SizedBox(height: AppTheme.paddingS),
                                _buildInfoRow(
                                  'Total Modules',
                                  '${authProvider.menuData.length}',
                                ),
                                const SizedBox(height: AppTheme.paddingS),
                                _buildInfoRow(
                                  'Total Menu Items',
                                  '${authProvider.menuData.fold(0, (sum, module) => sum + module.menus.length)}',
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: AppTheme.paddingL),

                        // Menu Data Section
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.paddingL),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Available Modules & Menus',
                                  style: AppTheme.headingSmall,
                                ),
                                const SizedBox(height: AppTheme.paddingM),
                                _buildMenuSection(context, authProvider),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: AppTheme.paddingXL),

                        // Logout Button
                        SizedBox(
                          width: double.infinity,
                          height: AppTheme.buttonHeight,
                          child: ElevatedButton.icon(
                            onPressed: _handleLogout,
                            icon: const Icon(Icons.logout),
                            label: const Text('Logout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.errorColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context, AuthProvider authProvider) {
    if (authProvider.menuData.isEmpty) {
      return Column(
        children: [
          Icon(
            Icons.menu_open,
            size: 64,
            color: AppTheme.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppTheme.paddingM),
          Text(
            'No modules available',
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.paddingS),
          Text(
            'Module data might not have loaded properly.',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    // Sort modules by sortOrder
    final sortedModules = List<MenuData>.from(authProvider.menuData);
    sortedModules.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedModules.map((module) => _buildModuleCard(context, module)).toList(),
    );
  }

  Widget _buildModuleCard(BuildContext context, MenuData module) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.paddingM),
      elevation: 2,
      child: ExpansionTile(
        leading: module.moduleIcon != null
            ? CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(module.moduleIcon!),
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                onBackgroundImageError: (_, __) {},
                child: module.moduleIcon!.isNotEmpty
                    ? null
                    : Icon(
                        _getModuleIcon(module.moduleName),
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
              )
            : CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Icon(
                  _getModuleIcon(module.moduleName),
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
        title: Text(
          module.moduleName,
          style: AppTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${module.menus.length} menu${module.menus.length == 1 ? '' : 's'} available',
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        children: module.menus.isEmpty
            ? [
                Padding(
                  padding: const EdgeInsets.all(AppTheme.paddingM),
                  child: Text(
                    'No menus available in this module',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ]
            : module.menus
                .map((menu) => _buildMenuItem(context, menu, module.moduleName))
                .toList(),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem menu, String moduleName) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingL,
        vertical: AppTheme.paddingS,
      ),
      leading: menu.menuIcon != null && menu.menuIcon!.isNotEmpty
          ? CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(menu.menuIcon!),
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              onBackgroundImageError: (_, __) {},
              child: null,
            )
          : CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              child: Icon(
                _getMenuIcon(menu.menuName),
                color: AppTheme.primaryColor,
                size: 18,
              ),
            ),
      title: Text(
        menu.menuName,
        style: AppTheme.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (menu.actionName != null && menu.actionName!.isNotEmpty)
            Text(
              menu.actionName!,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          if (menu.controllerName != null && menu.controllerName!.isNotEmpty)
            Text(
              'Path: ${menu.controllerName!}',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
            ),
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppTheme.textSecondary,
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${menu.menuName} from $moduleName module tapped'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
        print('Menu tapped: ${menu.menuName}');
        print('Controller: ${menu.controllerName ?? 'No controller specified'}');
        print('Action: ${menu.actionName ?? 'No action specified'}');
        // Here you can implement navigation based on controllerName
      },
    );
  }

  IconData _getModuleIcon(String moduleName) {
    final name = moduleName.toLowerCase();
    if (name.contains('patient')) return Icons.people;
    if (name.contains('doctor')) return Icons.medical_services;
    if (name.contains('appointment')) return Icons.calendar_today;
    if (name.contains('billing') || name.contains('payment')) return Icons.payment;
    if (name.contains('inventory')) return Icons.inventory;
    if (name.contains('report')) return Icons.assessment;
    if (name.contains('setting')) return Icons.settings;
    if (name.contains('admin')) return Icons.admin_panel_settings;
    return Icons.folder;
  }

  IconData _getMenuIcon(String menuName) {
    final name = menuName.toLowerCase();
    if (name.contains('appointment')) return Icons.calendar_today;
    if (name.contains('record') || name.contains('history')) return Icons.history;
    if (name.contains('prescription')) return Icons.medication;
    if (name.contains('billing') || name.contains('payment')) return Icons.payment;
    if (name.contains('report')) return Icons.assessment;
    if (name.contains('setting')) return Icons.settings;
    if (name.contains('profile')) return Icons.person;
    if (name.contains('dashboard')) return Icons.dashboard;
    if (name.contains('health')) return Icons.health_and_safety;
    if (name.contains('medical')) return Icons.medical_services;
    return Icons.menu;
  }

  void _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.message),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    }
  }
}