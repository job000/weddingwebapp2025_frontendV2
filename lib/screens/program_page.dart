import 'package:flutter/material.dart';
import 'package:weddingwebapp2025/models/timeline_event.dart';
import 'package:weddingwebapp2025/utils/app_theme.dart';
import 'package:weddingwebapp2025/widgets/navigation_menu.dart';

class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key});

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _controller;
  late List<Animation<double>> _timelineAnimations;

  final _fridayEvents = [
    TimelineEvent('12:00', 'Vielse med nær familie'),
    TimelineEvent('13:30', 'Lunsj'),
    TimelineEvent('15:00', 'Badstue og bading for de som ønsker'),
    TimelineEvent('19:00', 'Middag med familiene'),
  ];

  final _saturdayEvents = [
    TimelineEvent('15:00', 'Ankomst gjester til Bestemorstua'),
    TimelineEvent('16:00', 'Velkomstdrink'),
    TimelineEvent('17:00', 'Middag serveres'),
    TimelineEvent('19:30', 'Taler og underholdning'),
    TimelineEvent('21:00', 'Kake og kaffe'),
    TimelineEvent('22:00', 'Dans og fest'),
    TimelineEvent('01:00', 'Baren stenger'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    final totalEvents = _fridayEvents.length + _saturdayEvents.length;
    _timelineAnimations = List.generate(totalEvents, (index) {
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(
          (index * 0.1).clamp(0.0, 1.0),
          ((index * 0.1) + 0.5).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic,
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  stretch: true,
                  expandedHeight: 200,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text('Program'),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryGreen.withOpacity(0.7),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildDaySection(
                        context,
                        'Fredag 27. juni',
                        _fridayEvents,
                        0,
                      ),
                      const SizedBox(height: 48),
                      _buildDaySection(
                        context,
                        'Lørdag 28. juni',
                        _saturdayEvents,
                        _fridayEvents.length,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NavigationMenu(showBackButton: true),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySection(
    BuildContext context,
    String dayTitle,
    List<TimelineEvent> events,
    int animationOffset,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            dayTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...List.generate(events.length, (index) {
          return _buildTimelineItem(
            context,
            events[index],
            index == events.length - 1,
            _timelineAnimations[index + animationOffset],
            index,
          );
        }),
      ],
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    TimelineEvent event,
    bool isLast,
    Animation<double> animation,
    int index,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: Stack(
              children: [
                if (!isLast)
                  Positioned(
                    left: 40,
                    top: 40,
                    bottom: 0,
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryGreen.withOpacity(0.5),
                            AppTheme.primaryGreen.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          event.time,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: AppTheme.cardGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: AppTheme.modernShadow,
                          ),
                          child: Text(
                            event.description,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.black87,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
