import 'package:flutter/material.dart';

import '../../core/theme/agro_theme.dart';

class FieldBackground extends StatelessWidget {
  const FieldBackground({this.dark = false, super.key});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FieldBackgroundPainter(dark: dark),
      child: const SizedBox.expand(),
    );
  }
}

class FieldBackgroundPainter extends CustomPainter {
  FieldBackgroundPainter({required this.dark});

  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final sky = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: dark
            ? const [Color(0xFF08130E), Color(0xFF111111)]
            : const [Color(0xFFDCEFE4), Color(0xFFF8F9FA)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    final rows = Paint()
      ..color = dark
          ? Colors.white.withValues(alpha: 0.08)
          : AgroTheme.secondary.withValues(alpha: 0.18)
      ..strokeWidth = 2;
    for (var i = -8; i < 20; i++) {
      final start = Offset(size.width * i / 12, size.height);
      final end = Offset(size.width * (i + 4) / 12, size.height * 0.42);
      canvas.drawLine(start, end, rows);
    }
  }

  @override
  bool shouldRepaint(covariant FieldBackgroundPainter oldDelegate) {
    return oldDelegate.dark != dark;
  }
}
