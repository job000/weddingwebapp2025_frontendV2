import 'package:flutter/material.dart';
import 'package:weddingwebapp2025/utils/app_theme.dart';
import 'package:weddingwebapp2025/widgets/navigation_menu.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

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
                    title: const Text('Praktisk Info'),
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
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            _buildAccommodationCard(),
                            const SizedBox(height: 40),
                            _buildDressCodeSection(),
                            const SizedBox(height: 40),
                            _buildGiftsCard(),
                            const SizedBox(height: 40),
                            _buildAllergiesCard(),
                          ],
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

  Widget _buildAccommodationCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.modernShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.hotel_outlined,
                    color: AppTheme.primaryGreen,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Overnatting',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Vi har reservert rom på Scandic Havet for gjester. Bruk koden "BRYLLUP2025" ved bestilling for å få rabatt. Booking må gjøres før 1. mai 2025 for å benytte rabatten.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black87,
                    height: 1.6,
                  ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Kontakt hotellet direkte på tlf: +47 21 61 40 00 eller e-post: havet@scandichotels.com',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black87,
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
  }

  Widget _buildDressCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 24),
          child: Text(
            'Dresscode',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
        _buildInfoCard(
          'Antrekk',
          'Pent antrekk. Menn kan bruke dress eller pent antrekk, damer kjole eller pent antrekk.',
          Icons.checkroom_outlined,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          'Tips',
          'Været i Bodø kan være uforutsigbart. Ta med en lett jakke eller sjal til kveldsbruk, selv om det er sommer.',
          Icons.wb_sunny_outlined,
        ),
      ],
    );
  }

  Widget _buildGiftsCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.modernShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.card_giftcard_outlined,
                    color: AppTheme.primaryGreen,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Gaver',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Deres tilstedeværelse er den største gaven for oss. Om dere likevel ønsker å gi en gave, setter vi pris på et bidrag til vår bryllupsreise. Gavekonto: 1234.56.78910',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black87,
                    height: 1.6,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergiesCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.modernShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.restaurant_outlined,
                    color: AppTheme.primaryGreen,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Allergier',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Vennligst gi oss beskjed om matallergier eller spesielle diettbehov når du svarer på invitasjonen. Vi ønsker at alle skal kunne nyte maten under festen.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black87,
                    height: 1.6,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Bruk RSVP-skjemaet på nettsiden for å melde fra om allergier eller ring oss direkte på +47 123 45 678.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String description, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.modernShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryGreen,
                size: 24,
              ),
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
    );
  }
}
