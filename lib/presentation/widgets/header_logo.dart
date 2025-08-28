// widgets/login_header.dart
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // MedB Logo
        _buildLogo(),

        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/medb.png',
      width: 130,
      height: 130,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // fallback if image fails to load
        return const Icon(
          Icons.medical_services,
          size: 120,
          color: Color(0xFF8B7CF6),
        );
      },
    );
  }
}
