import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/constants/app_constants.dart';

class AroundYouLogo extends StatefulWidget {
  final double size;
  final bool animated;
  final bool showText;
  final Color? color;
  
  const AroundYouLogo({
    super.key,
    this.size = 80,
    this.animated = false,
    this.showText = false,
    this.color,
  });

  @override
  State<AroundYouLogo> createState() => _AroundYouLogoState();
}

class _AroundYouLogoState extends State<AroundYouLogo>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  
  @override
  void initState() {
    super.initState();
    
    if (widget.animated) {
      _rotationController = AnimationController(
        duration: const Duration(seconds: 8),
        vsync: this,
      )..repeat();
      
      _glowController = AnimationController(
        duration: const Duration(seconds: 3),
        vsync: this,
      )..repeat(reverse: true);
      
      _glowAnimation = Tween<double>(
        begin: 0.3,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ));
    }
  }
  
  @override
  void dispose() {
    if (widget.animated) {
      _rotationController.dispose();
      _glowController.dispose();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final logoColor = widget.color ?? AppConstants.royalPurple;
    
    Widget logo = SizedBox(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: _LogoPainter(
          color: logoColor,
          glowIntensity: widget.animated 
              ? (_glowAnimation?.value ?? 0.5) 
              : 0.5,
          isDark: isDark,
        ),
      ),
    );
    
    if (widget.animated) {
      logo = AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationController.value * 2 * math.pi,
            child: child,
          );
        },
        child: logo,
      );
      
      logo = AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: logoColor.withOpacity(_glowAnimation.value * 0.4),
                  blurRadius: 20 * _glowAnimation.value,
                  spreadRadius: 5 * _glowAnimation.value,
                ),
              ],
            ),
            child: child,
          );
        },
        child: logo,
      );
    }
    
    if (widget.showText) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          logo,
          const SizedBox(height: AppConstants.spacingM),
          Text(
            AppConstants.appName,
            style: AppConstants.headlineMedium.copyWith(
              color: isDark 
                  ? AppConstants.darkTextPrimary 
                  : AppConstants.lightTextPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXS),
          Text(
            'AR Social Discovery',
            style: AppConstants.bodySmall.copyWith(
              color: isDark 
                  ? AppConstants.darkTextSecondary 
                  : AppConstants.lightTextSecondary,
              letterSpacing: 0.8,
            ),
          ),
        ],
      );
    }
    
    return logo;
  }
}

class _LogoPainter extends CustomPainter {
  final Color color;
  final double glowIntensity;
  final bool isDark;
  
  const _LogoPainter({
    required this.color,
    required this.glowIntensity,
    required this.isDark,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Create paints
    final backgroundPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withOpacity(0.8),
          color.withOpacity(0.4),
          Colors.transparent,
        ],
        stops: const [0.3, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    final outerRingPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    
    final innerRingPaint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    final centerPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color,
          color.withBlue((color.blue * 1.3).clamp(0, 255).toInt()),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.3));
    
    final accentPaint = Paint()
      ..color = AppConstants.gold
      ..style = PaintingStyle.fill;
    
    // Draw background glow
    canvas.drawCircle(center, radius * 0.9, backgroundPaint);
    
    // Draw outer ring
    canvas.drawCircle(center, radius * 0.8, outerRingPaint);
    
    // Draw inner ring
    canvas.drawCircle(center, radius * 0.6, innerRingPaint);
    
    // Draw center circle
    canvas.drawCircle(center, radius * 0.35, centerPaint);
    
    // Draw AR-like elements (corner brackets)
    final bracketPaint = Paint()
      ..color = AppConstants.gold.withOpacity(glowIntensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    
    final bracketSize = radius * 0.25;
    final bracketOffset = radius * 0.55;
    
    // Top-left bracket
    final topLeft = Offset(center.dx - bracketOffset, center.dy - bracketOffset);
    canvas.drawLine(
      topLeft,
      Offset(topLeft.dx + bracketSize, topLeft.dy),
      bracketPaint,
    );
    canvas.drawLine(
      topLeft,
      Offset(topLeft.dx, topLeft.dy + bracketSize),
      bracketPaint,
    );
    
    // Top-right bracket
    final topRight = Offset(center.dx + bracketOffset, center.dy - bracketOffset);
    canvas.drawLine(
      topRight,
      Offset(topRight.dx - bracketSize, topRight.dy),
      bracketPaint,
    );
    canvas.drawLine(
      topRight,
      Offset(topRight.dx, topRight.dy + bracketSize),
      bracketPaint,
    );
    
    // Bottom-left bracket
    final bottomLeft = Offset(center.dx - bracketOffset, center.dy + bracketOffset);
    canvas.drawLine(
      bottomLeft,
      Offset(bottomLeft.dx + bracketSize, bottomLeft.dy),
      bracketPaint,
    );
    canvas.drawLine(
      bottomLeft,
      Offset(bottomLeft.dx, bottomLeft.dy - bracketSize),
      bracketPaint,
    );
    
    // Bottom-right bracket
    final bottomRight = Offset(center.dx + bracketOffset, center.dy + bracketOffset);
    canvas.drawLine(
      bottomRight,
      Offset(bottomRight.dx - bracketSize, bottomRight.dy),
      bracketPaint,
    );
    canvas.drawLine(
      bottomRight,
      Offset(bottomRight.dx, bottomRight.dy - bracketSize),
      bracketPaint,
    );
    
    // Draw center crosshair
    final crosshairPaint = Paint()
      ..color = AppConstants.pureWhite.withOpacity(glowIntensity * 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    
    final crosshairSize = radius * 0.15;
    
    // Horizontal line
    canvas.drawLine(
      Offset(center.dx - crosshairSize, center.dy),
      Offset(center.dx + crosshairSize, center.dy),
      crosshairPaint,
    );
    
    // Vertical line
    canvas.drawLine(
      Offset(center.dx, center.dy - crosshairSize),
      Offset(center.dx, center.dy + crosshairSize),
      crosshairPaint,
    );
    
    // Center dot
    canvas.drawCircle(
      center,
      3,
      Paint()..color = AppConstants.pureWhite.withOpacity(glowIntensity),
    );
    
    // Draw floating accent dots
    final dotPaint = Paint()
      ..color = AppConstants.gold.withOpacity(glowIntensity * 0.7);
    
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi * 2) / 6;
      final dotCenter = Offset(
        center.dx + math.cos(angle) * radius * 0.45,
        center.dy + math.sin(angle) * radius * 0.45,
      );
      canvas.drawCircle(dotCenter, 2, dotPaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _LogoPainter &&
        (oldDelegate.glowIntensity != glowIntensity ||
         oldDelegate.color != color ||
         oldDelegate.isDark != isDark);
  }
}