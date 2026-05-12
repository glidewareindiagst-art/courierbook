import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SummaryBannerWidget extends StatelessWidget {
  final int bookingCount;
  final double totalCharged;
  final double totalProfit;
  final double codPending;

  const SummaryBannerWidget({
    super.key,
    required this.bookingCount,
    required this.totalCharged,
    required this.totalProfit,
    required this.codPending,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withAlpha(64),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 13,
                color: Colors.white70,
              ),
              const SizedBox(width: 6),
              Text(
                "Today's Summary",
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(38),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '$bookingCount bookings',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _BannerStat(
                  label: 'Charged',
                  value: '₹${totalCharged.toStringAsFixed(0)}',
                  icon: Icons.currency_rupee_rounded,
                ),
              ),
              _VerticalDivider(),
              Expanded(
                child: _BannerStat(
                  label: 'Profit',
                  value: '+₹${totalProfit.toStringAsFixed(0)}',
                  icon: Icons.trending_up_rounded,
                  isHighlighted: true,
                ),
              ),
              _VerticalDivider(),
              Expanded(
                child: _BannerStat(
                  label: 'COD Pending',
                  value: '₹${codPending.toStringAsFixed(0)}',
                  icon: Icons.payments_outlined,
                  isWarning: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isHighlighted;
  final bool isWarning;

  const _BannerStat({
    required this.label,
    required this.value,
    required this.icon,
    this.isHighlighted = false,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final valueColor = isHighlighted
        ? const Color(0xFF80FFB4)
        : isWarning
        ? const Color(0xFFFFCC80)
        : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.white54),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                color: Colors.white54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.ibmPlexMono(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: valueColor,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withAlpha(51),
      margin: const EdgeInsets.symmetric(horizontal: 10),
    );
  }
}
