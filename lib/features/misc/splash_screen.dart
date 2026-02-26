import 'dart:math' as math;

import 'package:contact_app/core/ui/core_ui.dart';
import 'package:contact_app/features/_core/core_ui.dart';
import 'package:contact_app/features/_core/ui/_logo.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arcSize=300.0;
    final arc2Size=150.0;
    final pi=math.pi;
    final angle90 = pi/ 2;
    final double angle270 = pi * 1.5;
    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            decoration: gradientDecorator,
          ),
          Positioned.fill(
            child: Center(
              child: Logo(),
            ),
          ),
          Positioned(
            bottom: -arcSize/2,left: -arcSize/2,
            child: CustomPaint(
              size: Size(arcSize, arcSize),
              painter: _QuarterCirclePainter(-angle90,angle90),
            ),
          ),
          Positioned(
            top: -arc2Size/2,right: -arc2Size/2,
            child: CustomPaint(
              size: Size(arc2Size, arc2Size),
              painter: _QuarterCirclePainter(-angle270,angle90),
            ),
          )
        ],
      ),
    );
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

