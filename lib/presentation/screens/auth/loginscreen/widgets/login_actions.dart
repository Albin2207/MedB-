// widgets/login_actions.dart
import 'package:flutter/material.dart';

class LoginActions extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onLogin;

  const LoginActions({
    super.key,
    required this.isLoading,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Login Button
        _buildLoginButton(),
        
        const SizedBox(height: 24),
        
        // Or Divider
        _buildOrDivider(),
        
        const SizedBox(height: 24),
        
        // OTP Login Button
        _buildOTPLoginButton(context),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 138, 13, 188),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFE5E7EB))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
            ),
          ),
        ),
        Expanded(child: Divider(color: Color(0xFFE5E7EB))),
      ],
    );
  }

  Widget _buildOTPLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OTP login feature coming soon')),
          );
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0xFF8B7CF6)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          'OTP login? Click here',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF8B7CF6),
          ),
        ),
      ),
    );
  }
}