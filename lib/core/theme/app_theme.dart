import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Brand colours ───────────────────────────────────────────────────────
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color successColor = Color(0xFF22C55E);
  static const Color errorColor = Color(0xFFEF4444);

  // ─── Light surface colours ────────────────────────────────────────────────
  static const Color backgroundColor = Color(0xFFF2F2F7);
  static const Color surfaceColor = Colors.white;

  // ─── Dark surface colours ─────────────────────────────────────────────────
  static const Color darkBackgroundColor = Color(0xFF0F172A);
  static const Color darkSurfaceColor = Color(0xFF1E293B);
  static const Color darkCardColor = Color(0xFF334155);

  // ─── Typography ───────────────────────────────────────────────────────────
  static final TextTheme _textTheme =
      GoogleFonts.ibmPlexSansTextTheme().copyWith(
    bodyLarge: GoogleFonts.ibmPlexSans(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
  );

  static final TextTheme _darkTextTheme =
      GoogleFonts.ibmPlexSansTextTheme().copyWith(
    bodyLarge: GoogleFonts.ibmPlexSans(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  );

  // ─── Shared input decoration theme factory ────────────────────────────────
  static InputDecorationTheme _inputDecoration({required bool dark}) {
    return InputDecorationTheme(
      filled: true,
      fillColor: dark ? darkCardColor : Colors.white,
      hintStyle: TextStyle(
          color: dark ? Colors.white38 : Colors.grey[400],
          fontWeight: FontWeight.normal,
          fontSize: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: dark ? Colors.white12 : Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: dark ? Colors.white12 : Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  // ─── Light theme ──────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      textTheme: _textTheme.apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _textTheme.titleLarge?.copyWith(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: surfaceColor,
      ),
      inputDecorationTheme: _inputDecoration(dark: false),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primaryColor.withValues(alpha: 0.4),
          padding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          textStyle:
              _textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ─── Dark theme ───────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: darkSurfaceColor,
        error: errorColor,
      ),
      textTheme: _darkTextTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _darkTextTheme.titleLarge?.copyWith(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: darkSurfaceColor,
      ),
      inputDecorationTheme: _inputDecoration(dark: true),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primaryColor.withValues(alpha: 0.4),
          padding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          textStyle: _darkTextTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
