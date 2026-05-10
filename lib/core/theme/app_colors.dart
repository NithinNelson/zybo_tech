import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF121212);
  static const Color black = Color(0xFF000000);
  static const Color surface = Color(0xFF191919);
  static const Color surfaceBlack = Color(0xFF141414);
  static const Color charcoal = Color(0xFF454545);
  static const Color primary = Color(0xFF312ECB);
  static const Color secondary = Color(0xFF4A47D0);
  
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textTertiary = Colors.white54;
  static const Color silver = Color(0xFFBFBFBF);
  static const Color neutralLight = Color(0xFFF0F0F0);
  static const Color iceBlue = Color(0xFF007AFF);
  static const Color lightGrey = Color(0xFFD9D9D9);

  static const Color error = Color(0xFFCF6679);
  static const Color alertRed = Color(0xFFFF3437);
  static const Color success = Color(0xFF34FF4C);
  static const Color forestGreen = Color(0xFF0F8300);
  static const Color successGreen = Color(0xFF34FF4F);
  static const Color darkForestGreen = Color(0xFF031C00);
  static const Color emeraldGreen = Color(0xFF20DE39);
  static const Color deepEmerald = Color(0xFF147721);
  static const Color emeraldPrimary = Color(0xFF008500);
  static const Color crimson = Color(0xFFB50303);
  static const Color blackMaroon = Color(0xFF250000);
  static const Color dangerRed = Color(0xFFE50000);

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
