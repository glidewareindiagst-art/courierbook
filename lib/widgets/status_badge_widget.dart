import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum BadgeType { cod, prepaid, synced, pending, offline, high, low, medium }

class StatusBadgeWidget extends StatelessWidget {
  final BadgeType type;
  final String? customLabel;

  const StatusBadgeWidget({super.key, required this.type, this.customLabel});

  @override
  Widget build(BuildContext context) {
    final config = _config(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        customLabel ?? config.label,
        style: GoogleFonts.ibmPlexSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: config.fg,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  _BadgeConfig _config(BadgeType t) {
    switch (t) {
      case BadgeType.cod:
        return _BadgeConfig(
          bg: AppTheme.warningContainer,
          fg: AppTheme.codColor,
          label: 'COD',
        );
      case BadgeType.prepaid:
        return _BadgeConfig(
          bg: AppTheme.primaryContainer,
          fg: AppTheme.primary,
          label: 'Prepaid',
        );
      case BadgeType.synced:
        return _BadgeConfig(
          bg: AppTheme.successContainer,
          fg: AppTheme.success,
          label: 'Synced',
        );
      case BadgeType.pending:
        return _BadgeConfig(
          bg: const Color(0xFFFFF9C4),
          fg: const Color(0xFFF57F17),
          label: 'Pending',
        );
      case BadgeType.offline:
        return _BadgeConfig(
          bg: const Color(0xFFF5F5F5),
          fg: const Color(0xFF757575),
          label: 'Offline',
        );
      case BadgeType.high:
        return _BadgeConfig(
          bg: const Color(0xFFFFEBEE),
          fg: AppTheme.errorColor,
          label: 'High',
        );
      case BadgeType.medium:
        return _BadgeConfig(
          bg: AppTheme.warningContainer,
          fg: AppTheme.warning,
          label: 'Medium',
        );
      case BadgeType.low:
        return _BadgeConfig(
          bg: AppTheme.successContainer,
          fg: AppTheme.success,
          label: 'Low',
        );
    }
  }
}

class _BadgeConfig {
  final Color bg, fg;
  final String label;
  const _BadgeConfig({required this.bg, required this.fg, required this.label});
}
