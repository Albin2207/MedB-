// dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:medb_app/provider/auth_provider.dart';
import 'package:medb_app/presentation/screens/dashboard/widgets/appbar_items.dart';
import 'package:medb_app/presentation/screens/dashboard/widgets/drawer.dart';
import 'package:medb_app/presentation/screens/dashboard/widgets/welcome_content.dart';
import 'package:medb_app/presentation/screens/auth/loginscreen/login_screen.dart';
import 'package:medb_app/core/theme.dart';
import 'package:medb_app/presentation/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Navigate to login if unauthenticated
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (authProvider.state == AuthState.unauthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        });

        return LoadingOverlay(
          isLoading: authProvider.isLoading,
          child: Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.white, // optional
              centerTitle: true, // make the title centered
              title: SizedBox(
                height: 40, // adjust as needed
                child: Image.asset(
                  'assets/medbsmalllogo.png',
                  fit: BoxFit.contain,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Color.fromARGB(255, 141, 139, 139),
                    size: 45,
                  ),
                  onPressed: () => DashboardDialogs.showNotifications(context),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.person, color: Colors.white),
                        onPressed: () => DashboardDialogs.showProfile(context),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Colors.grey,
                    size: 30,
                  ),
                  onPressed: () => DashboardDialogs.showLogout(context),
                ),
              ],
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(1.0),
                child: Divider(height: 1.0, thickness: 1.0, color: Colors.grey),
              ),
            ),

            drawer: const AppDrawer(),
            body:
                authProvider.user == null
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                        ), // adjust space from AppBar
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: const WelcomeContent(),
                          ),
                        ),
                      ),
                    ),
          ),
        );
      },
    );
  }
}
