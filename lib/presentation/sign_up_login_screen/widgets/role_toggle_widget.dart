import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class RoleToggleWidget extends StatelessWidget {
  final int selectedRole;
  final ValueChanged<int> onRoleChanged;

  const RoleToggleWidget({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariantLight,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppTheme.outlineVariantLight, width: 1),
      ),
      child: Row(
        children: [
          _buildSegment(0, 'Admin', Icons.admin_panel_settings_rounded),
          _buildSegment(1, 'Staff', Icons.badge_rounded),
        ],
      ),
    );
  }

  Widget _buildSegment(int index, String label, IconData icon) {
    final isSelected = selectedRole == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onRoleChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withAlpha(64),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : const Color(0xFF546E7A),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : const Color(0xFF546E7A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
