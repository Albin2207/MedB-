// lib/utils/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // MedB Color Palette - Updated for new design
  static const Color primaryColor = Color(0xFF8B7CF6); // Purple from design
  static const Color primaryColorLight = Color(0xFFB794F6);
  static const Color primaryColorDark = Color(0xFF6D28D9);
  
  static const Color secondaryColor = Color(0xFF34D399); // Green accent
  static const Color secondaryColorLight = Color(0xFF6EE7B7);
  static const Color secondaryColorDark = Color(0xFF10B981);
  
  // New design colors
  static const Color newBackgroundColor = Color(0xFFF8F9FA);
  static const Color newInputColor = Color(0xFFF8F9FA);
  static const Color newBorderColor = Color(0xFFE5E7EB);
  static const Color newTextSecondary = Color(0xFF9CA3AF);
  static const Color newTextPrimary = Color(0xFF111827);
  
  // Keep legacy colors for backward compatibility
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color successColor = Color(0xFF4CAF50);
  
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textDisabled = Color(0xFFADB5BD);
  
  static const Color borderColor = Color(0xFFDEE2E6);
  static const Color dividerColor = Color(0xFFE9ECEF);

  // Text Styles - Updated for new design
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: newTextPrimary,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: newTextPrimary,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: newTextPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: newTextPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: newTextPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: newTextSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: primaryColor,
    decoration: TextDecoration.underline,
  );

  // New design text styles
  static const TextStyle newButtonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle newInputText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: newTextPrimary,
  );

  static const TextStyle newHintText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: newTextSecondary,
  );

  // Theme Data - Updated for new design
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        background: backgroundColor,
        surface: surfaceColor,
      ),
      
      // App Bar Theme - Updated
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),

      // Input Decoration Theme - Updated for new design
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: newInputColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: newBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: newBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        labelStyle: const TextStyle(color: newTextSecondary),
        hintStyle: const TextStyle(color: newTextSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Elevated Button Theme - Updated for new design
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: newButtonText,
          elevation: 0,
          minimumSize: Size(double.infinity, 56),
        ),
      ),

      // Outlined Button Theme - New
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
          minimumSize: Size(double.infinity, 56),
        ),
      ),

      // Text Button Theme - Updated
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
      ),

      // Card Theme - Updated for new design
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      // Drawer Theme - New
      drawerTheme: DrawerThemeData(
        backgroundColor: newBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),

      // Scaffold Background Color
      scaffoldBackgroundColor: backgroundColor,

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: newBorderColor,
        thickness: 1,
      ),
    );
  }

  // New design theme for specific components
  static ThemeData get newDesignTheme {
    return lightTheme.copyWith(
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
          minimumSize: Size(double.infinity, 56),
          textStyle: newButtonText,
        ),
      ),
    );
  }

  // Spacing and Sizing Constants
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  static const double borderRadius = 8.0;
  static const double borderRadiusM = 12.0;
  static const double borderRadiusL = 16.0;
  static const double borderRadiusXL = 24.0;

  static const double buttonHeight = 48.0;
  static const double newButtonHeight = 56.0;
  static const double inputHeight = 56.0;

  // Shadow - Updated for new design
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Color(0x1A8B7CF6),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  // New design specific shadows
  static const List<BoxShadow> newCardShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 20,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> newInputShadow = [
    BoxShadow(
      color: Color(0x05000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  // Gradient colors for new design
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryColorLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient welcomeGradient = LinearGradient(
    colors: [Color(0xFF8B7CF6), Color(0xFFB794F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}