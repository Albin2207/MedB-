import 'package:flutter/material.dart';

class WelcomeContent extends StatelessWidget {
  const WelcomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          LogoSection(),
          SizedBox(height: 40),
          WelcomeTextSection(),
          SizedBox(height: 32),
          InstructionText(),
        ],
      ),
    );
  }
}

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/medb.png',
        width: 140,
        height: 140,
        fit: BoxFit.contain,
      ),
    );
  }
}

class WelcomeTextSection extends StatelessWidget {
  const WelcomeTextSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Welcome to MedB!',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Text(
            'We\'re glad to have you here, MedB is your trusted platform for healthcare needs — all in one place.',
            style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class InstructionText extends StatelessWidget {
  const InstructionText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Use the menu on the left to get started.',
      style: TextStyle(fontSize: 14, color: Colors.black45),
      textAlign: TextAlign.center,
    );
  }
}
