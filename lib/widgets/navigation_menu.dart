// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:weddingwebapp2025/utils/app_routes.dart';
import 'package:weddingwebapp2025/utils/app_theme.dart';

class NavigationMenu extends StatefulWidget {
  final bool showBackButton;

  const NavigationMenu({
    super.key,
    this.showBackButton = false,
  });

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu>
    with SingleTickerProviderStateMixin {
  final Map<String, bool> _isHovered = {};
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

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: Offset(0, _isVisible ? 0 : 1),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: AppTheme.bottomNavDecoration,
              child: Container(
                height:
                    60 + MediaQuery.of(context).padding.bottom, // Justert høyde
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).padding.bottom > 0 ? 8 : 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.showBackButton)
                      _buildBackButton()
                    else
                      const SizedBox(width: 40),
                    const SizedBox(width: 24), // Økt mellomrom når hjemknappen vises
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _buildNavItem(
                              'Program',
                              AppRoutes.program,
                              Icons.event_note_outlined,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildNavItem(
                              'Sted',
                              AppRoutes.location,
                              Icons.location_on_outlined,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildNavItem(
                              'Info',
                              AppRoutes.info,
                              Icons.info_outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
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
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isHovered
                    ? AppTheme.primaryGreen.withOpacity(0.15)
                    : AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isHovered
                      ? AppTheme.primaryGreen.withOpacity(0.3)
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: isHovered ? 1.1 : 1.0,
                  child: Icon(
                    Icons.home_outlined,
                    color: AppTheme.primaryGreen,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    String label,
    String route,
    IconData icon,
  ) {
    return StatefulBuilder(
      builder: (context, setState) {
        final bool isHovered = _isHovered[route] ?? false;
        final bool isSelected = ModalRoute.of(context)?.settings.name == route;
        final bool isPressed = _isHovered[route + '_pressed'] ?? false;

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered[route] = true),
          onExit: (_) => setState(() {
            _isHovered[route] = false;
            _isHovered[route + '_pressed'] = false;
          }),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTapDown: (_) =>
                setState(() => _isHovered[route + '_pressed'] = true),
            onTapUp: (_) =>
                setState(() => _isHovered[route + '_pressed'] = false),
            onTapCancel: () =>
                setState(() => _isHovered[route + '_pressed'] = false),
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.pushReplacementNamed(context, route);
            },
            child: Transform.scale(
              scale: isPressed ? 0.95 : 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryGreen.withOpacity(0.1)
                      : (isHovered ? Colors.grey.shade50 : Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected || isHovered
                        ? AppTheme.primaryGreen.withOpacity(0.2)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      color: isSelected || isHovered
                          ? AppTheme.primaryGreen
                          : Colors.grey.shade600,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isSelected || isHovered
                              ? AppTheme.primaryGreen
                              : Colors.grey.shade600,
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
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
}
