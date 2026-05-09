import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class FinancialInfoCardWidget extends StatelessWidget {
  final TextEditingController weightController;
  final TextEditingController chargedController;
  final TextEditingController costController;
  final TextEditingController codAmountController;
  final String paymentType;
  final ValueChanged<String> onPaymentTypeChanged;

  const FinancialInfoCardWidget({
    super.key,
    required this.weightController,
    required this.chargedController,
    required this.costController,
    required this.codAmountController,
    required this.paymentType,
    required this.onPaymentTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A1565C0),
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.currency_rupee_rounded,
                  size: 16,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Financial Info',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF546E7A),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Weight field
          TextFormField(
            controller: weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            style: GoogleFonts.ibmPlexMono(fontSize: 15),
            decoration: const InputDecoration(
              labelText: 'Weight',
              hintText: '0.00',
              prefixIcon: Icon(Icons.scale_rounded, size: 20),
              suffixText: 'kg',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Weight is required';
              final d = double.tryParse(v);
              if (d == null || d <= 0) return 'Enter a valid weight';
              return null;
            },
          ),

          const SizedBox(height: 14),

          // Charged Amount
          TextFormField(
            controller: chargedController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            style: GoogleFonts.ibmPlexMono(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              labelText: 'Charged Amount',
              hintText: '0.00',
              prefixIcon: const Icon(Icons.currency_rupee_rounded, size: 20),
              filled: true,
              fillColor: AppTheme.primaryContainer.withAlpha(128),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Charged amount is required';
              }
              final d = double.tryParse(v);
              if (d == null || d < 0) return 'Enter a valid amount';
              return null;
            },
          ),

          const SizedBox(height: 14),

          // Cost Amount
          TextFormField(
            controller: costController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            style: GoogleFonts.ibmPlexMono(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              labelText: 'Cost Amount',
              hintText: '0.00',
              prefixIcon: const Icon(Icons.currency_rupee_rounded, size: 20),
              filled: true,
              fillColor: AppTheme.warningContainer.withAlpha(128),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Cost amount is required';
              }
              final d = double.tryParse(v);
              if (d == null || d < 0) return 'Enter a valid amount';
              return null;
            },
          ),

          const SizedBox(height: 16),

          // COD / Prepaid Toggle
          Text(
            'Payment Type',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF546E7A),
            ),
          ),
          const SizedBox(height: 8),
          _PaymentTypeToggle(
            selected: paymentType,
            onChanged: onPaymentTypeChanged,
          ),

          // COD Amount (conditional)
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: paymentType == 'COD'
                ? Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: TextFormField(
                      controller: codAmountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.codColor,
                      ),
                      decoration: InputDecoration(
                        labelText: 'COD Amount',
                        hintText: '0.00',
                        prefixIcon: const Icon(
                          Icons.currency_rupee_rounded,
                          size: 20,
                          color: AppTheme.codColor,
                        ),
                        filled: true,
                        fillColor: AppTheme.warningContainer,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppTheme.codColor,
                            width: 2,
                          ),
                        ),
                        labelStyle: GoogleFonts.ibmPlexSans(
                          fontSize: 13,
                          color: AppTheme.codColor,
                        ),
                      ),
                      validator: (v) {
                        if (paymentType == 'COD') {
                          if (v == null || v.trim().isEmpty) {
                            return 'COD amount is required';
                          }
                          final d = double.tryParse(v);
                          if (d == null || d < 0) {
                            return 'Enter a valid COD amount';
                          }
                        }
                        return null;
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _PaymentTypeToggle extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _PaymentTypeToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildOption(
            'COD',
            AppTheme.codColor,
            AppTheme.warningContainer,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildOption(
            'Prepaid',
            AppTheme.primary,
            AppTheme.primaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildOption(String value, Color activeColor, Color activeBg) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : AppTheme.surfaceVariantLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? activeColor : AppTheme.outlineVariantLight,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? activeColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? activeColor : AppTheme.outlineLight,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 9,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 6),
            Text(
              value,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? activeColor : const Color(0xFF546E7A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
