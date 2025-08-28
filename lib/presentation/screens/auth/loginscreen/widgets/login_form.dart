// widgets/login_form.dart
import 'package:flutter/material.dart';
import 'package:medb_app/core/validators.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Email Field
          _buildEmailField(),
          
          const SizedBox(height: 20),
          
          // Password Field
          _buildPasswordField(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: TextFormField(
        controller: emailController,
        validator: FormValidators.validateEmail,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Email',
          prefixIcon: Icon(
            Icons.email_outlined,
            color: Color(0xFF9CA3AF),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: TextFormField(
        controller: passwordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          }
          return null;
        },
        obscureText: obscurePassword,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => onSubmit(),
        decoration: InputDecoration(
          hintText: 'Password',
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Color(0xFF9CA3AF),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: Color(0xFF9CA3AF),
            ),
            onPressed: onTogglePassword,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}