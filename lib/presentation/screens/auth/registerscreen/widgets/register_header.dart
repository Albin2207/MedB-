import 'package:flutter/material.dart';
import 'package:medb_app/presentation/widgets/google_signin.dart';
import 'package:medb_app/presentation/widgets/header_logo.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // MedB Logo
        LoginHeader(),

        // Google Sign Inf
        GoogleSignInWidget(),

        const SizedBox(height: 16),

        // Or Divider
        _buildOrDivider(),
      ],
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
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
          ),
        ),
        Expanded(child: Divider(color: Color(0xFFE5E7EB))),
      ],
    );
  }
}
