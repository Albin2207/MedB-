// lib/utils/validators.dart

import 'package:email_validator/email_validator.dart';

class FormValidators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase and number';
    }
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // First name validation
  static String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'First name is required';
    }
    if (value.length < 2) {
      return 'First name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'First name can only contain letters and spaces';
    }
    return null;
  }

  // Last name validation
  static String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last name is required';
    }
    if (value.length < 2) {
      return 'Last name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Last name can only contain letters and spaces';
    }
    return null;
  }

  // Middle name validation (optional)
  static String? validateMiddleName(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.isEmpty) {
        return 'Middle name must be at least 1 character';
      }
      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
        return 'Middle name can only contain letters and spaces';
      }
    }
    return null;
  }

  // Contact number validation
  static String? validateContactNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Contact number is required';
    }
    
    // Remove spaces and special characters for validation
    String cleanedValue = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Check if it's a valid Indian mobile number
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleanedValue)) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null;
  }

  // Generic required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Generic text validation with min/max length
  static String? validateText(
    String? value,
    String fieldName, {
    int minLength = 1,
    int? maxLength,
    bool required = true,
  }) {
    if (required && (value == null || value.isEmpty)) {
      return '$fieldName is required';
    }
    
    if (value != null && value.isNotEmpty) {
      if (value.length < minLength) {
        return '$fieldName must be at least $minLength characters';
      }
      if (maxLength != null && value.length > maxLength) {
        return '$fieldName cannot exceed $maxLength characters';
      }
    }
    
    return null;
  }

  // Clean and format contact number
  static String cleanContactNumber(String value) {
    return value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  }

  // Format contact number for display
  static String formatContactNumber(String value) {
    final cleaned = cleanContactNumber(value);
    if (cleaned.length == 10) {
      return '${cleaned.substring(0, 5)} ${cleaned.substring(5)}';
    }
    return value;
  }
}