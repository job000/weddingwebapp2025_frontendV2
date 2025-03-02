import 'package:flutter/material.dart';
import 'package:weddingwebapp2025/utils/app_theme.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animations = List.generate(3, (index) {
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.2,
          0.6 + (index * 0.2),
          curve: Curves.easeOutCubic,
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Sted'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: _animations[0],
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(_animations[0]),
                    child: Text(
                      'Bestemorstua',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _animations[1],
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(_animations[1]),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.cardGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppTheme.modernShadow,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: AppTheme.primaryGreen,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Bodø',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: AppTheme.primaryGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Bestemorstua er et vakkert lokale med sjarmerende atmosfære og nydelig utsikt. Det er god plass til både middag og dans utover kvelden.',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.black87,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryGreen.withOpacity(0.1),
                                      AppTheme.primaryGreen.withOpacity(0.05),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Kart kommer her',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _animations[2],
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(_animations[2]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transport',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildTransportCard(
                          context,
                          'Fly',
                          'Bodø lufthavn ligger ca. 10 minutter med taxi fra Bestemorstua. Det går daglige avganger fra Oslo, Trondheim og andre større byer.',
                          Icons.flight,
                        ),
                        const SizedBox(height: 16),
                        _buildTransportCard(
                          context,
                          'Shuttle Service',
                          'Det vil bli organisert transport fra sentrale hoteller i Bodø til Bestemorstua for gjestene. Mer informasjon kommer.',
                          Icons.directions_bus,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransportCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.modernShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color: AppTheme.primaryGreen,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
