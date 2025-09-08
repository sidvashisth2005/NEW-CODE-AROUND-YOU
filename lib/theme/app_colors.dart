import 'package:flutter/material.dart';

class AppColors {
  // Royal Purple and Lavender Premium Palette
  static const Color royalPurple = Color(0xFF6B1FB3);
  static const Color lavender = Color(0xFFC6B6E2);
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  
  // Enhanced Glassmorphism Colors
  static const Color glassLight = Color(0x40FFFFFF);
  static const Color glassDark = Color(0x40000000);
  static const Color glassBorderLight = Color(0x4DFFFFFF);
  static const Color glassBorderDark = Color(0x1AFFFFFF);
  
  // Light theme colors
  static const AppColors light = AppColors._(
    // Premium gradient backgrounds
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFF8FAFC), // from-purple-50
        Color(0xFFFFFFFF), // via-white
        Color(0xFFF3E8FF), // to-purple-100
      ],
    ),
    cardBackground: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFEFEFE),
        Color(0xFFF8FAFC),
      ],
    ),
    
    // Text colors with proper contrast
    textPrimary: Color(0xFF111827), // text-gray-900
    textSecondary: Color(0xFF6B7280), // text-gray-600
    textTertiary: Color(0xFF9CA3AF), // text-gray-400
    
    // Accent colors
    accent: royalPurple,
    accentSecondary: lavender,
    
    // Enhanced glassmorphism
    glassBg: Color(0xE6FFFFFF), // rgba(255, 255, 255, 0.9)
    glassBorder: Color(0xCCC6B6E2), // border-purple-200/80
    glassBlur: 25.0,
    
    // Navigation
    navBackground: Color(0xF2FFFFFF), // rgba(255, 255, 255, 0.95)
    
    // Input fields
    inputBackground: Color(0xE6F3E8FF), // bg-purple-50/90
    
    // Gradients
    gradientPrimary: LinearGradient(
      colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)], // from-purple-500 to-purple-600
    ),
    gradientSecondary: LinearGradient(
      colors: [Color(0xFFA855F7), Color(0xFF3B82F6)], // from-purple-400 to-blue-500
    ),
    gradientGold: LinearGradient(
      colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)], // from-yellow-400 to-yellow-500
    ),
    
    // Enhanced shadow system for light mode
    shadowSm: [
      BoxShadow(
        color: Color(0x146B1FB3), // rgba(107, 31, 179, 0.08)
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
      BoxShadow(
        color: Color(0x0F000000), // rgba(0, 0, 0, 0.06)
        blurRadius: 3,
        offset: Offset(0, 1),
      ),
    ],
    shadowMd: [
      BoxShadow(
        color: Color(0x1F6B1FB3), // rgba(107, 31, 179, 0.12)
        blurRadius: 16,
        offset: Offset(0, 4),
      ),
      BoxShadow(
        color: Color(0x14000000), // rgba(0, 0, 0, 0.08)
        blurRadius: 6,
        offset: Offset(0, 2),
      ),
    ],
    shadowLg: [
      BoxShadow(
        color: Color(0x296B1FB3), // rgba(107, 31, 179, 0.16)
        blurRadius: 32,
        offset: Offset(0, 8),
      ),
      BoxShadow(
        color: Color(0x1A000000), // rgba(0, 0, 0, 0.1)
        blurRadius: 12,
        offset: Offset(0, 4),
      ),
    ],
    shadowXl: [
      BoxShadow(
        color: Color(0x336B1FB3), // rgba(107, 31, 179, 0.2)
        blurRadius: 48,
        offset: Offset(0, 12),
      ),
      BoxShadow(
        color: Color(0x1F000000), // rgba(0, 0, 0, 0.12)
        blurRadius: 16,
        offset: Offset(0, 6),
      ),
    ],
    shadowPurple: [
      BoxShadow(
        color: Color(0x406B1FB3), // rgba(107, 31, 179, 0.25)
        blurRadius: 32,
        offset: Offset(0, 8),
      ),
    ],
    shadowGold: [
      BoxShadow(
        color: Color(0x4DFFD700), // rgba(255, 215, 0, 0.3)
        blurRadius: 32,
        offset: Offset(0, 8),
      ),
    ],
    
    // Enhanced borders
    borderLight: Color(0x26C6B6E2), // border-purple-200/60
    borderMedium: Color(0x4DC6B6E2), // border-purple-300/70
    borderStrong: Color(0x66C6B6E2), // border-purple-400/80
    
    // Filter states for light mode
    filterInactive: FilterColors(
      background: Color(0xCCFFFFFF), // bg-white/80
      border: Color(0x99C6B6E2), // border-purple-200/60
      text: Color(0xFF6B7280), // text-gray-600
    ),
    filterActive: FilterColors(
      background: Color(0xFF8B5CF6), // bg-gradient-to-r from-purple-600
      border: Color(0x80A855F7), // border-purple-400/50
      text: Color(0xFFFFFFFF), // text-white
    ),
    
    // Chat message colors for light mode
    senderBubble: LinearGradient(
      colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)], // from-purple-600 to-purple-500
    ),
    receiverBubble: LinearGradient(
      colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)], // bg-white
    ),
    senderText: Color(0xFFFFFFFF), // text-white
    receiverText: Color(0xFF111827), // text-gray-900
    
    // Status indicators
    success: Color(0xFF10B981), // green-500
    warning: Color(0xFFF59E0B), // yellow-500
    error: Color(0xFFEF4444), // red-500
    info: Color(0xFF3B82F6), // blue-500
  );
  
  // Dark theme colors
  static const AppColors dark = AppColors._(
    // Premium dark gradient backgrounds
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF000000), // from-black
        Color(0xFF1A1A2E), // via-gray-950
        Color(0xFF16213E), // to-purple-950
      ],
    ),
    cardBackground: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF1F1F1F),
        Color(0xFF262626),
      ],
    ),
    
    // Text colors for dark mode
    textPrimary: Color(0xFFFFFFFF), // text-white
    textSecondary: Color(0xB3FFFFFF), // text-white/70
    textTertiary: Color(0x80FFFFFF), // text-white/50
    
    // Accent colors
    accent: Color(0xFFA855F7), // text-purple-400
    accentSecondary: lavender,
    
    // Enhanced glassmorphism for dark mode
    glassBg: Color(0x1AFFFFFF), // rgba(255, 255, 255, 0.1)
    glassBorder: Color(0x33FFFFFF), // border-white/20
    glassBlur: 25.0,
    
    // Navigation
    navBackground: Color(0xCC000000), // rgba(0, 0, 0, 0.8)
    
    // Input fields
    inputBackground: Color(0x1AFFFFFF), // bg-white/10
    
    // Gradients
    gradientPrimary: LinearGradient(
      colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)], // from-purple-600 to-purple-800
    ),
    gradientSecondary: LinearGradient(
      colors: [Color(0xFFA855F7), Color(0xFF2563EB)], // from-purple-400 to-blue-600
    ),
    gradientGold: LinearGradient(
      colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)], // from-yellow-400 to-yellow-300
    ),
    
    // Enhanced shadow system for dark mode
    shadowSm: [
      BoxShadow(
        color: Color(0x4D000000), // rgba(0, 0, 0, 0.3)
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
    shadowMd: [
      BoxShadow(
        color: Color(0x66000000), // rgba(0, 0, 0, 0.4)
        blurRadius: 16,
        offset: Offset(0, 4),
      ),
    ],
    shadowLg: [
      BoxShadow(
        color: Color(0x80000000), // rgba(0, 0, 0, 0.5)
        blurRadius: 32,
        offset: Offset(0, 8),
      ),
    ],
    shadowXl: [
      BoxShadow(
        color: Color(0x99000000), // rgba(0, 0, 0, 0.6)
        blurRadius: 48,
        offset: Offset(0, 12),
      ),
    ],
    shadowPurple: [
      BoxShadow(
        color: Color(0x666B1FB3), // rgba(107, 31, 179, 0.4)
        blurRadius: 32,
        offset: Offset(0, 8),
      ),
    ],
    shadowGold: [
      BoxShadow(
        color: Color(0x66FFD700), // rgba(255, 215, 0, 0.4)
        blurRadius: 32,
        offset: Offset(0, 8),
      ),
    ],
    
    // Enhanced borders
    borderLight: Color(0x33FFFFFF), // border-white/20
    borderMedium: Color(0x4DFFFFFF), // border-white/30
    borderStrong: Color(0x80FFFFFF), // border-white/50
    
    // Filter states for dark mode
    filterInactive: FilterColors(
      background: Color(0x1AFFFFFF), // bg-white/10
      border: Color(0x33FFFFFF), // border-white/20
      text: Color(0xB3FFFFFF), // text-white/70
    ),
    filterActive: FilterColors(
      background: Color(0xFF7C3AED), // bg-gradient-to-r from-purple-600
      border: Color(0x80A855F7), // border-purple-400/50
      text: Color(0xFFFFFFFF), // text-white
    ),
    
    // Chat message colors for dark mode
    senderBubble: LinearGradient(
      colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)], // from-purple-600 to-purple-500
    ),
    receiverBubble: LinearGradient(
      colors: [Color(0x1AFFFFFF), Color(0x1AFFFFFF)], // bg-white/10
    ),
    senderText: Color(0xFFFFFFFF), // text-white
    receiverText: Color(0xFFFFFFFF), // text-white
    
    // Status indicators
    success: Color(0xFF10B981), // green-500
    warning: Color(0xFFF59E0B), // yellow-500
    error: Color(0xFFEF4444), // red-500
    info: Color(0xFF3B82F6), // blue-500
  );
  
  const AppColors._({
    required this.background,
    required this.cardBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentSecondary,
    required this.glassBg,
    required this.glassBorder,
    required this.glassBlur,
    required this.navBackground,
    required this.inputBackground,
    required this.gradientPrimary,
    required this.gradientSecondary,
    required this.gradientGold,
    required this.borderLight,
    required this.borderMedium,
    required this.borderStrong,
    required this.shadowSm,
    required this.shadowMd,
    required this.shadowLg,
    required this.shadowXl,
    required this.shadowPurple,
    required this.shadowGold,
    required this.filterInactive,
    required this.filterActive,
    required this.senderBubble,
    required this.receiverBubble,
    required this.senderText,
    required this.receiverText,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });
  
  final LinearGradient background;
  final LinearGradient cardBackground;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color accentSecondary;
  final Color glassBg;
  final Color glassBorder;
  final double glassBlur;
  final Color navBackground;
  final Color inputBackground;
  final LinearGradient gradientPrimary;
  final LinearGradient gradientSecondary;
  final LinearGradient gradientGold;
  final Color borderLight;
  final Color borderMedium;
  final Color borderStrong;
  final List<BoxShadow> shadowSm;
  final List<BoxShadow> shadowMd;
  final List<BoxShadow> shadowLg;
  final List<BoxShadow> shadowXl;
  final List<BoxShadow> shadowPurple;
  final List<BoxShadow> shadowGold;
  final FilterColors filterInactive;
  final FilterColors filterActive;
  final LinearGradient senderBubble;
  final LinearGradient receiverBubble;
  final Color senderText;
  final Color receiverText;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
}

class FilterColors {
  const FilterColors({
    required this.background,
    required this.border,
    required this.text,
  });
  
  final Color background;
  final Color border;
  final Color text;
}

// Spacing System
class AppSpacing {
  static const double xs = 4.0;  // --spacing-xs
  static const double s = 8.0;   // --spacing-s
  static const double m = 16.0;  // --spacing-m
  static const double l = 24.0;  // --spacing-l
  static const double xl = 32.0; // --spacing-xl
  static const double xxl = 48.0; // --spacing-xxl
}

// Border Radius System
class AppRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double premium = 20.0; // --radius-premium
  static const double extraLarge = 30.0; // --radius-large
  static const double circular = 50.0;
}

// Animation Constants
class AppAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration extraSlow = Duration(milliseconds: 800);
  
  // Curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve spring = Curves.elasticOut;
  static const Curve bounce = Curves.bounceOut;
}