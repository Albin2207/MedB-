import 'package:flutter/material.dart';
import 'package:medb_app/provider/auth_provider.dart';
import '../../auth/loginscreen/login_screen.dart';

class DialogHeader extends StatelessWidget {
  const DialogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Logout",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Text(
          "Are you sure you want to logout?",
          style: TextStyle(fontSize: 16, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class DialogActions extends StatelessWidget {
  final AuthProvider authProvider;

  const DialogActions({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: ConfirmButton(authProvider: authProvider)),
        const SizedBox(width: 12),
        Expanded(child: CancelButton()),
      ],
    );
  }
}

class ConfirmButton extends StatelessWidget {
  final AuthProvider authProvider;

  const ConfirmButton({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 11,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 120, 50, 212),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          
        ),
        onPressed: authProvider.isLoading ? null : () => _handleLogout(context),
        child:
            authProvider.isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : const Text("Yes, Confirm!"),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final success = await authProvider.logout();

    if (success && context.mounted) {
      Navigator.pop(context); // Close dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text("Cancel"),
      ),
    );
  }
}
