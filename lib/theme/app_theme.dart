// THEME LOCK: light — source: domain signal (field tool, low-end Android, max contrast)
// Scaffold.backgroundColor = AppTheme.backgroundLight — ALL screens

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand colors
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryContainer = Color(0xFFD6E4FF);
  static const Color secondary = Color(0xFF0288D1);
  static const Color codColor = Color(0xFFE65100);
  static const Color prepaidColor = Color(0xFF1565C0);
  static const Color success = Color(0xFF2E7D32);
  static const Color successContainer = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFE65100);
  static const Color warningContainer = Color(0xFFFFF3E0);
  static const Color errorColor = Color(0xFFC62828);

  // Light surfaces
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF3F6FB);
  static const Color backgroundLight = Color(0xFFF0F4FA);
  static const Color outlineLight = Color(0xFFB0BEC5);
  static const Color outlineVariantLight = Color(0xFFE0E7EF);

  // Dark surfaces
  static const Color surfaceDark = Color(0xFF1E2433);
  static const Color backgroundDark = Color(0xFF121826);
  static const Color outlineDark = Color(0xFF546E7A);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primaryContainer,
      onPrimaryContainer: const Color(0xFF0D3B8A),
      secondary: secondary,
      onSecondary: Colors.white,
      surface: surfaceLight,
      onSurface: const Color(0xFF1A2340),
      surfaceContainerHighest: surfaceVariantLight,
      onSurfaceVariant: const Color(0xFF546E7A),
      error: errorColor,
      onError: Colors.white,
      outline: outlineLight,
      outlineVariant: outlineVariantLight,
    ),
    scaffoldBackgroundColor: backgroundLight,
    textTheme: GoogleFonts.ibmPlexSansTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),
    ),
    appBarTheme: AppBarThemeData(
      backgroundColor: surfaceLight,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: const Color(0x1A1565C0),
      foregroundColor: const Color(0xFF1A2340),
      titleTextStyle: GoogleFonts.ibmPlexSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1A2340),
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: surfaceVariantLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: outlineVariantLight, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: GoogleFonts.ibmPlexSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF546E7A),
      ),
      floatingLabelStyle: GoogleFonts.ibmPlexSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceLight,
      indicatorColor: primaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.ibmPlexSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: primary,
          );
        }
        return GoogleFonts.ibmPlexSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF90A4AE),
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: primary, size: 22);
        }
        return const IconThemeData(color: Color(0xFF90A4AE), size: 22);
      }),
      elevation: 4,
      shadowColor: const Color(0x1A000000),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: GoogleFonts.ibmPlexSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: StadiumBorder(),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surfaceVariantLight,
      selectedColor: primaryContainer,
      labelStyle: GoogleFonts.ibmPlexSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      side: const BorderSide(color: outlineVariantLight),
    ),
    dividerTheme: const DividerThemeData(
      color: outlineVariantLight,
      thickness: 1,
      space: 0,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF82AAFF),
      onPrimary: const Color(0xFF0D3B8A),
      primaryContainer: const Color(0xFF1A3A7A),
      onPrimaryContainer: const Color(0xFFD6E4FF),
      secondary: const Color(0xFF4FC3F7),
      onSecondary: const Color(0xFF003F5C),
      surface: surfaceDark,
      onSurface: const Color(0xFFE2E8F5),
      surfaceContainerHighest: const Color(0xFF252D3F),
      onSurfaceVariant: const Color(0xFF90A4AE),
      error: const Color(0xFFEF9A9A),
      onError: const Color(0xFF7F0000),
      outline: outlineDark,
      outlineVariant: const Color(0xFF2E3A4E),
    ),
    scaffoldBackgroundColor: backgroundDark,
    textTheme: GoogleFonts.ibmPlexSansTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: Color(0xFFE2E8F5),
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFFE2E8F5),
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE2E8F5),
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE2E8F5),
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Color(0xFFB0BEC5),
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Color(0xFFB0BEC5),
        ),
        bodySmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Color(0xFF78909C),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE2E8F5),
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF90A4AE),
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0xFF78909C),
        ),
      ),
    ),
    appBarTheme: AppBarThemeData(
      backgroundColor: surfaceDark,
      elevation: 0,
      scrolledUnderElevation: 2,
      foregroundColor: const Color(0xFFE2E8F5),
      titleTextStyle: GoogleFonts.ibmPlexSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFE2E8F5),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceDark,
      indicatorColor: const Color(0xFF1A3A7A),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.ibmPlexSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF82AAFF),
          );
        }
        return GoogleFonts.ibmPlexSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF546E7A),
        );
      }),
    ),
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: const Color(0xFF252D3F),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2E3A4E), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF82AAFF), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}