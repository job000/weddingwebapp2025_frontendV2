import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flying Doves Animation Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flying Doves Animation'),
        ),
        body: Stack(
          children: [
            // Bakgrunn (kan tilpasses)
            Container(color: Colors.blueGrey[100]),
            // Flygende duver
            const FlyingDovesAnimation(
              numberOfDoves: 5,
              doveColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class FlyingDovesAnimation extends StatefulWidget {
  final int numberOfDoves;
  final Color doveColor;

  const FlyingDovesAnimation({
    Key? key,
    this.numberOfDoves = 5,
    this.doveColor = Colors.white,
  }) : super(key: key);

  @override
  State<FlyingDovesAnimation> createState() => _FlyingDovesAnimationState();
}

class _FlyingDovesAnimationState extends State<FlyingDovesAnimation>
    with TickerProviderStateMixin {
  final List<DoveData> _doves = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeDoves();
  }

  @override
  void dispose() {
    for (var dove in _doves) {
      dove.controller.dispose();
    }
    super.dispose();
  }

  void _initializeDoves() {
    // Lag en litt forsinket start for hver due
    for (int i = 0; i < widget.numberOfDoves; i++) {
      Future.delayed(Duration(milliseconds: i * 500), () {
        if (mounted) {
          _createDove();
        }
      });
    }
    // Periodisk generering av nye duver
    Timer.periodic(const Duration(seconds: 8), (timer) {
      if (mounted && _doves.length < widget.numberOfDoves) {
        _createDove();
      }
    });
  }

  void _createDove() {
    if (!mounted) return;

    // Bestem tilfeldig om duen skal starte fra høyre eller venstre
    final startFromRight = _random.nextBool();
    final startX =
        startFromRight ? MediaQuery.of(context).size.width + 50.0 : -50.0;
    final startY =
        MediaQuery.of(context).size.height * (0.4 + _random.nextDouble() * 0.3);
    // Varier størrelsen litt for variasjon
    final size = 30.0 + _random.nextDouble() * 20.0;
    // Tilfeldig varighet for flyt
    final duration = Duration(seconds: 8 + _random.nextInt(7));

    final controller = AnimationController(
      duration: duration,
      vsync: this,
    );

    // Beregn sluttposisjon slik at duen flyr over skjermen
    final endX =
        startFromRight ? -100.0 : MediaQuery.of(context).size.width + 100.0;
    final endY = startY - 100.0 - _random.nextDouble() * 150;

    final pathAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutSine,
    );

    final flapAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    );

    setState(() {
      _doves.add(DoveData(
        controller: controller,
        pathAnimation: pathAnimation,
        flapAnimation: flapAnimation,
        startX: startX,
        startY: startY,
        endX: endX,
        endY: endY,
        size: size,
        direction: startFromRight ? -1 : 1,
      ));
    });

    // Start animasjonen og fjern duen når den er ferdig
    controller.forward().then((_) {
      if (mounted) {
        setState(() {
          _doves.removeWhere((dove) => dove.controller == controller);
        });
        controller.dispose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (var dove in _doves)
          AnimatedBuilder(
            animation: dove.controller,
            builder: (context, child) {
              // Beregn posisjon langs banen
              final double posX = dove.startX +
                  (dove.endX - dove.startX) * dove.pathAnimation.value;
              final double posY = dove.startY +
                  (dove.endY - dove.startY) * dove.pathAnimation.value;

              // Legg til en bølgeeffekt i bevegelsen
              final waveY = sin(dove.pathAnimation.value * 3 * pi) * 15;
              // Bruk sinus for å animere vingeslag (verdi mellom 0 og 1)
              final flapValue = sin(dove.flapAnimation.value * 15 * pi).abs();

              return Positioned(
                left: posX,
                top: posY + waveY,
                child: Transform.scale(
                  scale: dove.direction > 0 ? 1 : -1,
                  child: CustomPaint(
                    painter: DovePainter(
                      flapValue: flapValue,
                      color: widget.doveColor,
                    ),
                    size: Size(dove.size, dove.size),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class DoveData {
  final AnimationController controller;
  final Animation<double> pathAnimation;
  final Animation<double> flapAnimation;
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final double size;
  final int direction; // 1 for høyre, -1 for venstre

  DoveData({
    required this.controller,
    required this.pathAnimation,
    required this.flapAnimation,
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.size,
    required this.direction,
  });
}

class DovePainter extends CustomPainter {
  final double flapValue;
  final Color color;

  DovePainter({
    required this.flapValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Tegn kroppen med cubic curves for en jevnere form
    final bodyPath = Path();
    bodyPath.moveTo(size.width * 0.5, size.height * 0.5);
    bodyPath.cubicTo(
      size.width * 0.7,
      size.height * 0.3,
      size.width * 0.9,
      size.height * 0.6,
      size.width * 0.5,
      size.height * 0.8,
    );
    bodyPath.cubicTo(
      size.width * 0.1,
      size.height * 0.6,
      size.width * 0.3,
      size.height * 0.3,
      size.width * 0.5,
      size.height * 0.5,
    );
    canvas.drawPath(bodyPath, paint);

    // Venstre vinge
    final leftWing = Path();
    leftWing.moveTo(size.width * 0.5, size.height * 0.5);
    leftWing.cubicTo(
      size.width * 0.3,
      size.height * (0.5 - flapValue * 0.3),
      size.width * 0.1,
      size.height * 0.4,
      size.width * 0.2,
      size.height * 0.2,
    );
    canvas.drawPath(leftWing, paint);

    // Høyre vinge
    final rightWing = Path();
    rightWing.moveTo(size.width * 0.5, size.height * 0.5);
    rightWing.cubicTo(
      size.width * 0.7,
      size.height * (0.5 - flapValue * 0.3),
      size.width * 0.9,
      size.height * 0.4,
      size.width * 0.8,
      size.height * 0.2,
    );
    canvas.drawPath(rightWing, paint);

    // Tegn halen
    final tailPath = Path();
    tailPath.moveTo(size.width * 0.45, size.height * 0.8);
    tailPath.cubicTo(
      size.width * 0.5,
      size.height,
      size.width * 0.5,
      size.height,
      size.width * 0.55,
      size.height * 0.8,
    );
    canvas.drawPath(tailPath, paint);

    // Legg til et øye for ekstra realisme
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.55, size.height * 0.45),
      size.width * 0.05,
      eyePaint,
    );
  }

  @override
  bool shouldRepaint(DovePainter oldDelegate) {
    return oldDelegate.flapValue != flapValue;
  }
}
