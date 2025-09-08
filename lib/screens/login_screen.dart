import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../core/constants/app_constants.dart';
import '../widgets/glass_container.dart';
import '../widgets/logo.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isLoading = false;
  bool _isAppleLoading = false;
  bool _isGoogleLoading = false;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }
  
  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: AppConstants.animationSlow,
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: AppConstants.animationSlow,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }
  
  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _slideController.forward();
  }
  
  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
  
  Future<void> _handleAppleSignIn() async {
    final themeProvider = context.read<ThemeProvider>();
    themeProvider.hapticFeedback(HapticFeedbackType.medium);
    themeProvider.playSound(SoundType.tap);
    
    setState(() {
      _isAppleLoading = true;
      _isLoading = true;
    });
    
    // Simulate Apple Sign In
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        _isAppleLoading = false;
        _isLoading = false;
      });
      
      themeProvider.hapticFeedback(HapticFeedbackType.heavy);
      themeProvider.playSound(SoundType.success);
      
      _navigateToHome();
    }
  }
  
  Future<void> _handleGoogleSignIn() async {
    final themeProvider = context.read<ThemeProvider>();
    themeProvider.hapticFeedback(HapticFeedbackType.medium);
    themeProvider.playSound(SoundType.tap);
    
    setState(() {
      _isGoogleLoading = true;
      _isLoading = true;
    });
    
    // Simulate Google Sign In
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        _isGoogleLoading = false;
        _isLoading = false;
      });
      
      themeProvider.hapticFeedback(HapticFeedbackType.heavy);
      themeProvider.playSound(SoundType.success);
      
      _navigateToHome();
    }
  }
  
  Future<void> _handleGuestMode() async {
    final themeProvider = context.read<ThemeProvider>();
    themeProvider.hapticFeedback(HapticFeedbackType.light);
    themeProvider.playSound(SoundType.tap);
    
    _navigateToHome();
  }
  
  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
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
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.spacingXL),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        
                        // Logo and Welcome
                        Column(
                          children: [
                            const AroundYouLogo(
                              size: 100,
                              animated: true,
                              showText: true,
                            ),
                            const SizedBox(height: AppConstants.spacingXXL),
                            Text(
                              'Welcome Back',
                              style: AppConstants.displayMedium.copyWith(
                                color: isDark
                                    ? AppConstants.darkTextPrimary
                                    : AppConstants.lightTextPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppConstants.spacingM),
                            Text(
                              'Sign in to continue your AR journey',
                              style: AppConstants.bodyLarge.copyWith(
                                color: isDark
                                    ? AppConstants.darkTextSecondary
                                    : AppConstants.lightTextSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        
                        const Spacer(flex: 3),
                        
                        // Login Options
                        Column(
                          children: [
                            // Apple Sign In
                            _buildSignInButton(
                              onTap: _handleAppleSignIn,
                              icon: Icons.apple,
                              text: 'Continue with Apple',
                              backgroundColor: isDark 
                                  ? AppConstants.pureWhite 
                                  : AppConstants.pureBlack,
                              textColor: isDark 
                                  ? AppConstants.pureBlack 
                                  : AppConstants.pureWhite,
                              isLoading: _isAppleLoading,
                              isPrimary: true,
                            ),
                            
                            const SizedBox(height: AppConstants.spacingM),
                            
                            // Google Sign In
                            _buildSignInButton(
                              onTap: _handleGoogleSignIn,
                              icon: Icons.google,
                              text: 'Continue with Google',
                              backgroundColor: isDark 
                                  ? AppConstants.darkGlassBackground 
                                  : AppConstants.lightGlassBackground,
                              textColor: isDark 
                                  ? AppConstants.darkTextPrimary 
                                  : AppConstants.lightTextPrimary,
                              isLoading: _isGoogleLoading,
                              isGlass: true,
                            ),
                            
                            const SizedBox(height: AppConstants.spacingXL),
                            
                            // Divider
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: isDark
                                        ? AppConstants.darkGlassBorder
                                        : AppConstants.lightGlassBorder,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppConstants.spacingM,
                                  ),
                                  child: Text(
                                    'or',
                                    style: AppConstants.bodySmall.copyWith(
                                      color: isDark
                                          ? AppConstants.darkTextSecondary
                                          : AppConstants.lightTextSecondary,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: isDark
                                        ? AppConstants.darkGlassBorder
                                        : AppConstants.lightGlassBorder,
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: AppConstants.spacingXL),
                            
                            // Guest Mode
                            TextButton(
                              onPressed: _isLoading ? null : _handleGuestMode,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppConstants.spacingM,
                                  horizontal: AppConstants.spacingL,
                                ),
                              ),
                              child: Text(
                                'Continue as Guest',
                                style: AppConstants.titleMedium.copyWith(
                                  color: AppConstants.royalPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const Spacer(flex: 1),
                        
                        // Terms and Privacy
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingL,
                          ),
                          child: Text(
                            'By continuing, you agree to our Terms of Service and Privacy Policy',
                            style: AppConstants.bodySmall.copyWith(
                              color: isDark
                                  ? AppConstants.darkTextSecondary
                                  : AppConstants.lightTextSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  
  Widget _buildSignInButton({
    required VoidCallback onTap,
    required IconData icon,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    bool isLoading = false,
    bool isPrimary = false,
    bool isGlass = false,
  }) {
    final content = Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: isGlass ? null : backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: isGlass 
            ? Border.all(
                color: context.watch<ThemeProvider>().isDarkMode
                    ? AppConstants.darkGlassBorder
                    : AppConstants.lightGlassBorder,
              )
            : null,
        boxShadow: isPrimary
            ? (context.watch<ThemeProvider>().isDarkMode
                ? AppConstants.darkShadowMd
                : AppConstants.shadowMd)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingL,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                else
                  Icon(
                    icon,
                    color: textColor,
                    size: 20,
                  ),
                const SizedBox(width: AppConstants.spacingM),
                Text(
                  text,
                  style: AppConstants.titleMedium.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
    if (isGlass) {
      return GlassContainer(
        borderRadius: AppConstants.radiusM,
        child: content,
      );
    }
    
    return content;
  }
}