import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> with TickerProviderStateMixin {
  // Ring rotation
  late final AnimationController _ringController;

  // Content fade-in (staggered)
  late final AnimationController _fadeController;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<double> _barFade;

  // Loading bar progress
  late final AnimationController _loadController;

  // Pulse for dots
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoFade = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _textFade = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
    );
    _barFade = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    _loadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    // Stagger the start
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _loadController.forward();
    });

    _goToNextScreen();
  }

  @override
  void dispose() {
    _ringController.dispose();
    _fadeController.dispose();
    _loadController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _goToNextScreen() {
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (!mounted) return;
      Get.offAllNamed('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A0D),
      body: Stack(
        children: [
          // ── Background blobs ───────────────────────────
          _BackgroundBlobs(),

          // ── Subtle grid overlay ────────────────────────
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),

          // ── Main content ───────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Spinning ring + emoji
                FadeTransition(
                  opacity: _logoFade,
                  child: _SpinningRing(controller: _ringController),
                ),

                const SizedBox(height: 28),

                // Brand name
                FadeTransition(
                  opacity: _textFade,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(_textFade),
                    child: const Text(
                      'Fruit Market',
                      style: TextStyle(
                        fontFamily: 'Georgia', // serif — elegant feel
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE8F5E2),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                FadeTransition(
                  opacity: _textFade,
                  child: const Text(
                    'FRESH · NATURAL · FAST',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Color(0x80B4DCA0),
                      letterSpacing: 4,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Loading bar
                FadeTransition(
                  opacity: _barFade,
                  child: _LoadingBar(controller: _loadController),
                ),

                const SizedBox(height: 14),

                // Pulse dots
                FadeTransition(
                  opacity: _barFade,
                  child: _PulseDots(controller: _pulseController),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────
// Background blobs
// ────────────────────────────────────────────────
class _BackgroundBlobs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -80,
            child: _Blob(size: 320, color: const Color(0x5522642C)),
          ),
          Positioned(
            bottom: -60,
            right: -60,
            child: _Blob(size: 260, color: const Color(0x44103C19)),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: MediaQuery.of(context).size.width * 0.3,
            child: _Blob(size: 180, color: const Color(0x1E5AB450)),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

// ────────────────────────────────────────────────
// Grid painter
// ────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 0.5;

    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ────────────────────────────────────────────────
// Spinning ring with fruit emoji
// ────────────────────────────────────────────────
class _SpinningRing extends StatelessWidget {
  final AnimationController controller;
  const _SpinningRing({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer dashed ring
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) => Transform.rotate(
              angle: controller.value * 2 * math.pi,
              child: CustomPaint(
                size: const Size(160, 160),
                painter: _DashedCirclePainter(
                  color: const Color(0x3350C85A),
                  radius: 76,
                ),
              ),
            ),
          ),

          // Inner solid ring
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x2250C85A), width: 1),
              gradient: RadialGradient(
                colors: [const Color(0x221E5C28), const Color(0x001E5C28)],
              ),
            ),
          ),

          // Fruit emoji — counter-rotates to stay upright
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) => Transform.rotate(
              angle: -controller.value * 2 * math.pi,
              child: const Text('🍊', style: TextStyle(fontSize: 52)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double radius;
  const _DashedCirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const dashCount = 24;
    const dashAngle = (2 * math.pi) / dashCount;
    const gapFraction = 0.45;
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < dashCount; i++) {
      final start = i * dashAngle;
      final sweep = dashAngle * (1 - gapFraction);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ────────────────────────────────────────────────
// Loading bar
// ────────────────────────────────────────────────
class _LoadingBar extends StatelessWidget {
  final AnimationController controller;
  const _LoadingBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) => Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: CurvedAnimation(
                  parent: controller,
                  curve: Curves.easeInOut,
                ).value,
                minHeight: 2,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF4CAF50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────
// Pulse dots
// ────────────────────────────────────────────────
class _PulseDots extends StatelessWidget {
  final AnimationController controller;
  const _PulseDots({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            // stagger each dot
            final offset = (i * 0.3).clamp(0.0, 1.0);
            final value = ((controller.value - offset).clamp(0.0, 1.0));
            return Container(
              width: 5,
              height: 5,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.lerp(
                  const Color(0x2878C864),
                  const Color(0xFF78C864),
                  value,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
