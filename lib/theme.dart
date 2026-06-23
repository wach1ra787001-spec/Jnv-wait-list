import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Dark palette ────────────────────────────────────────────────
class _Dark {
  static const scaffold       = Color(0xFF0A1628);
  static const heroBg         = Color(0xFF162544);
  static const surface        = Color(0xFF111D33);
  static const surfaceLight   = Color(0xFF1A2D4A);
  static const border         = Color(0xFF263A5C);
  static const electric       = Color(0xFF3B7BF8);
  static const electricBright = Color(0xFF5B9BFF);
  static const textPrimary    = Color(0xFFFFFFFF);
  static const textSecondary  = Color(0xFFB8CCE4);
  static const textMuted      = Color(0xFF8BA3C4);
  static const success        = Color(0xFF1D9E75);
  static const successBg      = Color(0xFF0D2E22);
  static const error          = Color(0xFFE24B4A);
  static const errorBg        = Color(0xFF2E1515);
  static const divider        = Color(0xFF263A5C);
  static const chipSelected   = Color(0xFF1B2E52);
  static const gridLine       = Color(0xFF263A5C);
}

// ─── Light palette ───────────────────────────────────────────────
class _Light {
  static const scaffold       = Color(0xFFFFFFFF);
  static const heroBg         = Color(0xFFF0F5FF);
  static const surface        = Color(0xFFF4F7FF);
  static const surfaceLight   = Color(0xFFE8EFFE);
  static const border         = Color(0xFFCBDAF8);
  static const electric       = Color(0xFF2563EB);
  static const electricBright = Color(0xFF3B7BF8);
  static const textPrimary    = Color(0xFF0A1628);
  static const textSecondary  = Color(0xFF2D4A7A);
  static const textMuted      = Color(0xFF6B89B8);
  static const success        = Color(0xFF16A34A);
  static const successBg      = Color(0xFFDCFCE7);
  static const error          = Color(0xFFDC2626);
  static const errorBg        = Color(0xFFFEE2E2);
  static const divider        = Color(0xFFCBDAF8);
  static const chipSelected   = Color(0xFFDBEAFE);
  static const gridLine       = Color(0xFFCBDAF8);
}

// ─── Semantic token helper ───────────────────────────────────────
class AppColors {
  final bool isDark;
  const AppColors({required this.isDark});

  Color get scaffold       => isDark ? _Dark.scaffold       : _Light.scaffold;
  Color get heroBg         => isDark ? _Dark.heroBg         : _Light.heroBg;
  Color get surface        => isDark ? _Dark.surface        : _Light.surface;
  Color get surfaceLight   => isDark ? _Dark.surfaceLight   : _Light.surfaceLight;
  Color get border         => isDark ? _Dark.border         : _Light.border;
  Color get electric       => isDark ? _Dark.electric       : _Light.electric;
  Color get electricBright => isDark ? _Dark.electricBright : _Light.electricBright;
  Color get textPrimary    => isDark ? _Dark.textPrimary    : _Light.textPrimary;
  Color get textSecondary  => isDark ? _Dark.textSecondary  : _Light.textSecondary;
  Color get textMuted      => isDark ? _Dark.textMuted      : _Light.textMuted;
  Color get success        => isDark ? _Dark.success        : _Light.success;
  Color get successBg      => isDark ? _Dark.successBg      : _Light.successBg;
  Color get error          => isDark ? _Dark.error          : _Light.error;
  Color get errorBg        => isDark ? _Dark.errorBg        : _Light.errorBg;
  Color get divider        => isDark ? _Dark.divider        : _Light.divider;
  Color get chipSelected   => isDark ? _Dark.chipSelected   : _Light.chipSelected;
  Color get gridLine       => isDark ? _Dark.gridLine       : _Light.gridLine;
}

// ─── Theme state notifier ────────────────────────────────────────
class ThemeNotifier extends ChangeNotifier {
  bool _isDark = true;
  bool get isDark => _isDark;
  AppColors get colors => AppColors(isDark: _isDark);
  void toggle() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

// ─── ThemeData builder ───────────────────────────────────────────
class AppTheme {
  static ThemeData build({required bool isDark}) {
    final c = AppColors(isDark: isDark);

    OutlineInputBorder ib(Color col, {double w = 1}) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: col, width: w),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: c.scaffold,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: c.electric,
        onPrimary: Colors.white,
        secondary: c.electricBright,
        onSecondary: Colors.white,
        surface: c.surface,
        onSurface: c.textPrimary,
        error: c.error,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border:             ib(c.border),
        enabledBorder:      ib(c.border),
        focusedBorder:      ib(c.electric, w: 1.5),
        errorBorder:        ib(c.error),
        focusedErrorBorder: ib(c.error, w: 1.5),
        hintStyle:  GoogleFonts.dmSans(color: c.textMuted, fontSize: 14),
        labelStyle: GoogleFonts.dmSans(color: c.textMuted, fontSize: 13),
        errorStyle: GoogleFonts.dmSans(color: c.error,     fontSize: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.electric,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
    );
  }
}
