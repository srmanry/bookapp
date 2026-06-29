import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libararybd/core/util/custom_color.dart';

const _darkSurface = Color(0xFF1A1410);
const _darkCard = Color(0xFF231D16);
const _darkBorder = Color(0xFF3A322A);
const _darkText = Color(0xFFF5F0E8);
const _darkMuted = Color(0xFFB0A89E);
const _darkPrimary = Color(0xFF6DBF9E);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  primaryColor: _darkPrimary,
  brightness: Brightness.dark,
  hintColor: _darkMuted,
  scaffoldBackgroundColor: _darkSurface,
  cardColor: _darkCard,
  fontFamily: GoogleFonts.sourceSans3().fontFamily,
  colorScheme: const ColorScheme.dark(
    primary: _darkPrimary,
    secondary: accentColor,
    error: dangerColor,
    surface: _darkCard,
    onSurface: _darkText,
    outline: _darkBorder,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    foregroundColor: _darkText,
    elevation: 0,
    titleTextStyle: GoogleFonts.playfairDisplay(
      color: _darkText,
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),
  ),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.playfairDisplay(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: _darkText,
    ),
    headlineMedium: GoogleFonts.playfairDisplay(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: _darkText,
    ),
    titleLarge: GoogleFonts.playfairDisplay(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: _darkText,
    ),
    bodyLarge: GoogleFonts.sourceSans3(
      fontSize: 16,
      color: _darkText,
    ),
    bodyMedium: GoogleFonts.sourceSans3(
      fontSize: 14,
      color: _darkMuted,
    ),
    labelLarge: GoogleFonts.sourceSans3(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: _darkText,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _darkCard,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: _darkBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: _darkPrimary, width: 1.4),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _darkPrimary,
      foregroundColor: _darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: _darkPrimary,
    foregroundColor: _darkSurface,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  ),
  cardTheme: CardThemeData(
    color: _darkCard,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: const BorderSide(color: _darkBorder),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: _darkCard,
    indicatorColor: _darkPrimary.withValues(alpha: 0.16),
    labelTextStyle: WidgetStateProperty.resolveWith(
      (states) => TextStyle(
        color: states.contains(WidgetState.selected) ? _darkPrimary : _darkMuted,
        fontSize: 12,
        fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
      ),
    ),
    iconTheme: WidgetStateProperty.resolveWith(
      (states) => IconThemeData(
        color: states.contains(WidgetState.selected) ? _darkPrimary : _darkMuted,
      ),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: _darkText,
    contentTextStyle: const TextStyle(color: _darkSurface),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: _darkCard,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  ),
  dividerColor: _darkBorder,
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: _darkPrimary),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: _darkPrimary),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  ),
);
