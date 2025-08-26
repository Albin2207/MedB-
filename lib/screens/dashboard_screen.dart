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
                                  'Login Key',
                                  authProvider.loginKey ?? 'Not available',
                                ),
                                const SizedBox(height: AppTheme.paddingS),
                                _buildInfoRow(
                                  'User ID',
                                  authProvider.user!.id ?? 'Not available',
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: AppTheme.paddingL),

                        // Menu Data
                        if (authProvider.menuData.isNotEmpty) ...[
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(AppTheme.paddingL),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Available Menus',
                                    style: AppTheme.headingSmall,
                                  ),
                                  const SizedBox(height: AppTheme.paddingM),
                                  _buildMenuSection(context, authProvider),
                                ],
                              ),
                            ),
                          ),
                        ],

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
          width: 100,
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

  Widget _buildMenuSection(BuildContext context,AuthProvider authProvider) {
  if (authProvider.menuData.isEmpty) {
    return Text(
      'No menus available',
      style: AppTheme.bodyMedium.copyWith(
        color: AppTheme.textSecondary,
      ),
    );
  }

  // Group menus by module
  final Map<String, List<MenuData>> groupedMenus = {};
  for (var menu in authProvider.menuData) {
    final moduleName = menu.module ?? 'General';
    groupedMenus.putIfAbsent(moduleName, () => []).add(menu);
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: groupedMenus.entries.map((entry) {
      final moduleName = entry.key;
      final menus = entry.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Module Header
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppTheme.paddingS,
              horizontal: AppTheme.paddingM,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.folder,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: AppTheme.paddingS),
                Text(
                  moduleName,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.paddingS),

          // Menu Items (with recursive children)
          ...menus.map((menu) => _buildMenuItem(context, menu, 0)).toList(),
          const SizedBox(height: AppTheme.paddingM),
        ],
      );
    }).toList(),
  );
}

Widget _buildMenuItem(BuildContext context, menu, int indentLevel) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: AppTheme.paddingL * indentLevel),
        child: ListTile(
          dense: true,
          leading: Icon(
            Icons.arrow_forward_ios,
            size: 12,
            color: AppTheme.textSecondary,
          ),
          title: Text(
            menu.name,
            style: AppTheme.bodyMedium,
          ),
          subtitle: menu.path != null
              ? Text(
                  menu.path!,
                  style: AppTheme.bodySmall,
                )
              : null,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Menu "${menu.name}" tapped'),
              ),
            );
            // Here you can navigate to the path if needed
          },
        ),
      ),

      // Render children recursively if any
      if (menu.children != null && menu.children!.isNotEmpty)
        ...menu.children!.map((child) => _buildMenuItem(context, child, indentLevel + 1)),
    ],
  );
}


  void _handleLogout() async {
    // Show confirmation dialog
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