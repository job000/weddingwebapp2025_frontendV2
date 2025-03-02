import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:weddingwebapp2025/utils/app_theme.dart';
import 'package:weddingwebapp2025/widgets/navigation_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;

  // Bilder for slideshow - oppdatert med faktiske bilder
  final List<String> _backgroundImages = [
    'assets/images/wedding_background.jpg'
  ];

  int _currentImageIndex = 0;
  Timer? _imageChangeTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _cardAnimations = List.generate(3, (index) {
      return CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.2,
          0.6 + (index * 0.2),
          curve: Curves.easeOutCubic,
        ),
      );
    });

    _animationController.forward();

    // Start bildebytte-timer
    _startImageChangeTimer();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    _imageChangeTimer?.cancel();
    super.dispose();
  }

  void _startImageChangeTimer() {
    _imageChangeTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_backgroundImages.length > 1) {
        setState(() {
          // Velg et tilfeldig bilde som ikke er det nåværende
          int nextIndex;
          do {
            nextIndex = _random.nextInt(_backgroundImages.length);
          } while (nextIndex == _currentImageIndex);

          _currentImageIndex = nextIndex;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.6,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.transparent,
                collapsedHeight: kToolbarHeight,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double percent =
                        (constraints.maxHeight - kToolbarHeight) /
                            (MediaQuery.of(context).size.height * 0.6 -
                                kToolbarHeight);

                    return FlexibleSpaceBar(
                      stretchModes: const [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                      ],
                      titlePadding: EdgeInsets.zero,
                      title: Container(
                        width: double.infinity,
                        color: percent < 0.5
                            ? Colors.black.withOpacity(0.3)
                            : Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Text(
                            'Frida & John Michael',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.2,
                              fontSize: percent > 0.6 ? 24 : 20,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          ColoredBox(
                            color: AppTheme.primaryGreen.withOpacity(0.8),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 1000),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                              child: Image.asset(
                                _backgroundImages[_currentImageIndex],
                                key: ValueKey<int>(_currentImageIndex),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback til nettverksbilde hvis det lokale bildet ikke lastes
                                  return Image.network(
                                    'https://images.unsplash.com/photo-1523438885200-e635ba2c371e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2274&q=80',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                          size: 64,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.25,
                            left: 0,
                            right: 0,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: percent > 0.5 ? 1.0 : 0.0,
                              child: const Text(
                                '27. - 28. juni 2025',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 32),
                    _buildAnimatedHeader(_cardAnimations[0]),
                    const SizedBox(height: 48),
                    _buildAnimatedCard(
                      _cardAnimations[1],
                      'Vielse',
                      '27. juni 2025, kl. 12:00',
                      'Intim seremoni for nær familie',
                      Icons.favorite,
                    ),
                    const SizedBox(height: 24),
                    _buildAnimatedCard(
                      _cardAnimations[2],
                      'Bryllupsfest',
                      '28. juni 2025, kl. 15:00',
                      'Bestemorstua, Bodø',
                      Icons.celebration,
                    ),
                    const SizedBox(height: 100), // Space for bottom nav
                  ]),
                ),
              ),
            ],
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NavigationMenu(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedHeader(Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(animation),
        child: Column(
          children: [
            Text(
              'Vi gifter oss!',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w200,
                    letterSpacing: -0.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Det er med stor glede vi inviterer deg til å feire vår store dag sammen med oss.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black87,
                    letterSpacing: 0.3,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(
    Animation<double> animation,
    String title,
    String date,
    String description,
    IconData icon,
  ) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(animation),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: AppTheme.cardGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppTheme.modernShadow,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 48,
                color: AppTheme.primaryGreen,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                      color: AppTheme.primaryGreen,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                date,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppTheme.secondaryGreen,
                      letterSpacing: 0.3,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black54,
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
