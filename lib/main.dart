import 'package:flutter/material.dart';
import 'package:medb_app/provider/auth_provider.dart';
import 'package:medb_app/presentation/screens/splash/splash_screen.dart';
import 'package:medb_app/core/theme.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MedBApp());
}

class MedBApp extends StatelessWidget {
  const MedBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'MedB',
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

