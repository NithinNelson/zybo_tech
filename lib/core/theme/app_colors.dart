import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF121212);
  static const Color black = Color(0xFF000000);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color primary = Color(0xFF312ECB);
  static const Color secondary = Color(0xFF4A47D0);
  
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textTertiary = Colors.white54;
  static const Color neutralLight = Color(0xFFF0F0F0);
  static const Color iceBlue = Color(0xFF007AFF);

  static const Color error = Color(0xFFCF6679);
  static const Color success = Color(0xFF4CAF50);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF121212), Color(0xFF000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
