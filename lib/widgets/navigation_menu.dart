import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weddingwebapp2025/utils/app_routes.dart';
import 'package:weddingwebapp2025/utils/app_theme.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final Map<String, bool> _isHovered = {};
  bool _isVisible = true;
  ScrollController? _scrollController;
  double _lastScrollPos = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scrollController == null) {
      _scrollController = PrimaryScrollController.of(context);
      _scrollController?.addListener(_scrollListener);
    }
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
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: AppTheme.bottomNavDecoration,
          child: SafeArea(
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    'Program',
                    AppRoutes.program,
                    Icons.event_note_outlined,
                  ),
                  _buildNavItem(
                    'Sted',
                    AppRoutes.location,
                    Icons.location_on_outlined,
                  ),
                  _buildNavItem(
                    'Info',
                    AppRoutes.info,
                    Icons.info_outline,
                  ),
                  _buildNavItem(
                    'RSVP',
                    AppRoutes.rsvp,
                    Icons.favorite_outline,
                    isPrimary: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: 0,
          right: 0,
          bottom: _isVisible ? 0 : -80,
          child: Container(),
        ),
      ],
    );
  }

  Widget _buildNavItem(
    String label,
    String route,
    IconData icon, {
    bool isPrimary = false,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        final bool isHovered = _isHovered[route] ?? false;
        final bool isSelected = ModalRoute.of(context)?.settings.name == route;

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered[route] = true),
          onExit: (_) => setState(() => _isHovered[route] = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.pushNamed(context, route);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: isPrimary ? 8 : 4,
              ),
              decoration: BoxDecoration(
                color: isPrimary
                    ? (isHovered
                        ? AppTheme.primaryGreen
                        : AppTheme.secondaryGreen)
                    : (isSelected ? AppTheme.surfaceLight : Colors.transparent),
                borderRadius: BorderRadius.circular(24),
                border: isPrimary
                    ? null
                    : Border.all(
                        color: isSelected
                            ? AppTheme.primaryGreen
                            : Colors.transparent,
                        width: 1.5,
                      ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: isPrimary
                        ? Colors.white
                        : (isSelected ? AppTheme.primaryGreen : Colors.grey),
                    size: isPrimary ? 24 : 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: isPrimary
                          ? Colors.white
                          : (isSelected ? AppTheme.primaryGreen : Colors.grey),
                      fontSize: isPrimary ? 14 : 12,
                      fontWeight: isPrimary || isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
