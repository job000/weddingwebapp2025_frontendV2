// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:weddingwebapp2025/utils/app_routes.dart';
import 'package:weddingwebapp2025/utils/app_theme.dart';

class NavigationMenu extends StatefulWidget {
  final bool showBackButton;
  // Statisk variabel som holder på hover-tilstand for drawer-elementer
  static final Map<String, bool> _drawerHoverStates = {};

  const NavigationMenu({
    super.key,
    this.showBackButton = false,
  });

  // Statisk metode for å bygge drawer-innholdet
  static Drawer buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer header med brudeparbilde eller logo
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryGreen.withOpacity(0.9),
                    AppTheme.secondaryGreen.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      width: 64,
                      height: 64,
                      color: Colors.white.withOpacity(0.3),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Frida & John Michael',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        '27.-28. juni 2025',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Menyelementer
            _buildDrawerItem(
              context,
              'Hjem',
              AppRoutes.home,
              Icons.home_outlined,
            ),
            _buildDrawerItem(
              context,
              'Program',
              AppRoutes.program,
              Icons.event_note_outlined,
            ),
            _buildDrawerItem(
              context,
              'Sted',
              AppRoutes.location,
              Icons.location_on_outlined,
            ),
            _buildDrawerItem(
              context,
              'Info',
              AppRoutes.info,
              Icons.info_outline,
            ),
            _buildDrawerItem(
              context,
              'RSVP',
              AppRoutes.rsvp,
              Icons.check_circle_outline,
            ),
            _buildDrawerItem(
              context,
              'Bildegalleri',
              AppRoutes.gallery,
              Icons.photo_library_outlined,
            ),

            const Spacer(),

            // Footer-seksjon
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '© 2025 Frida & John Michael',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper-metode for å bygge drawer-element
  static Widget _buildDrawerItem(
    BuildContext context,
    String label,
    String route,
    IconData icon,
  ) {
    final bool isSelected = ModalRoute.of(context)?.settings.name == route;

    return StatefulBuilder(
      builder: (context, setState) {
        final bool isHovered = _drawerHoverStates[route] ?? false;

        return MouseRegion(
          onEnter: (_) => setState(() => _drawerHoverStates[route] = true),
          onExit: (_) => setState(() => _drawerHoverStates[route] = false),
          cursor: SystemMouseCursors.click,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context); // Lukk drawer først
                Navigator.pushReplacementNamed(context, route);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryGreen.withOpacity(0.1)
                      : isHovered
                          ? AppTheme.tertiaryGreen.withOpacity(0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: isSelected || isHovered
                          ? AppTheme.primaryGreen
                          : Colors.grey.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 24),
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected || isHovered
                            ? AppTheme.primaryGreen
                            : Colors.grey.shade800,
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (isSelected)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu>
    with SingleTickerProviderStateMixin {
  final Map<String, bool> _isHovered = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isVisible = true;
  ScrollController? _scrollController;
  double _lastScrollPos = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scrollController == null) {
      _scrollController = PrimaryScrollController.of(context);
      _scrollController?.addListener(_scrollListener);
    }
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _fadeController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController == null) return;

    final currentScroll = _scrollController!.position.pixels;
    if ((currentScroll - _lastScrollPos).abs() > 50) {
      setState(() {
        _isVisible = currentScroll < _lastScrollPos;
        _lastScrollPos = currentScroll;
      });
    }
  }

  void _openDrawer(BuildContext context) {
    // Bruk den mest oppdaterte måten å åpne drawer
    Scaffold.maybeOf(context)?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: Offset(0, _isVisible ? 0 : 1),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Builder(builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            height: 60 + MediaQuery.of(context).padding.bottom,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).padding.bottom > 0 ? 8 : 0,
              top: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Hjem-ikon venstre side
                _buildHomeButton(context),

                // Tittel i midten
                Text(
                  'F & JM',
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    letterSpacing: 1.2,
                  ),
                ),

                // Burger-meny høyre side
                _buildMenuButton(context),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        final isHovered = _isHovered['home'] ?? false;

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered['home'] = true),
          onExit: (_) => setState(() => _isHovered['home'] = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isHovered
                    ? AppTheme.primaryGreen.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: isHovered ? 1.1 : 1.0,
                  child: Icon(
                    Icons.home_outlined,
                    color: AppTheme.primaryGreen,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        final isHovered = _isHovered['menu'] ?? false;

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered['menu'] = true),
          onExit: (_) => setState(() => _isHovered['menu'] = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              _openDrawer(context);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isHovered
                    ? AppTheme.primaryGreen.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: isHovered ? 1.1 : 1.0,
                  child: Icon(
                    Icons.menu_rounded,
                    color: AppTheme.primaryGreen,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
