import 'package:flutter/material.dart';
import 'package:medb_app/models/auth_model.dart';
import 'package:medb_app/provider/auth_provider.dart';
import 'package:medb_app/utils/theme.dart';
import 'package:medb_app/utils/validators.dart';
import 'package:medb_app/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import '../widgets/loading_overlay.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return LoadingOverlay(
            isLoading: authProvider.isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.paddingL),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    const SizedBox(height: AppTheme.paddingL),
                    Text(
                      'Join MedB',
                      style: AppTheme.headingLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.paddingS),
                    Text(
                      'Create your account to get started',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.paddingXL),

                    // Form Fields
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.paddingL),
                        child: Column(
                          children: [
                            // First Name
                            CustomTextField(
                              controller: _firstNameController,
                              label: 'First Name',
                              prefixIcon: Icons.person_outline,
                              validator: FormValidators.validateFirstName,
                              textCapitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: AppTheme.paddingM),

                            // Middle Name
                            CustomTextField(
                              controller: _middleNameController,
                              label: 'Middle Name (Optional)',
                              prefixIcon: Icons.person_outline,
                              validator: FormValidators.validateMiddleName,
                              textCapitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: AppTheme.paddingM),

                            // Last Name
                            CustomTextField(
                              controller: _lastNameController,
                              label: 'Last Name',
                              prefixIcon: Icons.person_outline,
                              validator: FormValidators.validateLastName,
                              textCapitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: AppTheme.paddingM),

                            // Email
                            CustomTextField(
                              controller: _emailController,
                              label: 'Email Address',
                              prefixIcon: Icons.email_outlined,
                              validator: FormValidators.validateEmail,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: AppTheme.paddingM),

                            // Contact Number
                            CustomTextField(
                              controller: _contactController,
                              label: 'Contact Number',
                              prefixIcon: Icons.phone_outlined,
                              validator: FormValidators.validateContactNumber,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: AppTheme.paddingM),

                            // Password
                            CustomTextField(
                              controller: _passwordController,
                              label: 'Password',
                              prefixIcon: Icons.lock_outline,
                              validator: FormValidators.validatePassword,
                              obscureText: _obscurePassword,
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
                            const SizedBox(height: AppTheme.paddingM),

                            // Confirm Password
                            CustomTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirm Password',
                              prefixIcon: Icons.lock_outline,
                              validator: (value) => FormValidators.validateConfirmPassword(
                                value,
                                _passwordController.text,
                              ),
                              obscureText: _obscureConfirmPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.paddingL),

                    // Register Button
                    SizedBox(
                      height: AppTheme.buttonHeight,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _handleRegister,
                        child: const Text('Create Account'),
                      ),
                    ),

                    const SizedBox(height: AppTheme.paddingL),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final registerRequest = RegisterRequest(
      firstName: _firstNameController.text.trim(),
      middleName: _middleNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim().toLowerCase(),
      contactNo: FormValidators.cleanContactNumber(_contactController.text),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    final success = await authProvider.register(registerRequest);

    if (mounted) {
      if (success) {
        // Show success dialog
        _showSuccessDialog();
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.message),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            color: AppTheme.successColor,
            size: 48,
          ),
          title: const Text('Registration Successful!'),
          content: const Text(
            'Your account has been created successfully. Please verify your email address before logging in.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to login
              },
              child: const Text('Go to Login'),
            ),
          ],
        );
      },
    );
  }
}