import 'package:flutter/material.dart';
class Validators {
  static String? validateEmail(String email) {
    if (email.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email.trim())) return 'Enter a valid email';
    return null; // null means no error
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateName(String name, {String fieldName = 'Name'}) {
    if (name.trim().isEmpty) return '$fieldName is required';
    if (name.trim().length < 2) return '$fieldName must be at least 2 characters';
    return null;
  }

  static String? validatePhone(String phone) {
    if (phone.trim().isEmpty) return null; // optional
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(phone.trim())) return 'Enter a valid phone number';
    return null;
  }
}