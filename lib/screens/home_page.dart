import 'package:flutter/material.dart';
import 'package:weddingwebapp2025/utils/app_theme.dart';
import 'package:weddingwebapp2025/widgets/navigation_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;

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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
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
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.all(16),
                  title: const Text(
                    'Frida & John Michael',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1.2,
                      fontSize: 28,
                    ),
                  ),
                  background: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.darken,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.backgroundGradient,
                      ),
                      child: const Center(
                        child: Text(
                          '27. - 28. juni 2025',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
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
