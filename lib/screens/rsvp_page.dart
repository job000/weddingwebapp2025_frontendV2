import 'package:flutter/material.dart';
import 'package:weddingwebapp2025/utils/app_theme.dart';

class RSVPPage extends StatefulWidget {
  const RSVPPage({super.key});

  @override
  State<RSVPPage> createState() => _RSVPPageState();
}

class _RSVPPageState extends State<RSVPPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  bool _isAttending = true;
  int _numberOfGuests = 1;
  String? _dietaryRequirements;
  bool _needsAccommodation = false;

  @override
  void initState() {
    super.initState();
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('RSVP'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vi håper du kommer!',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                    ),
                    const SizedBox(height: 40),
                    Container(
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
                              const SizedBox(height: 24),
                              if (_isAttending) ...[
                                _buildGuestCounter(),
                                const SizedBox(height: 24),
                                _buildDietaryField(),
                                const SizedBox(height: 24),
                                _buildAccommodationField(),
                                const SizedBox(height: 32),
                              ],
                              Center(
                                child: _buildSubmitButton(),
                              ),
                            ],
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
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: _numberOfGuests > 1
                  ? () => setState(() => _numberOfGuests--)
                  : null,
              color: AppTheme.primaryGreen,
            ),
            Text(
              _numberOfGuests.toString(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: _numberOfGuests < 10
                  ? () => setState(() => _numberOfGuests++)
                  : null,
              color: AppTheme.primaryGreen,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDietaryField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Allergier eller diettbehov?',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryGreen),
        ),
      ),
      maxLines: 3,
      onChanged: (value) => _dietaryRequirements = value,
    );
  }

  Widget _buildAccommodationField() {
    return Row(
      children: [
        Checkbox(
          value: _needsAccommodation,
          onChanged: (value) => setState(() => _needsAccommodation = value!),
          activeColor: AppTheme.primaryGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const Text('Jeg trenger overnatting'),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Temporary form data handling
          print('Form submitted with dietary requirements: $_dietaryRequirements');
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isAttending
                  ? 'Takk for påmeldingen!'
                  : 'Takk for beskjeden, vi beklager at du ikke kan komme.'),
              backgroundColor: AppTheme.primaryGreen,
            ),
          );
        }
      },
      child: Text(
        _isAttending ? 'Send påmelding' : 'Send avbud',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
