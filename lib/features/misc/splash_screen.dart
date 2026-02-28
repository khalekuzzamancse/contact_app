import 'dart:math' as math;
import 'package:contact_app/features/_core/core_ui.dart';
import 'package:contact_app/features/_core/ui/_logo.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _arcAnimation;
  late final Animation<double> _arc2Animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Animation duration
    )..forward();

    _logoAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _arcAnimation = Tween<double>(begin: -300.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _arc2Animation = Tween<double>(begin: -150.0, end:0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arcSize = 300.0;
    final arc2Size = 150.0;
    final pi = math.pi;
    final angle90 = pi / 2;
    final double angle270 = pi * 1.5;

    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            decoration: gradientDecorator,
          ),
          Positioned.fill(
            child: FadeTransition(
              opacity: _logoAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Center(
                  child: Logo(),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _arcAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: -arcSize / 2 + _arcAnimation.value,
                left: -arcSize / 2 + _arcAnimation.value,
                child: CustomPaint(
                  size: Size(arcSize, arcSize),
                  painter: _QuarterCirclePainter(-angle90, angle90),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: _arc2Animation,
            builder: (context, child) {
              return Positioned(
                top: -arc2Size / 2 + _arc2Animation.value,
                right: -arc2Size / 2 + _arc2Animation.value,
                child: CustomPaint(
                  size: Size(arc2Size, arc2Size),
                  painter: _QuarterCirclePainter(-angle270, angle90),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
///[Bug] Taking extra space than visual area
class _QuarterCirclePainter extends CustomPainter {
  final double startAngle,endAngle;
  _QuarterCirclePainter(this.startAngle, this.endAngle);
  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.width, size.height);
    final rect = Rect.fromCenter(
      center: Offset(radius / 2, radius / 2),
      width: radius,
      height: radius,
    );

    final Paint paint = Paint()
      ..color = ThemeFactory.theme.colorPrimary
      ..style = PaintingStyle.fill;

    canvas.drawArc(rect, startAngle, endAngle, true, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

