import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class CredentialsInfoWidget extends StatelessWidget {
  final int selectedRole;

  const CredentialsInfoWidget({super.key, required this.selectedRole});

  @override
  Widget build(BuildContext context) {
    final credentials = selectedRole == 0
        ? _CredentialData(
            role: 'Admin',
            email: 'admin@courierbook.in',
            password: 'courier@2024',
          )
        : _CredentialData(
            role: 'Staff',
            email: 'staff@courierbook.in',
            password: 'courier@2024',
          );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withAlpha(51)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'Demo Credentials — ${credentials.role}',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _CredentialRow(label: 'Email', value: credentials.email),
          const SizedBox(height: 6),
          _CredentialRow(label: 'Password', value: credentials.password),
        ],
      ),
    );
  }
}

class _CredentialRow extends StatelessWidget {
  final String label;
  final String value;

  const _CredentialRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF546E7A),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A2340),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '$label copied',
                  style: GoogleFonts.ibmPlexSans(fontSize: 12),
                ),
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(4),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.copy_rounded, size: 14, color: AppTheme.primary),
          ),
        ),
      ],
    );
  }
}

class _CredentialData {
  final String role, email, password;
  const _CredentialData({
    required this.role,
    required this.email,
    required this.password,
  });
}
