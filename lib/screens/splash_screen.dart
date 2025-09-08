import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../theme/theme_provider.dart';
import '../core/constants/app_constants.dart';
import '../widgets/logo.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _particleController;
  late AnimationController _progressController;
  late AnimationController _fadeController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _progressValue;
  late Animation<double> _fadeOpacity;
  
  double _loadingProgress = 0.0;
  String _loadingText = 'Initializing AR Engine...';
  
  final List<String> _loadingSteps = [
    'Initializing AR Engine...',
    'Loading Memory Database...',
    'Connecting to Network...',
    'Preparing Experience...',
    'Welcome to Around You!'
  ];
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startLoadingSequence();
  }
  
  void _initializeAnimations() {
    // Logo Animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    // Particle Animation
    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    // Progress Animation
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _progressValue = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    
    // Fade Animation
    _fadeController = AnimationController(
      duration: AppConstants.animationSplash,
      vsync: this,
    );
    
    _fadeOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
  }
  
  void _startLoadingSequence() async {
    final themeProvider = context.read<ThemeProvider>();
    
    // Show logo after initial delay
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    themeProvider.hapticFeedback(HapticFeedbackType.light);
    
    // Start progress animation
    await Future.delayed(const Duration(milliseconds: 800));
    _progressController.forward();
    
    // Simulate loading steps
    for (int i = 0; i < _loadingSteps.length; i++) {
      await Future.delayed(Duration(milliseconds: 600 + (i * 100)));
      if (mounted) {
        setState(() {
          _loadingProgress = (i + 1) / _loadingSteps.length;
          _loadingText = _loadingSteps[i];
        });
        
        if (i == _loadingSteps.length - 1) {
          themeProvider.hapticFeedback(HapticFeedbackType.medium);
          themeProvider.playSound(SoundType.success);
          
          // Complete animation and navigate
          await Future.delayed(const Duration(milliseconds: 1000));
          _fadeController.forward();
          
          await Future.delayed(AppConstants.animationSplash);
          if (mounted) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const OnboardingScreen(),
                transitionDuration: AppConstants.animationSlow,
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          }
        }
      }
    }
  }
  
  @override
  void dispose() {
    _logoController.dispose();
    _particleController.dispose();
    _progressController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeOpacity,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeOpacity.value,
            child: Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF000000),
                          const Color(0xFF1A0A2E),
                          const Color(0xFF16213E),
                        ]
                      : [
                          const Color(0xFFF8F7FF),
                          const Color(0xFFE8E5FF),
                          const Color(0xFFD6D0FF),
                        ],
                ),
              ),
              child: Stack(
                children: [
                  // Enhanced Background Particles
                  _buildParticleSystem(size, isDark),
                  
                  // Grid Overlay
                  _buildGridOverlay(size, isDark),
                  
                  // Center Glow Effect
                  _buildCenterGlow(size, isDark),
                  
                  // Main Content
                  _buildMainContent(size, isDark, themeProvider),
                  
                  // Bottom Branding
                  _buildBottomBranding(size, isDark),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildParticleSystem(Size size, bool isDark) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: [
            // Floating Orbs
            ...List.generate(18, (index) {
              final orbSize = 30.0 + (index % 5) * 20.0;
              final initialX = (index * 137.5) % size.width;
              final initialY = (index * 200.0) % size.height;
              final animationOffset = _particleController.value * 2 * math.pi;
              
              return Positioned(
                left: initialX + math.sin(animationOffset + index) * 50,
                top: initialY + math.cos(animationOffset + index * 0.7) * 30,
                child: Transform.scale(
                  scale: 0.8 + math.sin(animationOffset + index * 0.5) * 0.3,
                  child: Container(
                    width: orbSize,
                    height: orbSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          (isDark
                              ? AppConstants.royalPurple.withOpacity(0.2)
                              : AppConstants.lavender.withOpacity(0.3)),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            
            // Particle Trail
            ...List.generate(25, (index) {
              final particleX = (index * 67.3) % size.width;
              final particleY = size.height + 
                  (math.sin(_particleController.value * 2 * math.pi + index) * 100);
              
              return Positioned(
                left: particleX,
                top: particleY - (_particleController.value * size.height * 1.5),
                child: Container(
                  width: 2,
                  height: 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? Colors.white.withOpacity(0.6)
                        : AppConstants.royalPurple.withOpacity(0.4),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.white.withOpacity(0.3)
                            : AppConstants.royalPurple.withOpacity(0.3),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
  
  Widget _buildGridOverlay(Size size, bool isDark) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            math.sin(_particleController.value * 2 * math.pi) * 10,
            math.cos(_particleController.value * 2 * math.pi) * 5,
          ),
          child: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _createGridPattern(isDark),
                repeat: ImageRepeat.repeat,
                opacity: isDark ? 0.08 : 0.04,
              ),
            ),
          ),
        );
      },
    );
  }
  
  ImageProvider _createGridPattern(bool isDark) {
    // This would need to be implemented with a custom painter or asset
    // For now, returning a placeholder
    return const AssetImage('assets/images/grid_pattern.png');
  }
  
  Widget _buildCenterGlow(Size size, bool isDark) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Positioned(
          left: size.width / 2 - 200,
          top: size.height / 2 - 200,
          child: Transform.scale(
            scale: 1.0 + math.sin(_particleController.value * 2 * math.pi) * 0.1,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    isDark
                        ? AppConstants.royalPurple.withOpacity(0.08)
                        : AppConstants.lavender.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildMainContent(Size size, bool isDark, ThemeProvider themeProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          AnimatedBuilder(
            animation: _logoScale,
            builder: (context, child) {
              return Transform.scale(
                scale: _logoScale.value,
                child: Opacity(
                  opacity: _logoOpacity.value,
                  child: const AroundYouLogo(
                    size: 120,
                    animated: true,
                    showText: true,
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: AppConstants.spacingXXL),
          
          // Loading Section
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return Opacity(
                opacity: _progressController.value,
                child: SizedBox(
                  width: 320,
                  child: Column(
                    children: [
                      // Loading Text
                      AnimatedSwitcher(
                        duration: AppConstants.animationMedium,
                        child: Column(
                          key: ValueKey(_loadingText),
                          children: [
                            Text(
                              _loadingText,
                              style: AppConstants.titleMedium.copyWith(
                                color: isDark
                                    ? AppConstants.darkTextPrimary
                                    : AppConstants.lightTextPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppConstants.spacingS),
                            Text(
                              '${(_loadingProgress * 100).round()}%',
                              style: AppConstants.bodySmall.copyWith(
                                color: isDark
                                    ? AppConstants.darkTextSecondary
                                    : AppConstants.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.spacingL),
                      
                      // Progress Bar
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isDark
                              ? AppConstants.darkGlassBackground
                              : AppConstants.lightGlassBackground,
                          border: Border.all(
                            color: isDark
                                ? AppConstants.darkGlassBorder
                                : AppConstants.lightGlassBorder,
                          ),
                          boxShadow: isDark
                              ? AppConstants.darkShadowMd
                              : AppConstants.shadowMd,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: AnimatedBuilder(
                            animation: _progressValue,
                            builder: (context, child) {
                              return LinearProgressIndicator(
                                value: _loadingProgress,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppConstants.royalPurple,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.spacingL),
                      
                      // Loading Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return AnimatedBuilder(
                            animation: _particleController,
                            builder: (context, child) {
                              final animationValue = 
                                  (_particleController.value * 3 - index) % 1;
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.spacingXS,
                                ),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (isDark
                                      ? Colors.white
                                      : AppConstants.royalPurple
                                  ).withOpacity(0.4 + animationValue * 0.6),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomBranding(Size size, bool isDark) {
    return Positioned(
      bottom: AppConstants.spacingXXL,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _progressController,
        builder: (context, child) {
          return Opacity(
            opacity: _progressController.value * 0.8,
            child: Column(
              children: [
                Text(
                  'Powered by Advanced AR Technology',
                  style: AppConstants.bodySmall.copyWith(
                    color: isDark
                        ? AppConstants.darkTextSecondary
                        : AppConstants.lightTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacingS),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppConstants.royalPurple,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    Text(
                      'Premium iOS Experience',
                      style: AppConstants.labelSmall.copyWith(
                        color: isDark
                            ? AppConstants.darkTextSecondary
                            : AppConstants.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppConstants.royalPurple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}