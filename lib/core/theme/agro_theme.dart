import 'package:flutter/material.dart';

/// Paleta "enterprise" oscura — la misma usada en el login — aplicada a toda
/// la app para que se vea como un solo producto coherente, no una pantalla
/// de login bonita pegada a un shell claro generico.
class AgroTheme {
  // Fondo / superficies
  static const bg = Color(0xFF060E08);
  static const card = Color(0xFF0E2016);
  static const cardAlt = Color(0xFF15281C);
  static const border = Color(0xFF1F3D28);

  // Acentos
  static const lime = Color(0xFF8CC53F);
  static const limeDeep = Color(0xFF4E7C22);
  static const primaryContainer = Color(0xFF1B4332);

  // Texto
  static const textDim = Color(0xFF7CA885);
  static const textFaint = Color(0xFF4A7055);

  // Estado
  static const success = Color(0xFF86EFAC);
  static const warning = Color(0xFFFBBF24);
  static const danger = Color(0xFFEF4444);
  static const dangerBg = Color(0xFF3A0A0A);
  static const dangerBorder = Color(0xFF7F1D1D);

  // Compat: nombres usados por widgets viejos, ahora resueltos sobre la
  // paleta oscura.
  static const primary = lime;
  static const secondary = lime;
  static const secondaryContainer = Color(0xFF123A21);
  static const surface = bg;
  static const surfaceLow = card;
  static const surfaceHigh = cardAlt;
  static const outline = border;

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: lime,
      brightness: Brightness.dark,
      primary: lime,
      onPrimary: Color(0xFF0B1F13),
      secondary: lime,
      surface: card,
      onSurface: Colors.white,
      error: danger,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      fontFamily: 'Inter',
      dividerColor: border,
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: card),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: border),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: lime,
        textColor: Colors.white,
        tileColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardAlt,
        hintStyle: const TextStyle(color: textFaint),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lime, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: limeDeep,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lime,
          side: const BorderSide(color: border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: lime)),
      iconTheme: const IconThemeData(color: lime),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: card,
        indicatorColor: lime.withValues(alpha: 0.18),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
            color: selected ? lime : textDim,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? lime : textDim);
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardAlt,
        selectedColor: lime.withValues(alpha: 0.22),
        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardAlt,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: lime),
      textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: 'Inter',
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
    );
  }
}
