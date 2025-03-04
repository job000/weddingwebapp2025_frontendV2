import 'package:flutter/material.dart';
import 'package:weddingwebapp2025/screens/rsvp_page.dart';
import 'package:weddingwebapp2025/utils/app_routes.dart';
import 'package:weddingwebapp2025/utils/app_theme.dart';

void main() {
  // Registrerer webview for Google Forms iframe
  RSVPPage.registerWebView();

  runApp(const WeddingApp());
}

class WeddingApp extends StatelessWidget {
  const WeddingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frida & John Michael | Bryllup 2025',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: AppRoutes.home, // Endret til å starte direkte på hjemmesiden
      routes: AppRoutes.routes,
    );
  }
}

// Fjernet SplashScreen klassen siden den ikke lenger trengs
