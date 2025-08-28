// widgets/register_form.dart
import 'package:flutter/material.dart';
import 'package:medb_app/core/validators.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController middleNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController contactController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool showPasswordFields;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onVerifyNumber;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.middleNameController,
    required this.lastNameController,
    required this.emailController,
    required this.contactController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.showPasswordFields,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onVerifyNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // First Name
          _buildTextField(
            controller: firstNameController,
            hintText: 'First Name*',
            validator: FormValidators.validateFirstName,
          ),
          
          const SizedBox(height: 16),
          
          // Middle Name
          _buildTextField(
            controller: middleNameController,
            hintText: 'Middle Name',
            validator: FormValidators.validateMiddleName,
          ),
          
          const SizedBox(height: 16),
          
          // Last Name
          _buildTextField(
            controller: lastNameController,
            hintText: 'Last Name',
            validator: FormValidators.validateLastName,
          ),
          
          const SizedBox(height: 16),
          
          // Email
          _buildTextField(
            controller: emailController,
            hintText: 'Email*',
            validator: FormValidators.validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          
          const SizedBox(height: 16),
          
          // Contact Number with Verify Button
          _buildContactField(),
          
          if (!showPasswordFields) ...[
            const SizedBox(height: 16),
            Text(
              'Verify your mobile number to continue',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          
          // Password fields (shown after verification)
          if (showPasswordFields) ...[
            const SizedBox(height: 16),
            _buildPasswordField(),
            const SizedBox(height: 16),
            _buildConfirmPasswordField(),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildContactField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: TextFormField(
        controller: contactController,
        validator: FormValidators.validateContactNumber,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: 'Contact Number*',
          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
          suffixIcon: TextButton(
            onPressed: onVerifyNumber,
            child: Text(
              'Verify Number',
              style: TextStyle(
                color: Color(0xFF8B7CF6),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
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
        validator: FormValidators.validatePassword,
        obscureText: obscurePassword,
        decoration: InputDecoration(
          hintText: 'Password*',
          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
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

  Widget _buildConfirmPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: TextFormField(
        controller: confirmPasswordController,
        validator: (value) => FormValidators.validateConfirmPassword(
          value,
          passwordController.text,
        ),
        obscureText: obscureConfirmPassword,
        decoration: InputDecoration(
          hintText: 'Confirm Password*',
          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
          suffixIcon: IconButton(
            icon: Icon(
              obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: Color(0xFF9CA3AF),
            ),
            onPressed: onToggleConfirmPassword,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}