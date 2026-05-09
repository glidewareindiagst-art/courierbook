import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class BookingFilterChipsWidget extends StatelessWidget {
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  static const List<_FilterOption> _filters = [
    _FilterOption('All', Icons.list_alt_rounded),
    _FilterOption('Today', Icons.today_rounded),
    _FilterOption('COD', Icons.payments_rounded),
    _FilterOption('Prepaid', Icons.credit_card_rounded),
    _FilterOption('Synced', Icons.cloud_done_rounded),
  ];

  const BookingFilterChipsWidget({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isActive = activeFilter == filter.label;
          return GestureDetector(
            onTap: () => onFilterChanged(filter.label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.primary : AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isActive
                      ? AppTheme.primary
                      : AppTheme.outlineVariantLight,
                  width: 1,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppTheme.primary.withAlpha(51),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter.icon,
                    size: 13,
                    color: isActive ? Colors.white : const Color(0xFF546E7A),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    filter.label,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive ? Colors.white : const Color(0xFF546E7A),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FilterOption {
  final String label;
  final IconData icon;
  const _FilterOption(this.label, this.icon);
}
