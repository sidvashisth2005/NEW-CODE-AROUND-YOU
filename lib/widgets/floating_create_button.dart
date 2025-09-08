import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_colors.dart';

enum CreateButtonType {
  memory,
  trail,
}

class FloatingCreateButton extends StatefulWidget {
  final CreateButtonType type;
  final VoidCallback onPressed;
  final bool showNavigation;

  const FloatingCreateButton({
    super.key,
    required this.type,
    required this.onPressed,
    this.showNavigation = true,
  });

  @override
  State<FloatingCreateButton> createState() => _FloatingCreateButtonState();
}

class _FloatingCreateButtonState extends State<FloatingCreateButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    // Scale animation for entrance
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    // Pulse animation for breathing effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Rotation animation for press effect
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25, // 90 degrees in turns
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    // Start entrance animation
    Future.delayed(const Duration(milliseconds: 100), () {
      _scaleController.forward();
      _startPulseAnimation();
    });
  }

  void _startPulseAnimation() {
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _rotationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _rotationController.reverse();
    
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('medium');
    themeProvider.playSound('tap');
    
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _rotationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final colors = themeProvider.colors;
        final mediaQuery = MediaQuery.of(context);
        final screenWidth = mediaQuery.size.width;
        final isSmallScreen = screenWidth < 380;
        final isMediumScreen = screenWidth >= 380 && screenWidth < 414;
        
        // Responsive sizing
        final buttonSize = isSmallScreen ? 52.0 : isMediumScreen ? 56.0 : 60.0;
        final pulseSize = isSmallScreen ? 65.0 : isMediumScreen ? 70.0 : 75.0;
        final iconSize = isSmallScreen ? 24.0 : isMediumScreen ? 28.0 : 32.0;
        final rightPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
        
        final gradient = widget.type == CreateButtonType.memory
            ? colors.gradientGold
            : colors.gradientPrimary;
            
        final shadows = widget.type == CreateButtonType.memory
            ? colors.shadowGold
            : colors.shadowPurple;

        return AnimatedBuilder(
          animation: Listenable.merge([
            _scaleAnimation,
            _pulseAnimation,
            _rotationAnimation,
          ]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value * (_isPressed ? 0.9 : 1.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Enhanced pulse ring effect
                  Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: pulseSize,
                      height: pulseSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            (widget.type == CreateButtonType.memory 
                                ? colors.accent 
                                : colors.accentSecondary).withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Main button with enhanced design
                  GestureDetector(
                    onTapDown: _handleTapDown,
                    onTapUp: _handleTapUp,
                    onTapCancel: _handleTapCancel,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * 2 * 3.14159,
                      child: Container(
                        width: buttonSize,
                        height: buttonSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: gradient,
                          boxShadow: [
                            ...shadows,
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          widget.type == CreateButtonType.memory
                              ? Icons.add_rounded
                              : Icons.route_rounded,
                          size: iconSize,
                          color: widget.type == CreateButtonType.memory
                              ? Colors.black87
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  // Enhanced glow effect
                  if (!_isPressed)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Enhanced floating action button with premium effects
class PremiumFloatingActionButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final double size;
  final bool mini;
  final String? heroTag;

  const PremiumFloatingActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.gradient,
    this.boxShadow,
    this.size = 56.0,
    this.mini = false,
    this.heroTag,
  });

  @override
  State<PremiumFloatingActionButton> createState() => _PremiumFloatingActionButtonState();
}

class _PremiumFloatingActionButtonState extends State<PremiumFloatingActionButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _rippleController;
  late Animation<double> _pressAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    
    _pressController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _pressController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _pressController.forward().then((_) {
      _pressController.reverse();
    });
    
    _rippleController.forward().then((_) {
      _rippleController.reset();
    });
    
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark 
        ? AppColors.dark 
        : AppColors.light;
    
    final effectiveSize = widget.mini ? 40.0 : widget.size;
    final effectiveGradient = widget.gradient ?? colors.gradientPrimary;
    final effectiveShadow = widget.boxShadow ?? colors.shadowPurple;

    return AnimatedBuilder(
      animation: Listenable.merge([_pressAnimation, _rippleAnimation]),
      builder: (context, child) {
        return Hero(
          tag: widget.heroTag ?? 'fab',
          child: Transform.scale(
            scale: _pressAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ripple effect
                if (_rippleAnimation.value > 0)
                  Transform.scale(
                    scale: 1 + (_rippleAnimation.value * 0.5),
                    child: Opacity(
                      opacity: 1 - _rippleAnimation.value,
                      child: Container(
                        width: effectiveSize,
                        height: effectiveSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: effectiveGradient,
                        ),
                      ),
                    ),
                  ),
                
                // Main button
                GestureDetector(
                  onTap: _handleTap,
                  child: Container(
                    width: effectiveSize,
                    height: effectiveSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: effectiveGradient,
                      boxShadow: effectiveShadow,
                    ),
                    child: Center(child: widget.icon),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Expandable floating action menu
class ExpandableFAB extends StatefulWidget {
  final List<FABMenuItem> items;
  final Widget icon;
  final Gradient? gradient;

  const ExpandableFAB({
    super.key,
    required this.items,
    required this.icon,
    this.gradient,
  });

  @override
  State<ExpandableFAB> createState() => _ExpandableFABState();
}

class _ExpandableFABState extends State<ExpandableFAB>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;
  
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125, // 45 degrees
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark 
        ? AppColors.dark 
        : AppColors.light;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Menu items
        ...widget.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          
          return AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              final offset = (index + 1) * 70.0 * _expandAnimation.value;
              
              return Transform.translate(
                offset: Offset(0, -offset),
                child: Opacity(
                  opacity: _expandAnimation.value,
                  child: ScaleTransition(
                    scale: _expandAnimation,
                    child: PremiumFloatingActionButton(
                      icon: Icon(item.icon, color: Colors.white),
                      onPressed: () {
                        _toggle();
                        item.onPressed();
                      },
                      size: 48,
                      gradient: colors.gradientSecondary,
                      heroTag: 'fab_${item.label}',
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
        
        // Main FAB
        AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159,
              child: PremiumFloatingActionButton(
                icon: widget.icon,
                onPressed: _toggle,
                gradient: widget.gradient,
                heroTag: 'main_fab',
              ),
            );
          },
        ),
      ],
    );
  }
}

class FABMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const FABMenuItem({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
}