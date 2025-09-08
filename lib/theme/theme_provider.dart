import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  Color _accentColor = AppConstants.royalPurple;
  
  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    hapticFeedback(HapticFeedbackType.light);
    notifyListeners();
  }
  
  void setAccentColor(Color color) {
    _accentColor = color;
    hapticFeedback(HapticFeedbackType.medium);
    notifyListeners();
  }
  
  // Haptic Feedback
  void hapticFeedback(HapticFeedbackType type) {
    switch (type) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }
  
  // Sound Effects (using SystemSound for iOS-like sounds)
  void playSound(SoundType type) {
    switch (type) {
      case SoundType.tap:
        SystemSound.play(SystemSoundType.click);
        break;
      case SoundType.success:
        // Custom success sound would go here
        break;
      case SoundType.error:
        // Custom error sound would go here  
        break;
    }
  }
  
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'SF Pro Display',
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: _accentColor,
        brightness: Brightness.light,
        primary: _accentColor,
        secondary: AppConstants.lavender,
        surface: AppConstants.lightBackground,
        background: AppConstants.lightBackground,
        onPrimary: AppConstants.pureWhite,
        onSecondary: AppConstants.lightTextPrimary,
        onSurface: AppConstants.lightTextPrimary,
        onBackground: AppConstants.lightTextPrimary,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        iconTheme: IconThemeData(color: AppConstants.lightTextPrimary),
        titleTextStyle: AppConstants.headlineMedium,
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: AppConstants.lightCardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        shadowColor: AppConstants.royalPurple.withOpacity(0.1),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentColor,
          foregroundColor: AppConstants.pureWhite,
          elevation: 0,
          shadowColor: _accentColor.withOpacity(0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingM,
          ),
          textStyle: AppConstants.labelLarge.copyWith(
            color: AppConstants.pureWhite,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _accentColor,
          textStyle: AppConstants.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.lightGlassBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: BorderSide(
            color: AppConstants.lightGlassBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: BorderSide(
            color: AppConstants.lightGlassBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: BorderSide(
            color: _accentColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingM,
        ),
        hintStyle: AppConstants.bodyMedium.copyWith(
          color: AppConstants.lightTextSecondary,
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppConstants.pureWhite,
        unselectedItemColor: AppConstants.lightTextSecondary,
        selectedLabelStyle: AppConstants.labelSmall,
        unselectedLabelStyle: AppConstants.labelSmall,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: AppConstants.displayLarge,
        displayMedium: AppConstants.displayMedium,
        displaySmall: AppConstants.displaySmall,
        headlineLarge: AppConstants.headlineLarge,
        headlineMedium: AppConstants.headlineMedium,
        headlineSmall: AppConstants.headlineSmall,
        titleLarge: AppConstants.titleLarge,
        titleMedium: AppConstants.titleMedium,
        titleSmall: AppConstants.titleSmall,
        bodyLarge: AppConstants.bodyLarge,
        bodyMedium: AppConstants.bodyMedium,
        bodySmall: AppConstants.bodySmall,
        labelLarge: AppConstants.labelLarge,
        labelMedium: AppConstants.labelMedium,
        labelSmall: AppConstants.labelSmall,
      ).apply(
        displayColor: AppConstants.lightTextPrimary,
        bodyColor: AppConstants.lightTextPrimary,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppConstants.lightTextPrimary,
        size: 24,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppConstants.lightGlassBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }
  
  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'SF Pro Display',
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: _accentColor,
        brightness: Brightness.dark,
        primary: _accentColor,
        secondary: AppConstants.lavender,
        surface: AppConstants.darkBackground,
        background: AppConstants.darkBackground,
        onPrimary: AppConstants.pureWhite,
        onSecondary: AppConstants.darkTextPrimary,
        onSurface: AppConstants.darkTextPrimary,
        onBackground: AppConstants.darkTextPrimary,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(color: AppConstants.darkTextPrimary),
        titleTextStyle: AppConstants.headlineMedium,
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: AppConstants.darkCardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentColor,
          foregroundColor: AppConstants.pureWhite,
          elevation: 0,
          shadowColor: _accentColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingM,
          ),
          textStyle: AppConstants.labelLarge.copyWith(
            color: AppConstants.pureWhite,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _accentColor,
          textStyle: AppConstants.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.darkGlassBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: BorderSide(
            color: AppConstants.darkGlassBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: BorderSide(
            color: AppConstants.darkGlassBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: BorderSide(
            color: _accentColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingM,
        ),
        hintStyle: AppConstants.bodyMedium.copyWith(
          color: AppConstants.darkTextSecondary,
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppConstants.pureWhite,
        unselectedItemColor: AppConstants.darkTextSecondary,
        selectedLabelStyle: AppConstants.labelSmall,
        unselectedLabelStyle: AppConstants.labelSmall,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: AppConstants.displayLarge,
        displayMedium: AppConstants.displayMedium,
        displaySmall: AppConstants.displaySmall,
        headlineLarge: AppConstants.headlineLarge,
        headlineMedium: AppConstants.headlineMedium,
        headlineSmall: AppConstants.headlineSmall,
        titleLarge: AppConstants.titleLarge,
        titleMedium: AppConstants.titleMedium,
        titleSmall: AppConstants.titleSmall,
        bodyLarge: AppConstants.bodyLarge,
        bodyMedium: AppConstants.bodyMedium,
        bodySmall: AppConstants.bodySmall,
        labelLarge: AppConstants.labelLarge,
        labelMedium: AppConstants.labelMedium,
        labelSmall: AppConstants.labelSmall,
      ).apply(
        displayColor: AppConstants.darkTextPrimary,
        bodyColor: AppConstants.darkTextPrimary,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppConstants.darkTextPrimary,
        size: 24,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppConstants.darkGlassBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }
}

enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
}

enum SoundType {
  tap,
  success,
  error,
}