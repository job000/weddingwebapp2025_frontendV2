// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppTheme {
  // Improved palette
  static const primaryGreen =
      Color(0xFF184A3B); // Slightly deeper, more elegant green
  static const secondaryGreen =
      Color(0xFF5D9B8B); // Brighter, more vibrant sage
  static const tertiaryGreen =
      Color(0xFFAACFC2); // Light sage for subtler accents
  static const accentGold = Color(0xFFD4B254); // Warmer gold accent
  static const accentCream = Color(0xFFF9F4E8); // Warmer cream for surfaces
  static const surfaceLight = Color(0xFFF8F9F6); // Keep original cream white
  static final backgroundGreen =
      Color(0xFF2A5648); // Slightly adjusted for depth

  // Design tokens
  static final elegantGradient = LinearGradient(
    colors: [
      primaryGreen,
      backgroundGreen,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final cardGradient = LinearGradient(
    colors: [
      surfaceLight.withOpacity(0.95), // Mer transparent surfaceLight
      Colors.white.withOpacity(0.90), // Mer transparent hvit
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final backgroundGradient = LinearGradient(
    colors: [
      backgroundGreen.withOpacity(0.85), // Mer transparent bakgrunnsfarge
      primaryGreen.withOpacity(0.75), // Mer transparent primærfarge
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final modernShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: -6,
    ),
  ];

  static final glassEffect = BoxDecoration(
    color: Colors.white.withOpacity(0.8),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: Colors.white.withOpacity(0.3),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.white.withOpacity(0.2),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static final bottomNavDecoration = BoxDecoration(
    color: Colors.white.withOpacity(0.85),
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 16,
        offset: const Offset(0, -4),
        spreadRadius: -2,
      ),
    ],
    border: Border.all(
      color: Colors.white.withOpacity(0.2),
      width: 1,
    ),
  );

  // Konstant for maksbredde på innholdskort
  static const double maxContentWidth = 800;

  static ThemeData get theme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: secondaryGreen,
        surface: surfaceLight,
        background: Colors.white,
      ),
      fontFamily: 'Montserrat',
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
          color: primaryGreen,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
          color: primaryGreen,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: primaryGreen,
        ),
        headlineMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          color: primaryGreen,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          height: 1.5,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.5,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: primaryGreen,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      useMaterial3: true,
    );
  }
}
