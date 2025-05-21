import 'dart:ui';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:weddingwebapp2025/utils/app_theme.dart';
import 'package:weddingwebapp2025/widgets/navigation_menu.dart';

class WeddingPlaylistPage extends StatefulWidget {
  const WeddingPlaylistPage({super.key});

  @override
  State<WeddingPlaylistPage> createState() => _WeddingPlaylistPageState();
}

class _WeddingPlaylistPageState extends State<WeddingPlaylistPage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // "Wedding2025" spilleliste ID
  final String weddingPlaylistId = '6D6A98eObtHs6FJtvRq0Te';

  // Unik ID for Spotify iframe
  final String _spotifyIframeId = 'spotify-iframe-player';

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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();

    // Setter opp Spotify iframe når siden lastes
    _setupSpotifyIframe();
  }

  // Setter opp Spotify iframe direkte
  void _setupSpotifyIframe() {
    // Fjern eventuelle gamle iframes
    final oldIframe = html.document.getElementById(_spotifyIframeId);
    if (oldIframe != null) {
      oldIframe.remove();
    }

    // Opprett et div-element som holder iframen
    final containerDiv = html.DivElement()
      ..id = 'spotify-embed-container'
      ..style.width = '100%'
      ..style.height = '380px'
      ..style.position = 'absolute'
      ..style.top = '0'
      ..style.left = '0'
      ..style.borderRadius = '12px'
      ..style.overflow = 'hidden';

    // Opprett iframe-elementet
    final iframeElement = html.IFrameElement()
      ..id = _spotifyIframeId
      ..style.border = 'none'
      ..width = '100%'
      ..height = '100%'
      ..style.borderRadius = '12px'
      ..src =
          'https://open.spotify.com/embed/playlist/$weddingPlaylistId?utm_source=generator&theme=0';

    // Sett attributter for tillatelser
    iframeElement.setAttribute('allowfullscreen', 'true');
    iframeElement.setAttribute('allow',
        'autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture');

    // Legg iframe til containeren
    containerDiv.children.add(iframeElement);

    // Legg til containeren i dokumentet
    html.document.body?.children.add(containerDiv);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();

    // Fjern Spotify iframe når siden lukkes
    final spotifyFrame = html.document.getElementById(_spotifyIframeId);
    final container = html.document.getElementById('spotify-embed-container');
    if (spotifyFrame != null) {
      spotifyFrame.remove();
    }
    if (container != null) {
      container.remove();
    }

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
                    title: const Text('Bryllupspilleliste'),
                    titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.darken,
                          color: Colors.black.withOpacity(0.3),
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppTheme.primaryGreen.withOpacity(0.8),
                              child: Center(
                                child: Icon(
                                  Icons.music_note,
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
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: AppTheme.maxContentWidth,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'La oss danse sammen!',
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
                                    'Bidra til vår bryllupsspilleliste',
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
                                  _buildSpotifyEmbedCard(),
                                ],
                              ),
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

  Widget _buildSpotifyEmbedCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.modernShadow,
        border: Border.all(
          color: Colors.white.withOpacity(0.6),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.queue_music_rounded,
            size: 48,
            color: AppTheme.primaryGreen,
          ),
          const SizedBox(height: 24),
          Text(
            'Wedding2025',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Vi har laget en felles spilleliste som vi ønsker å fylle med deres favorittlåter! Legg til sanger du vil danse til på festen, og hjelp oss å skape den perfekte stemningen for kvelden.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black87,
                  height: 1.6,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Spotify embedded player
          Container(
            height: 380,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            // Denne containeren fungerer som et plassholder der vi kan vise Spotify iframe
            child: _buildSpotifyIframeContainer(),
          ),

          const SizedBox(height: 24),

          // Knapp for å åpne spillelisten i Spotify
          ElevatedButton.icon(
            onPressed: _openSpotifyPlaylist,
            icon: const Icon(Icons.open_in_new),
            label: const Text('Åpne i Spotify'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'Du kan bidra med sanger ved å legge til i spillelisten direkte',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Alle sangforslag blir gjennomgått før bryllupet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryGreen,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Bruker en HtmlElementView som viser en HTML iframe direkte
  Widget _buildSpotifyIframeContainer() {
    // I stedet for å prøve å bruke HtmlElementView, bruker vi et trick for å posisjonere html.DivElement
    // med Spotify iframe som ble opprettet i _setupSpotifyIframe
    return Stack(
      children: [
        // Denne funksjonen flytter iframe til riktig posisjon når den bygges
        Builder(
          builder: (context) {
            // Vent til widgets er bygget
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _positionSpotifyIframe();
            });
            return const SizedBox.expand();
          },
        ),

        // Fallback hvis iframe ikke lastes
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.primaryGreen,
              ),
              const SizedBox(height: 16),
              Text(
                'Laster spilleliste...',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Posisjonerer Spotify iframe relativt til containeren
  void _positionSpotifyIframe() {
    try {
      // Finn beholderen vi laget og posisjoner iframe der
      final container = html.document.getElementById('spotify-embed-container');
      if (container != null) {
        // Bruk JavaScript til å finne posisjonen til spilleliste-containeren i Flutter
        final result = js.context.callMethod('eval', [
          '''
          (function() {
            var elements = document.getElementsByClassName('flutter-widget');
            for (var i = 0; i < elements.length; i++) {
              var el = elements[i];
              // Finn elementet som inneholder spillelistecontaineren
              if (el.innerText && el.innerText.includes('Wedding2025')) {
                var rect = el.getBoundingClientRect();
                return {
                  top: rect.top + window.scrollY + 230, // Justering for å treffe spilleliste-containeren
                  left: rect.left + window.scrollX + 32,
                  width: rect.width - 64, // Juster for padding
                };
              }
            }
            return null;
          })()
          '''
        ]);

        // Hvis vi fant elementet, posisjoner iframe-containeren der
        if (result != null) {
          container.style.position = 'fixed';
          container.style.top = '${result['top']}px';
          container.style.left = '${result['left']}px';
          container.style.width = '${result['width']}px';
          container.style.zIndex =
              '1000'; // Høy z-index for å vise over andre elementer

          // Gjør containeren synlig
          container.style.display = 'block';
        }
      }
    } catch (e) {
      print('Feil ved posisjonering av Spotify iframe: $e');
    }
  }

  // Åpner Spotify-spilleliste i en ny fane eller i Spotify-app hvis tilgjengelig
  void _openSpotifyPlaylist() {
    final url = 'https://open.spotify.com/playlist/$weddingPlaylistId';
    try {
      _openUrlInNewTab(url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Kunne ikke åpne spillelisten. Prøv å kopiere URL-en manuelt.'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  // Bruker JavaScript til å åpne en URL i en ny fane
  void _openUrlInNewTab(String url) {
    js.context.callMethod('openUrlExternally', [url]);
  }
}
