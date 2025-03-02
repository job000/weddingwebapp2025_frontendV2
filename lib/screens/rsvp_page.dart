import 'package:flutter/material.dart';
import 'package:weddingwebapp2025/utils/app_theme.dart';
import 'package:weddingwebapp2025/widgets/navigation_menu.dart';

class RSVPPage extends StatefulWidget {
  const RSVPPage({super.key});

  @override
  State<RSVPPage> createState() => _RSVPPageState();
}

class _RSVPPageState extends State<RSVPPage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  bool _isAttending = true;
  int _numberOfGuests = 1;
  String? _dietaryRequirements;
  bool _needsAccommodation = false;
  bool _isSubmitting = false;

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
                    title: const Text('RSVP'),
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
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vi håper du kommer!',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                              const SizedBox(height: 40),
                              _buildRSVPCard(),
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

  Widget _buildRSVPCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.modernShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAttendanceSwitch(),
              const SizedBox(height: 32),
              if (_isAttending) ...[
                _buildAnimatedSection(
                  _buildGuestCounter(),
                  delay: 0.2,
                ),
                const SizedBox(height: 32),
                _buildAnimatedSection(
                  _buildDietaryField(),
                  delay: 0.3,
                ),
                const SizedBox(height: 32),
                _buildAnimatedSection(
                  _buildAccommodationField(),
                  delay: 0.4,
                ),
                const SizedBox(height: 40),
              ],
              Center(child: _buildSubmitButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSection(Widget child, {required double delay}) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            delay,
            delay + 0.3,
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _controller,
          curve: Interval(
            delay,
            delay + 0.3,
            curve: Curves.easeOut,
          ),
        ),
        child: child,
      ),
    );
  }

  Widget _buildAttendanceSwitch() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSwitchOption(
              text: 'Jeg kommer',
              isSelected: _isAttending,
              onTap: () => setState(() => _isAttending = true),
            ),
          ),
          Expanded(
            child: _buildSwitchOption(
              text: 'Kan dessverre ikke',
              isSelected: !_isAttending,
              onTap: () => setState(() => _isAttending = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchOption({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildGuestCounter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Antall gjester',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryGreen,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCounterButton(
              icon: Icons.remove,
              onTap: _numberOfGuests > 1
                  ? () => setState(() => _numberOfGuests--)
                  : null,
            ),
            Container(
              width: 80,
              alignment: Alignment.center,
              child: Text(
                _numberOfGuests.toString(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            _buildCounterButton(
              icon: Icons.add,
              onTap: _numberOfGuests < 10
                  ? () => setState(() => _numberOfGuests++)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isEnabled
              ? AppTheme.primaryGreen.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isEnabled ? AppTheme.primaryGreen : Colors.grey,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildDietaryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Allergier eller diettbehov?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryGreen,
              ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Fortell oss om eventuelle matallergier...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.primaryGreen,
              ),
            ),
          ),
          maxLines: 3,
          onChanged: (value) => _dietaryRequirements = value,
        ),
      ],
    );
  }

  Widget _buildAccommodationField() {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: _needsAccommodation,
              onChanged: (value) =>
                  setState(() => _needsAccommodation = value!),
              activeColor: AppTheme.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Jeg trenger overnatting',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black87,
              ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 56,
      width: _isSubmitting ? 56 : 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_isSubmitting ? 28 : 12),
          ),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        onPressed: _handleSubmit,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSubmitting
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  _isAttending ? 'Send påmelding' : 'Send avbud',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simuler en nettverksforsinkelse
    await Future.delayed(const Duration(seconds: 2));

    // Her ville vi normalt sende dataene til en server
    print('Form submitted with dietary requirements: $_dietaryRequirements');

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAttending
              ? 'Takk for påmeldingen!'
              : 'Takk for beskjeden, vi beklager at du ikke kan komme.',
        ),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
