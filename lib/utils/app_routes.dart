import 'package:flutter/material.dart';
import 'package:weddingwebapp2025/screens/home_page.dart';
import 'package:weddingwebapp2025/screens/program_page.dart';
import 'package:weddingwebapp2025/screens/location_page.dart';
import 'package:weddingwebapp2025/screens/info_page.dart';
import 'package:weddingwebapp2025/screens/rsvp_page.dart';
import 'package:weddingwebapp2025/screens/gallery_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String program = '/program';
  static const String location = '/location';
  static const String info = '/info';
  static const String rsvp = '/rsvp';
  static const String gallery = '/gallery';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    program: (context) => const ProgramPage(),
    location: (context) => const LocationPage(),
    info: (context) => const InfoPage(),
    rsvp: (context) => const RSVPPage(),
    gallery: (context) => const GalleryPage(),
  };
}
