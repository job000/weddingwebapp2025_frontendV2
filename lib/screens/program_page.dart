//Ignore import of 'package:weddingwebapp2025/utils/flying_doves_animation.dart' because it is not used.

import 'package:flutter/material.dart';
import 'package:weddingwebapp2025/models/timeline_event.dart';
import 'package:weddingwebapp2025/utils/app_theme.dart';
import 'package:weddingwebapp2025/widgets/navigation_menu.dart';
//import 'package:weddingwebapp2025/utils/flying_doves_animation.dart';

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
    TimelineEvent('13:00', 'Vielse med nær familie'),
    //TimelineEvent('12:30', 'Lunsj'),
    //TimelineEvent('15:00', 'Badstue og bading for de som ønsker'),
    TimelineEvent('18:00', 'Mer info kommer...'),
    //TimelineEvent('19:00', 'Middag med familiene'),
  ];

  final _saturdayEvents = [
    TimelineEvent('17:00', 'Ankomst gjester til Bestemorstua'),
    TimelineEvent('17:30', 'Velkomstdrink'),
    //TimelineEvent('19:30', 'Taler og underholdning'),
    //TimelineEvent('21:00', 'Kake og kaffe'),
    //TimelineEvent('22:00', 'Dans og fest'),
    TimelineEvent('18:00', 'Mer info kommer'),
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
      drawer: NavigationMenu.buildDrawer(context), // Legger til drawer
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
                  expandedHeight: 250,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false, // Fjerner tilbake-knappen
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text('Program'),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://images.unsplash.com/photo-1469371670807-013ccf25f16a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppTheme.primaryGreen,
                              child: const Center(
                                child: Icon(
                                  Icons.event,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: AppTheme.maxContentWidth,
                          ),
                          child: Column(
                            children: [
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
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          // Legg til de flygende duene
          /*TODO: kommentere ut for å legge til de flygende duene
          Positioned.fill(
            child: FlyingDovesAnimation(
              numberOfDoves: 5,
              doveColor: Colors.white.withOpacity(0.8),
            ),
          ),
          */

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
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  dayTitle.contains('Fredag')
                      ? 'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80' // Nytt bilde for fredag
                      : 'https://images.unsplash.com/photo-1522413452208-996ff3f3e740?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80', // Nytt bilde for lørdag
                  height: 160, // Økt høyde for bildene
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 160,
                      color: AppTheme.primaryGreen.withOpacity(0.2),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Text(
                  dayTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
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
