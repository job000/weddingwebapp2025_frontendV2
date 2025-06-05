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

  // Bilder for slideshow - oppdatert med bryllupsrelaterte bakgrunnsbilder uten personer
  final List<String> _backgroundImages = [
    'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3270&q=80', // Dekorasjonsdetaljer
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
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      drawer: NavigationMenu.buildDrawer(context),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height *
                    0.7, // Gjør bildet høyere
                pinned: true,
                stretch: true,
                backgroundColor: Colors.transparent,
                collapsedHeight: kToolbarHeight,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double percent =
                        (constraints.maxHeight - kToolbarHeight) /
                            (MediaQuery.of(context).size.height * 0.7 -
                                kToolbarHeight);

                    return FlexibleSpaceBar(
                      stretchModes: const [
                        StretchMode.zoomBackground,
                      ],
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Container med fargebakgrunn som fallback
                          Container(color: Colors.white),

                          // Bakgrunnsbilde som dekker hele bredden
                          FadeTransition(
                            opacity: const AlwaysStoppedAnimation(1.0),
                            child: Image.network(
                              _backgroundImages[_currentImageIndex],
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              width: screenSize.width,
                              height: screenSize.height * 0.7,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.white,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                      size: 64,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Mørkt overlay for bedre tekstlesbarhet
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.5),
                                  Colors.black.withOpacity(0.7),
                                ],
                                stops: const [0.0, 0.5, 0.9],
                              ),
                            ),
                          ),

                          // Innhold over bildet
                          Positioned(
                            bottom: 60,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  const Text(
                                    'Frida & John Michael',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    '27. - 28. juni 2025',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 30),
                                  Container(
                                    height: 2,
                                    width: 60,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ],
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
                      '27. juni 2025, kl. 13:00',
                      'Intim seremoni for nær familie.',
                      Icons.favorite,
                    ),
                    const SizedBox(height: 24),
                    _buildAnimatedCard(
                      _cardAnimations[2],
                      'Sosial sammenkomst',
                      '27. juni 2025, kl. 18:30',
                      'Bli kjent kveld - Vi møtes på Fauna Sauna. Det blir badstu, bading og forfriskninger.',
                      Icons.people,
                    ),
                    const SizedBox(height: 24),
                    _buildAnimatedCard(
                      _cardAnimations[2],
                      'Bryllupsfest',
                      '28. juni 2025, kl. 16:30',
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
