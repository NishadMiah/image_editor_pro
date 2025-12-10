import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF2A2D3E);
  static const Color accent = Color(0xFF00E5FF);
  static const Color background = Color(0xFF1A1A2E);
  static const Color cardColor = Color(0xFF16213E);
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFFF5252);
  static const Color success = Color(0xFF00E676);

  // Legacy support
  static const Color textPrimary =
      Colors.white; // Default text color for dark theme
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color textSecondary = Colors.grey;
  static const Color fillColor = Color(0xFF2A2D3E);
  static const Color containerBorder = Colors.grey;
  static const Color textFormFieldBorder = Color(0xFF6C63FF);
  static const Color black = Colors.black;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF00E5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
