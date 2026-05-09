import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class CustomerInfoCardWidget extends StatelessWidget {
  final TextEditingController customerNameController;
  final TextEditingController mobileController;

  const CustomerInfoCardWidget({
    super.key,
    required this.customerNameController,
    required this.mobileController,
  });

  @override
  Widget build(BuildContext context) {
    return _FormGroupCard(
      title: 'Customer Info',
      iconName: 'person',
      children: [
        TextFormField(
          controller: customerNameController,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          style: GoogleFonts.ibmPlexSans(fontSize: 15),
          decoration: const InputDecoration(
            labelText: 'Customer Name',
            hintText: 'Full name of sender/receiver',
            prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'Customer name is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: mobileController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          style: GoogleFonts.ibmPlexMono(fontSize: 15, letterSpacing: 0.8),
          decoration: const InputDecoration(
            labelText: 'Mobile Number',
            hintText: '10-digit mobile number',
            prefixIcon: Icon(Icons.phone_rounded, size: 20),
            prefixText: '+91 ',
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'Mobile number is required';
            }
            if (v.length < 10) {
              return 'Enter a valid 10-digit mobile number';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _FormGroupCard extends StatelessWidget {
  final String title;
  final String iconName;
  final List<Widget> children;

  const _FormGroupCard({
    required this.title,
    required this.iconName,
    required this.children,
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
                child: Icon(
                  _iconData(iconName),
                  size: 16,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
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
          ...children,
        ],
      ),
    );
  }

  IconData _iconData(String name) {
    switch (name) {
      case 'person':
        return Icons.person_rounded;
      default:
        return Icons.circle_rounded;
    }
  }
}
