import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';
import '../../../data/models/booking_model.dart';

class BookingCardWidget extends StatelessWidget {
  final BookingModel booking;

  const BookingCardWidget({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final isCod = booking.paymentType == PaymentType.cod;
    final isProfit = booking.profit >= 0;
    final syncColor = _getSyncStatusColor(booking.syncStatus);
    final syncIcon = _getSyncStatusIcon(booking.syncStatus);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to booking detail screen
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: AppTheme.primary.withAlpha(15),
        highlightColor: AppTheme.primary.withAlpha(10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: isCod ? AppTheme.codColor : AppTheme.primary,
                width: 3,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x081565C0),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Payment badge + consignment # + sync dot
              Row(
                children: [
                  isCod
                      ? StatusBadgeWidget(type: BadgeType.cod)
                      : StatusBadgeWidget(type: BadgeType.prepaid),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.consignmentNumber,
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A2340),
                        letterSpacing: 0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Sync status dot
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: syncColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(syncIcon, size: 14, color: syncColor),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Row 2: Customer name + courier name
              Row(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    size: 13,
                    color: Color(0xFF90A4AE),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      booking.customerName,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A2340),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      booking.courierName,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF546E7A),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Row 3: Mobile number + weight
              Row(
                children: [
                  const Icon(
                    Icons.phone_rounded,
                    size: 12,
                    color: Color(0xFF90A4AE),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '+91 ${booking.mobileNumber}',
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 12,
                      color: const Color(0xFF546E7A),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.scale_rounded,
                    size: 12,
                    color: Color(0xFF90A4AE),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '${booking.weight} kg',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      color: const Color(0xFF546E7A),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Divider
              Container(height: 1, color: AppTheme.outlineVariantLight),

              const SizedBox(height: 10),

              // Row 4: Charged, Cost, Profit
              Row(
                children: [
                  _AmountChip(
                    label: 'Charged',
                    value: '₹${booking.chargedAmount.toStringAsFixed(0)}',
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  _AmountChip(
                    label: 'Cost',
                    value: '₹${booking.costAmount.toStringAsFixed(0)}',
                    color: AppTheme.warning,
                  ),
                  const Spacer(),
                  // Profit pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isProfit
                          ? AppTheme.successContainer
                          : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isProfit
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          size: 12,
                          color: isProfit
                              ? AppTheme.success
                              : AppTheme.errorColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${isProfit ? '+' : '-'}₹${booking.profit.abs().toStringAsFixed(0)}',
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isProfit
                                ? AppTheme.success
                                : AppTheme.errorColor,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // COD Amount row (if COD)
              if (isCod && booking.codAmount > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.payments_rounded,
                      size: 12,
                      color: AppTheme.codColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'COD: ₹${booking.codAmount.toStringAsFixed(0)}',
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.codColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'to collect',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        color: const Color(0xFF90A4AE),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getSyncStatusColor(SyncStatus status) {
    switch (status) {
      case SyncStatus.synced:
        return AppTheme.success;
      case SyncStatus.pending:
        return const Color(0xFFF57F17);
      case SyncStatus.offline:
        return const Color(0xFF90A4AE);
      default:
        return const Color(0xFF90A4AE);
    }
  }

  IconData _getSyncStatusIcon(SyncStatus status) {
    switch (status) {
      case SyncStatus.synced:
        return Icons.cloud_done_rounded;
      case SyncStatus.pending:
        return Icons.sync_rounded;
      case SyncStatus.offline:
        return Icons.cloud_off_rounded;
      default:
        return Icons.cloud_off_rounded;
    }
  }
}

class _AmountChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _AmountChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 10,
            color: const Color(0xFF90A4AE),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: GoogleFonts.ibmPlexMono(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
