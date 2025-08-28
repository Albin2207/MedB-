// widgets/register_actions.dart
import 'package:flutter/material.dart';

class RegisterActions extends StatelessWidget {
  final bool showPasswordFields;
  final bool isLoading;
  final VoidCallback onVerify;
  final VoidCallback onRegister;

  const RegisterActions({
    super.key,
    required this.showPasswordFields,
    required this.isLoading,
    required this.onVerify,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return showPasswordFields 
        ? _buildCreateAccountButton() 
        : _buildVerifyButton();
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onVerify,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF8B7CF6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: Text(
          'Verify Mobile Number',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF8B7CF6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: Text(
          'Create Account',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}