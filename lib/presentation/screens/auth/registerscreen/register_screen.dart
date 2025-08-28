import 'package:flutter/material.dart';
import 'package:medb_app/data/models/auth_model/registration_model.dart'
    show RegisterRequest;
import 'package:medb_app/provider/auth_provider.dart';
import 'package:medb_app/core/theme.dart';
import 'package:medb_app/core/validators.dart';
import 'package:medb_app/presentation/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'widgets/register_header.dart';
import 'widgets/register_form.dart';
import 'widgets/register_actions.dart';

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

  // Only UI state that needs setState
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _showPasswordFields = false;

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
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return LoadingOverlay(
            isLoading: authProvider.isLoading,
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      children: [
                        // Header Section
                        RegisterHeader(),

                        // Main Registration Card
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                // Title
                                Text(
                                  'Create an Account',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                const SizedBox(height: 32),

                                // Form Section
                                RegisterForm(
                                  formKey: _formKey,
                                  firstNameController: _firstNameController,
                                  middleNameController: _middleNameController,
                                  lastNameController: _lastNameController,
                                  emailController: _emailController,
                                  contactController: _contactController,
                                  passwordController: _passwordController,
                                  confirmPasswordController:
                                      _confirmPasswordController,
                                  obscurePassword: _obscurePassword,
                                  obscureConfirmPassword:
                                      _obscureConfirmPassword,
                                  showPasswordFields: _showPasswordFields,
                                  onTogglePassword: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  onToggleConfirmPassword: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                  onVerifyNumber: () {
                                    setState(() {
                                      _showPasswordFields = true;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Mobile number verified successfully!',
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 24),

                                // Action Buttons Section
                                RegisterActions(
                                  showPasswordFields: _showPasswordFields,
                                  isLoading: authProvider.isLoading,
                                  onVerify: () {
                                    setState(() {
                                      _showPasswordFields = true;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Mobile number verified successfully!',
                                        ),
                                      ),
                                    );
                                  },
                                  onRegister: _handleRegister,
                                ),

                                const SizedBox(height: 24),

                                // Login Link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account? ',
                                      style: TextStyle(
                                        color: Color(0xFF9CA3AF),
                                        fontSize: 14,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Color(0xFF8B7CF6),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
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
