import 'package:flutter/material.dart';

class AppTheme {
  // Elegant bryllups-fargepalett
  static const primaryGreen = Color(0xFF1B4D3E); // Dyp elegant grønn
  static const secondaryGreen = Color(0xFF7AA095); // Myk sag grønn
  static const accentGold = Color(0xFFD4AF37); // Gull aksent
  static const surfaceLight = Color(0xFFF8F9F6); // Kremhvit
  static final backgroundGreen = const Color(0xFF2E5D4F);

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
      surfaceLight,
      Colors.white,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final backgroundGradient = LinearGradient(
    colors: [
      backgroundGreen.withOpacity(0.95),
      primaryGreen.withOpacity(0.8),
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
    color: Colors.white.withOpacity(0.95),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 20,
        offset: const Offset(0, -5),
        spreadRadius: 0,
      ),
    ],
  );

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
