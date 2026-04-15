import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF1A73E8);
  static const Color skyBlue = Color(0xFF4FC3F7);
  static const Color deepBlue = Color(0xFF0D47A1);
  static const Color sunsetOrange = Color(0xFFFF7043);
  static const Color goldYellow = Color(0xFFFFCA28);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
    ),
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: const Color(0xFFF0F4FF),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.dark,
    ),
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: const Color(0xFF0A1628),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
    ),
  );

  // Weather condition gradients
  static List<Color> getGradientForCondition(String iconCode, bool isDark) {
    if (iconCode.contains('01')) {
      // Clear sky
      return isDark
          ? [const Color(0xFF0A1628), const Color(0xFF1A237E)]
          : [const Color(0xFF1A73E8), const Color(0xFF42A5F5)];
    } else if (iconCode.contains('02') || iconCode.contains('03')) {
      // Few/scattered clouds
      return isDark
          ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
          : [const Color(0xFF1565C0), const Color(0xFF78909C)];
    } else if (iconCode.contains('04')) {
      // Broken clouds
      return isDark
          ? [const Color(0xFF1C2331), const Color(0xFF2C3E50)]
          : [const Color(0xFF546E7A), const Color(0xFF90A4AE)];
    } else if (iconCode.contains('09') || iconCode.contains('10')) {
      // Rain
      return isDark
          ? [const Color(0xFF0D1B2A), const Color(0xFF1B263B)]
          : [const Color(0xFF1565C0), const Color(0xFF37474F)];
    } else if (iconCode.contains('11')) {
      // Thunderstorm
      return isDark
          ? [const Color(0xFF1A1A2E), const Color(0xFF2C2C54)]
          : [const Color(0xFF37474F), const Color(0xFF4A148C)];
    } else if (iconCode.contains('13')) {
      // Snow
      return isDark
          ? [const Color(0xFF1A2E3D), const Color(0xFF2D4356)]
          : [const Color(0xFF546E7A), const Color(0xFFB0BEC5)];
    } else if (iconCode.contains('50')) {
      // Mist/fog
      return isDark
          ? [const Color(0xFF1C1F26), const Color(0xFF2D3436)]
          : [const Color(0xFF607D8B), const Color(0xFF90A4AE)];
    }
    return isDark
        ? [const Color(0xFF0A1628), const Color(0xFF1A237E)]
        : [const Color(0xFF1A73E8), const Color(0xFF42A5F5)];
  }
}
