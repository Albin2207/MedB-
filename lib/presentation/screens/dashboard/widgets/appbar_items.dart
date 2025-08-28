
import 'package:flutter/material.dart';
import 'package:medb_app/provider/auth_provider.dart';
import 'package:medb_app/presentation/screens/dashboard/widgets/profilepanel.dart';
import 'package:medb_app/data/services/storage_service.dart';
import 'package:provider/provider.dart';

import 'logout_buttons.dart';

class DashboardDialogs {
static Future<void> showProfile(BuildContext context) async {
    final user = await StorageService().getUserDetails();
    if (user == null) return;

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: false, // This is the key change!
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

        