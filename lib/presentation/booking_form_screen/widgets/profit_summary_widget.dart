import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class ProfitSummaryWidget extends StatelessWidget {
  final double chargedAmount;
  final double costAmount;
  final double profit;

  const ProfitSummaryWidget({
    super.key,
    required this.chargedAmount,
    required this.costAmount,
    required this.profit,
  });

  @override
  Widget build(BuildContext context) {
    final isProfit = profit >= 0;
    final profitColor = isProfit ? AppTheme.success : AppTheme.errorColor;
    final profitBg = isProfit
        ? AppTheme.successContainer
        : const Color(0xFFFFEBEE);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: profitColor.withAlpha(77), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: profitColor.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: profitBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  isProfit
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  size: 14,
                  color: profitColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Profit Summary',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF546E7A),
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),
              Text(
                'Auto-calculated',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  color: const Color(0xFF90A4AE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Charged',
                  value: chargedAmount,
                  color: AppTheme.primary,
                  bgColor: AppTheme.primaryContainer,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppTheme.outlineVariantLight,
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Cost',
                  value: costAmount,
                  color: AppTheme.warning,
                  bgColor: AppTheme.warningContainer,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppTheme.outlineVariantLight,
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: isProfit ? 'Profit' : 'Loss',
                  value: profit.abs(),
                  color: profitColor,
                  bgColor: profitBg,
                  isHighlighted: true,
                  prefix: isProfit ? '+' : '-',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final Color bgColor;
  final bool isHighlighted;
  final String prefix;

  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
    this.isHighlighted = false,
    this.prefix = '₹',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF90A4AE),
          ),
        ),
        const SizedBox(height: 4),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          builder: (context, animValue, _) {
            return Text(
              '$prefix${animValue.toStringAsFixed(0)}',
              style: GoogleFonts.ibmPlexMono(
                fontSize: isHighlighted ? 17 : 15,
                fontWeight: FontWeight.w700,
                color: color,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            );
          },
        ),
      ],
    );
  }
}
