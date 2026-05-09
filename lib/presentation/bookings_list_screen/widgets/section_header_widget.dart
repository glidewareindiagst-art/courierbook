import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String label;
  final int count;

  const SectionHeaderWidget({
    super.key,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A2340),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            '$count',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
        ),
        const Spacer(),
        Text(
          count == 1 ? '1 booking' : '$count bookings',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 11,
            color: const Color(0xFF90A4AE),
          ),
        ),
      ],
    );
  }
}
