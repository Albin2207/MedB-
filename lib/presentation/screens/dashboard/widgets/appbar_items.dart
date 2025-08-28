
import 'package:flutter/material.dart';
import 'package:medb_app/provider/auth_provider.dart';
import 'package:medb_app/presentation/screens/auth/loginscreen/login_screen.dart';
import 'package:medb_app/presentation/screens/dashboard/widgets/profilepanel.dart';
import 'package:medb_app/data/services/storage_service.dart';
import 'package:provider/provider.dart';

class DashboardDialogs {
  static Future<void> showProfile(BuildContext context) async {
    final user = await StorageService().getUserDetails();
    if (user == null) return;

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ProfilePanel(user: user),
    );
  }

  static Future<void> showLogout(BuildContext context) async {
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const LogoutDialog(),
    );
  }

  static void showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Notifications"),
        content: const Text("No new notifications."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DialogHeader(),
            const SizedBox(height: 20),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return DialogActions(authProvider: authProvider);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DialogHeader extends StatelessWidget {
  const DialogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Logout",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 120, 50, 212),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: authProvider.isLoading ? null : () => _handleLogout(context),
      child: authProvider.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text("Yes, Confirm!"),
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => Navigator.pop(context),
      child: const Text("Cancel"),
    );
  }
}