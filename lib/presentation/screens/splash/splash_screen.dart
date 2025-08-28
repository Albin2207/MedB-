import 'package:flutter/material.dart';
import 'package:medb_app/provider/auth_provider.dart';
import 'package:medb_app/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:medb_app/presentation/screens/auth/loginscreen/login_screen.dart';
import 'package:medb_app/core/theme.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _initializeApp(BuildContext context) async {
    // Initialize authentication state
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.initializeAuth();

    // Add a minimum splash duration (optional)
    await Future.delayed(const Duration(seconds: 2));

    // Navigate based on authentication state
    if (context.mounted) {
      final Widget targetScreen = authProvider.isAuthenticated
          ? const DashboardScreen()
          : const LoginScreen();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => targetScreen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Start initialization when widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp(context);
    });

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(52), 
                child: Image.asset(
                  'assets/medb.png', 
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to icon if image fails to load
                    return const Icon(
                      Icons.medical_services,
                      color: AppTheme.primaryColor,
                      size: 64,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppTheme.paddingL),
            
            // App Name
            const Text(
              'MedB',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppTheme.paddingS),
            
            const Text(
              'Medical Database',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            
            const SizedBox(height: AppTheme.paddingXL),
            
            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}