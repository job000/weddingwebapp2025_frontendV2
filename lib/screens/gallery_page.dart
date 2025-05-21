import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weddingwebapp2025/utils/app_theme.dart';
import 'package:weddingwebapp2025/widgets/navigation_menu.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // Bilder fra assets-mappen
  final List<String> _assetImages = [
    'assets/images/bilde1_medbriller.jpg',
    'assets/images/bilde_2_solbilde.jpg',
    'assets/images/wedding_background.jpg',
  ];

  // Tilleggs-demobildene for galleriet (vil bli erstattet med faktiske bilder senere)
  final List<String> _demoImages = [
    'https://images.unsplash.com/photo-1532712938310-34cb3982ef74?q=80&w=2070',
    'https://images.unsplash.com/photo-1583939003579-730e3918a45a?q=80&w=2070',
    'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?q=80&w=2070',
    'https://images.unsplash.com/photo-1537633552985-df8429e8048b?q=80&w=2070',
    'https://images.unsplash.com/photo-1507504031003-b417219a0fde?q=80&w=2070',
    'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?q=80&w=2070',
  ];

  // Kombinerer både asset- og demo-bilder
  List<String> get _allImages => [..._assetImages, ..._demoImages];

  // Controller for bildekarusellen
  final PageController _featureController = PageController();

  // Holder styr på hover-tilstand for hvert bilde
  final Map<int, bool> _hoverStates = {};

  // Indeks for det valgte bildet i karusellen
  int _selectedImageIndex = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();

    // Start automatisk scrolling for bildekarusell
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return; // Sjekker om widget fortsatt er montert

      setState(() {
        if (_selectedImageIndex < _allImages.length - 1) {
          _selectedImageIndex++;
        } else {
          _selectedImageIndex = 0;
        }
      });

      if (_featureController.hasClients) {
        _featureController.animateToPage(
          _selectedImageIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    _featureController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationMenu.buildDrawer(context),
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
                  expandedHeight: 280,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text('Bildegalleri'),
                    titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?q=80&w=2070',
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.darken,
                          color: Colors.black.withOpacity(0.3),
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppTheme.primaryGreen.withOpacity(0.8),
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 72,
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.5),
                                Colors.transparent,
                                Colors.black.withOpacity(0.5),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.0, 0.5, 1.0],
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
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: AppTheme.maxContentWidth,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Våre øyeblikk',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 1.0,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'En samling av våre minner',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w300,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),

                                // Karussell med fremhevede bilder
                                _buildFeaturedImageSection(),

                                const SizedBox(height: 40),

                                // Rutenett med alle bilder
                                _buildGalleryGrid(),
                              ],
                            ),
                          ),
                        ),
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

  // Bygger seksjonen med fremhevede bilder (karusell)
  Widget _buildFeaturedImageSection() {
    return Container(
      height: 800,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.modernShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Fremhevede bilder',
              style: TextStyle(
                color: AppTheme.primaryGreen,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _featureController,
              onPageChanged: (index) {
                setState(() {
                  _selectedImageIndex = index;
                });
              },
              physics: const BouncingScrollPhysics(),
              itemCount: _allImages.length,
              itemBuilder: (context, index) {
                final imagePath = _allImages[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _buildImage(imagePath, fullSize: true),
                  ),
                );
              },
            ),
          ),

          // Indikatorer som viser hvilket bilde som vises
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _allImages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: index == _selectedImageIndex ? 24 : 8,
                      decoration: BoxDecoration(
                        color: index == _selectedImageIndex
                            ? AppTheme.primaryGreen
                            : AppTheme.tertiaryGreen.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bygger rutenettet med alle bilder
  Widget _buildGalleryGrid() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.modernShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.photo_library,
                color: AppTheme.primaryGreen,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Galleri',
                style: TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Responsivt bilderutenett
          _buildResponsivePhotoGrid(),
        ],
      ),
    );
  }

  // Bygger et responsivt rutenett som tilpasser seg skjermstørrelsen
  Widget _buildResponsivePhotoGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Bestem antall kolonner basert på skjermbredde
        int crossAxisCount = 2;
        if (constraints.maxWidth > 700) {
          crossAxisCount = 3;
        }
        if (constraints.maxWidth > 1000) {
          crossAxisCount = 4;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            // Oppdatert aspect ratio fra 1.0 til 16/9 for bredformatbilder
            childAspectRatio: 1,
          ),
          itemCount: _allImages.length,
          itemBuilder: (context, index) {
            return _buildGridItem(index);
          },
        );
      },
    );
  }

  // Bygger et enkelt bildeelement i rutenettet
  Widget _buildGridItem(int index) {
    final imagePath = _allImages[index];

    return StatefulBuilder(
      builder: (context, setState) {
        final isHovered = _hoverStates[index] ?? false;

        return MouseRegion(
          onEnter: (_) => setState(() => _hoverStates[index] = true),
          onExit: (_) => setState(() => _hoverStates[index] = false),
          child: GestureDetector(
            onTap: () {
              // Når et bilde klikkes, naviger til det i karussellen
              if (_featureController.hasClients) {
                _featureController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );

                // Scroll opp til karussellen
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              transform: isHovered
                  ? (Matrix4.identity()..scale(1.05))
                  : Matrix4.identity(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Selve bildet
                    _buildImage(imagePath),

                    // Overlay ved hover/trykk
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isHovered ? 0.7 : 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppTheme.primaryGreen.withOpacity(0.6),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.zoom_in,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
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

  // Hjelpemetode for å bygge et bilde basert på kilden (asset eller nettverk)
  Widget _buildImage(String imagePath, {bool fullSize = false}) {
    // Bruk BoxFit.contain hvis vi ønsker å vise hele bildet
    final boxFit = fullSize ? BoxFit.contain : BoxFit.cover;

    if (imagePath.startsWith('assets/')) {
      // Asset-bilde
      return Image.asset(
        imagePath,
        fit: boxFit,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImage();
        },
      );
    } else {
      // Nettverksbilde
      return Image.network(
        imagePath,
        fit: boxFit,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryGreen,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImage();
        },
      );
    }
  }

  // Placeholder for bilder som ikke kan lastes
  Widget _buildErrorImage() {
    return Container(
      color: AppTheme.tertiaryGreen.withOpacity(0.3),
      child: Center(
        child: Icon(
          Icons.broken_image,
          color: AppTheme.primaryGreen.withOpacity(0.7),
          size: 36,
        ),
      ),
    );
  }
}
