import 'package:flutter/material.dart';
import 'package:medb_app/models/auth_model.dart';
import 'package:medb_app/provider/auth_provider.dart';
import 'package:medb_app/utils/theme.dart' show AppTheme;
import 'package:medb_app/utils/validators.dart';
import 'package:medb_app/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

import '../widgets/loading_overlay.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.paddingL),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppTheme.paddingXL * 2),

                      // Logo/Header Section
                      Container(
                        padding: const EdgeInsets.all(AppTheme.paddingXL),
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.medical_services,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                            const SizedBox(height: AppTheme.paddingL),
                            Text(
                              'Welcome to MedB',
                              style: AppTheme.headingLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppTheme.paddingS),
                            Text(
                              'Sign in to your account',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppTheme.paddingL),

                      // Login Form
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppTheme.paddingL),
                          child: Column(
                            children: [
                              // Email Field
                              CustomTextField(
                                controller: _emailController,
                                label: 'Email Address',
                                prefixIcon: Icons.email_outlined,
                                validator: FormValidators.validateEmail,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: AppTheme.paddingM),

                              // Password Field
                              CustomTextField(
                                controller: _passwordController,
                                label: 'Password',
                                prefixIcon: Icons.lock_outline,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                },
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _handleLogin(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: AppTheme.paddingS),

                              // Forgot Password Link
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // TODO: Implement forgot password
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Forgot password feature coming soon'),
                                      ),
                                    );
                                  },
                                  child: const Text('Forgot Password?'),
                                ),
                              ),

                              const SizedBox(height: AppTheme.paddingM),

                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                height: AppTheme.buttonHeight,
                                child: ElevatedButton(
                                  onPressed: authProvider.isLoading ? null : _handleLogin,
                                  child: const Text('Sign In'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: AppTheme.paddingL),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: AppTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text('Sign Up'),
                          ),
                        ],
                      ),

                      // Error/Success Message Display
                      if (authProvider.message.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppTheme.paddingM),
                          child: Container(
                            padding: const EdgeInsets.all(AppTheme.paddingM),
                            decoration: BoxDecoration(
                              color: authProvider.state == AuthState.error
                                  ? AppTheme.errorColor.withOpacity(0.1)
                                  : AppTheme.successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                              border: Border.all(
                                color: authProvider.state == AuthState.error
                                    ? AppTheme.errorColor
                                    : AppTheme.successColor,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  authProvider.state == AuthState.error
                                      ? Icons.error_outline
                                      : Icons.check_circle_outline,
                                  color: authProvider.state == AuthState.error
                                      ? AppTheme.errorColor
                                      : AppTheme.successColor,
                                  size: 20,
                                ),
                                const SizedBox(width: AppTheme.paddingS),
                                Expanded(
                                  child: Text(
                                    authProvider.message,
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: authProvider.state == AuthState.error
                                          ? AppTheme.errorColor
                                          : AppTheme.successColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
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
        // Error message is already displayed by the message container
        // Optionally show a snackbar as well
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