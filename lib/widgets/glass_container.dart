import 'package:flutter/material.dart';
import 'dart:ui';
import '../core/constants/app_constants.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final Border? border;
  
  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = AppConstants.radiusM,
    this.blur = 25.0,
    this.backgroundColor,
    this.borderColor,
    this.boxShadow,
    this.onTap,
    this.border,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final defaultBackgroundColor = backgroundColor ?? 
        (isDark 
            ? AppConstants.darkGlassBackground 
            : AppConstants.lightGlassBackground);
    
    final defaultBorderColor = borderColor ?? 
        (isDark 
            ? AppConstants.darkGlassBorder 
            : AppConstants.lightGlassBorder);
    
    final defaultBoxShadow = boxShadow ?? 
        (isDark 
            ? AppConstants.darkShadowMd 
            : AppConstants.shadowMd);
    
    Widget container = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? Border.all(
          color: defaultBorderColor,
          width: 1,
        ),
        boxShadow: defaultBoxShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: child,
        ),
      ),
    );
    
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }
    
    return container;
  }
}

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool isPressed;
  
  const NeumorphicContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = AppConstants.radiusM,
    this.backgroundColor,
    this.onTap,
    this.isPressed = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final bgColor = backgroundColor ?? 
        (isDark 
            ? AppConstants.darkBackground 
            : AppConstants.lightBackground);
    
    final shadows = isDark
        ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: Offset(isPressed ? 2 : 8, isPressed ? 2 : 8),
              blurRadius: isPressed ? 4 : 16,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.05),
              offset: Offset(isPressed ? -1 : -4, isPressed ? -1 : -4),
              blurRadius: isPressed ? 2 : 8,
            ),
          ]
        : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(isPressed ? 2 : 8, isPressed ? 2 : 8),
              blurRadius: isPressed ? 4 : 16,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.7),
              offset: Offset(isPressed ? -1 : -8, isPressed ? -1 : -8),
              blurRadius: isPressed ? 2 : 16,
            ),
          ];
    
    Widget container = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadows,
      ),
      child: child,
    );
    
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }
    
    return container;
  }
}

class PremiumCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool showGlow;
  final Color? glowColor;
  
  const PremiumCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(AppConstants.spacingM),
    this.margin,
    this.borderRadius = AppConstants.radiusL,
    this.onTap,
    this.showGlow = false,
    this.glowColor,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final defaultGlowColor = glowColor ?? AppConstants.royalPurple;
    
    final shadows = [
      if (isDark) ...AppConstants.darkShadowLg else ...AppConstants.shadowLg,
      if (showGlow)
        BoxShadow(
          color: defaultGlowColor.withOpacity(0.25),
          blurRadius: 32,
          spreadRadius: 0,
        ),
    ];
    
    return GlassContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      boxShadow: shadows,
      onTap: onTap,
      child: child,
    );
  }
}