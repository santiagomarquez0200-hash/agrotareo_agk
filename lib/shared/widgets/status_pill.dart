import 'package:flutter/material.dart';

import '../../core/theme/agro_theme.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({required this.label, required this.ok, super.key});

  final String label;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    final color = ok ? AgroTheme.success : AgroTheme.danger;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
