import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../core/constants/app_constants.dart';
import '../widgets/glass_container.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      title: 'Discover',
      subtitle: 'AR memories around you',
      description: 'Use advanced AR technology to discover memories left by others in real-world locations around you.',
      iconData: Icons.camera_alt_outlined,
      gradientColors: [
        AppConstants.royalPurple,
        AppConstants.lavender,
      ],
    ),
    OnboardingSlide(
      title: 'Create',
      subtitle: 'Leave memories for others',
      description: 'Create lasting memories by anchoring photos, videos, and messages to specific locations for others to find.',
      iconData: Icons.add_location_alt_outlined,
      gradientColors: [
        AppConstants.lavender,
        AppConstants.gold,
      ],
    ),
    OnboardingSlide(
      title: 'Connect',
      subtitle: 'Join trails and communities',
      description: 'Follow curated trails, connect with like-minded people, and build a community around shared experiences.',
      iconData: Icons.people_outline,
      gradientColors: [
        AppConstants.gold,
        AppConstants.royalPurple,
      ],
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }
  
  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: AppConstants.animationMedium,
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: AppConstants.animationFast,
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    // Start initial animations
    _slideController.forward();
    _fadeController.forward();
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
  
  void _nextPage() {
    final themeProvider = context.read<ThemeProvider>();
    themeProvider.hapticFeedback(HapticFeedbackType.light);
    
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.animationMedium,
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }
  
  void _skipOnboarding() {
    final themeProvider = context.read<ThemeProvider>();
    themeProvider.hapticFeedback(HapticFeedbackType.medium);
    _navigateToLogin();
  }
  
  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionDuration: AppConstants.animationSlow,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            ),
          );
        },
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingL),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        'Skip',
                        style: AppConstants.titleMedium.copyWith(
                          color: isDark
                              ? AppConstants.darkTextSecondary
                              : AppConstants.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main Content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    themeProvider.hapticFeedback(HapticFeedbackType.selection);
                  },
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    return SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildSlide(_slides[index], isDark),
                      ),
                    );
                  },
                ),
              ),
              
              // Bottom Section
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingXL),
                child: Column(
                  children: [
                    // Page Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_slides.length, (index) {
                        return AnimatedContainer(
                          duration: AppConstants.animationFast,
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingXS,
                          ),
                          width: _currentPage == index ? 32 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _currentPage == index
                                ? AppConstants.royalPurple
                                : (isDark
                                    ? AppConstants.darkTextSecondary
                                    : AppConstants.lightTextSecondary
                                  ).withOpacity(0.3),
                          ),
                        );
                      }),
                    ),
                    
                    const SizedBox(height: AppConstants.spacingXL),
                    
                    // Next/Get Started Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.royalPurple,
                          foregroundColor: AppConstants.pureWhite,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.spacingM,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.radiusM),
                          ),
                          elevation: 0,
                          shadowColor: AppConstants.royalPurple.withOpacity(0.3),
                        ),
                        child: Text(
                          _currentPage == _slides.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: AppConstants.titleMedium.copyWith(
                            color: AppConstants.pureWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSlide(OnboardingSlide slide, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with gradient background
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: slide.gradientColors.map((c) => c.withOpacity(0.2)).toList(),
              ),
              border: Border.all(
                color: slide.gradientColors.first.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              slide.iconData,
              size: 48,
              color: slide.gradientColors.first,
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingXXL),
          
          // Title
          Text(
            slide.title,
            style: AppConstants.displayMedium.copyWith(
              color: isDark
                  ? AppConstants.darkTextPrimary
                  : AppConstants.lightTextPrimary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppConstants.spacingM),
          
          // Subtitle
          Text(
            slide.subtitle,
            style: AppConstants.headlineSmall.copyWith(
              color: slide.gradientColors.first,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppConstants.spacingL),
          
          // Description
          Text(
            slide.description,
            style: AppConstants.bodyLarge.copyWith(
              color: isDark
                  ? AppConstants.darkTextSecondary
                  : AppConstants.lightTextSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}

class OnboardingSlide {
  final String title;
  final String subtitle;
  final String description;
  final IconData iconData;
  final List<Color> gradientColors;
  
  const OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.iconData,
    required this.gradientColors,
  });
}