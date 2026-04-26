import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Brand Palette ──────────────────────────────────────────
  static const Color primary = Color(0xFF6C3CE1);
  static const Color primaryLight = Color(0xFF8B6CEF);
  static const Color primaryDark = Color(0xFF4E27B0);
  static const Color accent = Color(0xFF00D4AA);

  // Surfaces
  static const Color bgLight = Color(0xFFF5F3FA);
  static const Color cardBg = Colors.white;
  static const Color sheetBg = Color(0xFFFAF9FE);

  // Text
  static const Color textPrimary = Color(0xFF1B1340);
  static const Color textSecondary = Color(0xFF7B7394);
  static const Color textHint = Color(0xFFA9A3BA);

  // Borders
  static const Color border = Color(0xFFEDE9F5);
  static const Color divider = Color(0xFFF0EDF7);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ── Radii ──────────────────────────────────────────────────
  static const double r12 = 12;
  static const double r16 = 16;
  static const double r20 = 20;
  static const double r24 = 24;
  static const double r32 = 32;

  // ── Shadows ────────────────────────────────────────────────
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: primary.withValues(alpha: 0.06),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: primary.withValues(alpha: 0.04),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: primary.withValues(alpha: 0.12),
      blurRadius: 32,
      offset: const Offset(0, 12),
      spreadRadius: -4,
    ),
  ];

  // ── Gradients ──────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B6CEF), Color(0xFF6C3CE1), Color(0xFF4E27B0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF6C3CE1), Color(0xFF4E27B0), Color(0xFF3A1D8E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [Color(0xFFF5F3FA), Color(0xFFEDE9F5), Color(0xFFF5F3FA)],
  );

  // ── Typography ─────────────────────────────────────────────
  static TextStyle displayLg = GoogleFonts.playfairDisplay(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    color: textPrimary,
    height: 1.15,
    letterSpacing: -0.5,
  );

  static TextStyle displayMd = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.2,
    letterSpacing: -0.3,
  );

  static TextStyle displaySm = GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.25,
  );

  static TextStyle headingLg = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.3,
  );

  static TextStyle headingMd = GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static TextStyle headingSm = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle bodyLg = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.5,
  );

  static TextStyle bodyMd = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.5,
  );

  static TextStyle bodySm = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textHint,
  );

  static TextStyle labelLg = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle labelSm = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );

  static TextStyle priceLg = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: primary,
  );

  // ── ThemeData ──────────────────────────────────────────────
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgLight,
      primaryColor: primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        surface: cardBg,
        error: error,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        centerTitle: true,
        titleTextStyle: headingLg,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r16)),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: border, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r16)),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r16),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r16),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r16),
          borderSide: const BorderSide(color: primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r16),
          borderSide: const BorderSide(color: error, width: 1.2),
        ),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: textHint, fontSize: 14),
        prefixIconColor: textHint,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 6,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        side: BorderSide(color: border, width: 1.5),
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? primary : Colors.transparent,
        ),
      ),
      dividerTheme: const DividerThemeData(color: divider, thickness: 1, space: 1),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        modalBarrierColor: Color(0x44000000),
      ),
    );
  }
}
