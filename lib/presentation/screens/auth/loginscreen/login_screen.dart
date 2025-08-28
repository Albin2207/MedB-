import 'package:flutter/material.dart';
import 'package:medb_app/data/models/auth_model/login_model.dart';
import 'package:medb_app/provider/auth_provider.dart';
import 'package:medb_app/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:medb_app/presentation/screens/auth/forgot_password_screen.dart';
import 'package:medb_app/presentation/screens/auth/loginscreen/widgets/login_actions.dart';
import 'package:medb_app/presentation/screens/auth/loginscreen/widgets/login_form.dart';
import 'package:medb_app/presentation/widgets/google_signin.dart';
import 'package:medb_app/presentation/widgets/header_logo.dart';
import 'package:medb_app/presentation/screens/auth/registerscreen/register_screen.dart';
import 'package:medb_app/core/theme.dart' show AppTheme;
import 'package:medb_app/presentation/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Navigate to dashboard if authenticated
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (authProvider.isAuthenticated) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
              );
            }
          });

          return LoadingOverlay(
            isLoading: authProvider.isLoading,
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(1),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header Section (Logo + Welcome Text)
                            LoginHeader(),
                            Text(
                              'Welcome Back!',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),

                            // Form Section
                            LoginForm(
                              formKey: _formKey,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              obscurePassword: _obscurePassword,
                              onTogglePassword: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              onSubmit: _handleLogin,
                            ),

                            const SizedBox(height: 16),

                            // Forgot Password Link
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    color: Color(0xFFB8B8FF),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Action Buttons Section
                            LoginActions(
                              isLoading: authProvider.isLoading,
                              onLogin: _handleLogin,
                            ),

                            const SizedBox(height: 32),

                            // Google Sign In
                            GoogleSignInWidget(),

                            const SizedBox(height: 32),

                            // Sign Up Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Color(0xFF8B7CF6),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Trouble Logging In Link
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Trouble logging in? Click Here',
                                style: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Clear any previous messages
    authProvider.clearMessage();

    final loginRequest = LoginRequest(
      email: _emailController.text.trim().toLowerCase(),
      password: _passwordController.text,
    );

    final success = await authProvider.login(loginRequest);

    if (mounted) {
      if (success) {
        // Navigation is handled by the Consumer widget above
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.message),
            backgroundColor: AppTheme.successColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.message),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
