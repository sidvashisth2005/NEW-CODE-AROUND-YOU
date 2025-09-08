import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';
import 'models/streak_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/around_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/trails_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/create_memory_screen.dart';
import 'screens/create_trail_screen.dart';
import 'screens/trail_detail_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/memory_detail_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/chat_settings_screen.dart';
import 'screens/chat_interface.dart';
import 'screens/admin_dashboard_screen.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/floating_create_button.dart';
import 'core/utils/logger.dart';
import 'core/constants/app_constants.dart';
import 'dart:math' as math;

enum AppScreen {
  splash,
  onboarding,
  login,
  home,
  around,
  chat,
  chatInterface,
  trails,
  trailDetail,
  profile,
  create,
  createTrail,
  settings,
  memoryDetail,
  notifications,
  chatSettings,
  adminDashboard,
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin {
  AppScreen _currentScreen = AppScreen.splash;
  String _activeTab = 'home';
  bool _isOnboarded = false;
  bool _isLoggedIn = false;
  bool _isInSubScreen = false;
  
  // Selected data for navigation
  dynamic _selectedMemory;
  dynamic _selectedChat;
  dynamic _selectedTrail;
  
  late AnimationController _screenTransitionController;
  late AnimationController _navigationController;

  @override
  void initState() {
    super.initState();
    _screenTransitionController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );
    _navigationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    Logger.info('App initialized');
  }

  @override
  void dispose() {
    _screenTransitionController.dispose();
    _navigationController.dispose();
    Logger.info('App disposed');
    super.dispose();
  }

  void _handleSplashComplete() {
    setState(() {
      _currentScreen = AppScreen.onboarding;
    });
    Logger.navigation('splash', 'onboarding');
  }

  void _handleOnboardingComplete() {
    setState(() {
      _isOnboarded = true;
      _currentScreen = AppScreen.login;
    });
    Logger.navigation('onboarding', 'login');
  }

  void _handleLoginComplete() {
    setState(() {
      _isLoggedIn = true;
      _currentScreen = AppScreen.home;
      _activeTab = 'home';
      _isInSubScreen = false;
    });
    _navigationController.forward();
    Logger.navigation('login', 'home');
  }

  void _handleLogout() {
    setState(() {
      _isLoggedIn = false;
      _isOnboarded = false;
      _currentScreen = AppScreen.splash;
      _activeTab = 'home';
      _isInSubScreen = false;
      _selectedMemory = null;
      _selectedChat = null;
      _selectedTrail = null;
    });
    _navigationController.reset();
    Logger.userAction('logout');
  }

  void navigateToScreen(String screen, {bool isSubScreen = false, dynamic data}) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    final previousScreen = _currentScreen.toString().split('.').last;
    
    setState(() {
      _currentScreen = _stringToAppScreen(screen);
      _isInSubScreen = isSubScreen;
      
      if (data != null) {
        switch (screen) {
          case 'memory-detail':
            _selectedMemory = data;
            break;
          case 'chat-settings':
          case 'chat-interface':
            _selectedChat = data;
            break;
          case 'trail-detail':
            _selectedTrail = data;
            break;
        }
      }
      
      if (['home', 'around', 'chat', 'trails', 'profile'].contains(screen)) {
        _activeTab = screen;
      }
    });
    
    // Play haptic feedback
    themeProvider.hapticFeedback('light');
    themeProvider.playSound('tap');
    
    // Log navigation
    Logger.navigation(previousScreen, screen, arguments: data != null ? {'hasData': true} : null);
    
    // Animate screen transition
    _screenTransitionController.reset();
    _screenTransitionController.forward();
  }

  AppScreen _stringToAppScreen(String screen) {
    switch (screen) {
      case 'splash': return AppScreen.splash;
      case 'onboarding': return AppScreen.onboarding;
      case 'login': return AppScreen.login;
      case 'home': return AppScreen.home;
      case 'around': return AppScreen.around;
      case 'chat': return AppScreen.chat;
      case 'chat-interface': return AppScreen.chatInterface;
      case 'trails': return AppScreen.trails;
      case 'trail-detail': return AppScreen.trailDetail;
      case 'profile': return AppScreen.profile;
      case 'create': return AppScreen.create;
      case 'create-trail': return AppScreen.createTrail;
      case 'settings': return AppScreen.settings;
      case 'memory-detail': return AppScreen.memoryDetail;
      case 'notifications': return AppScreen.notifications;
      case 'chat-settings': return AppScreen.chatSettings;
      case 'admin-dashboard': return AppScreen.adminDashboard;
      default: return AppScreen.home;
    }
  }

  Widget _renderScreen() {
    try {
      switch (_currentScreen) {
        case AppScreen.splash:
          return SplashScreen(onComplete: _handleSplashComplete);
        case AppScreen.onboarding:
          return OnboardingScreen(onComplete: _handleOnboardingComplete);
        case AppScreen.login:
          return LoginScreen(onComplete: _handleLoginComplete);
        case AppScreen.home:
          return HomeScreen(onNavigate: navigateToScreen);
        case AppScreen.around:
          return AroundScreen(onNavigate: navigateToScreen);
        case AppScreen.chat:
          return ChatScreen(onNavigate: navigateToScreen);
        case AppScreen.chatInterface:
          return ChatInterface(
            chat: _selectedChat,
            onBack: () => navigateToScreen('chat'),
            onNavigate: navigateToScreen,
          );
        case AppScreen.trails:
          return TrailsScreen(onNavigate: navigateToScreen);
        case AppScreen.trailDetail:
          return TrailDetailScreen(
            onNavigate: navigateToScreen,
            trail: _selectedTrail,
          );
        case AppScreen.profile:
          return ProfileScreen(onNavigate: navigateToScreen);
        case AppScreen.create:
          return CreateMemoryScreen(onNavigate: navigateToScreen);
        case AppScreen.createTrail:
          return CreateTrailScreen(onNavigate: navigateToScreen);
        case AppScreen.settings:
          return SettingsScreen(
            onNavigate: navigateToScreen,
            onLogout: _handleLogout,
          );
        case AppScreen.memoryDetail:
          return MemoryDetailScreen(
            onNavigate: navigateToScreen,
            memory: _selectedMemory,
          );
        case AppScreen.notifications:
          return NotificationsScreen(onNavigate: navigateToScreen);
        case AppScreen.chatSettings:
          return ChatSettingsScreen(
            onNavigate: navigateToScreen,
            chat: _selectedChat,
          );
        case AppScreen.adminDashboard:
          return AdminDashboardScreen(onNavigate: navigateToScreen);
        default:
          return HomeScreen(onNavigate: navigateToScreen);
      }
    } catch (e, stackTrace) {
      Logger.error('Error rendering screen: $_currentScreen', error: e, stackTrace: stackTrace);
      // Return safe fallback screen
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Something went wrong'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => navigateToScreen('home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      );
    }
  }

  bool get _showNavigation {
    return _isLoggedIn &&
        ![
          AppScreen.splash,
          AppScreen.onboarding,
          AppScreen.login,
          AppScreen.create,
          AppScreen.createTrail,
          AppScreen.trailDetail,
          AppScreen.settings,
          AppScreen.memoryDetail,
          AppScreen.notifications,
          AppScreen.chatSettings,
          AppScreen.chatInterface,
          AppScreen.adminDashboard,
        ].contains(_currentScreen) &&
        !_isInSubScreen;
  }

  bool get _showCreateButton {
    return _isLoggedIn && _currentScreen == AppScreen.home && !_isInSubScreen;
  }

  bool get _showCreateTrailButton {
    return _isLoggedIn && _currentScreen == AppScreen.trails && !_isInSubScreen;
  }

  @override
  Widget build(BuildContext context) {
    // Get responsive metrics
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final safeAreaTop = mediaQuery.padding.top;
    final safeAreaBottom = mediaQuery.padding.bottom;
    final availableHeight = screenHeight - safeAreaTop - safeAreaBottom;
    
    // Responsive calculations
    final isSmallScreen = screenWidth < 380;
    final isMediumScreen = screenWidth >= 380 && screenWidth < 414;
    final responsivePadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;

    return ChangeNotifierProvider(
      create: (context) => StreakProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Set system UI overlay style
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: themeProvider.isDarkMode 
                  ? Brightness.light 
                  : Brightness.dark,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: themeProvider.isDarkMode 
                  ? Brightness.light 
                  : Brightness.dark,
            ),
          );

          return Container(
            decoration: BoxDecoration(
              gradient: themeProvider.colors.background,
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              extendBody: true,
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: false, // Prevent keyboard overflow
              body: MediaQuery(
                // Control text scaling to prevent overflow
                data: mediaQuery.copyWith(
                  textScaler: TextScaler.linear(
                    math.min(1.2, math.max(0.8, mediaQuery.textScaler.scale(1.0))),
                  ),
                ),
                child: Stack(
                  children: [
                    // Main Content with responsive constraints
                    Positioned.fill(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: availableHeight,
                          maxHeight: double.infinity,
                          minWidth: screenWidth,
                          maxWidth: screenWidth,
                        ),
                        child: AnimatedSwitcher(
                          duration: Duration(
                            milliseconds: _currentScreen == AppScreen.splash ? 800 : 400,
                          ),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.05),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                )),
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            key: ValueKey(_currentScreen),
                            child: _renderScreen(),
                          ),
                        ),
                      ),
                    ),
                    
                    // Enhanced Bottom Navigation with glassmorphism
                    if (_showNavigation)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.only(
                            left: responsivePadding,
                            right: responsivePadding,
                            bottom: math.max(safeAreaBottom, 16.0),
                            top: 16.0,
                          ),
                          child: BottomNavigation(
                            activeTab: _activeTab,
                            onTabChanged: (tab) {
                              setState(() {
                                _activeTab = tab;
                              });
                              navigateToScreen(tab);
                            },
                          ),
                        ),
                      ),
                    
                    // Enhanced Floating Create Buttons with responsive positioning
                    if (_showCreateButton)
                      Positioned(
                        right: responsivePadding,
                        bottom: _showNavigation 
                            ? 120 + safeAreaBottom 
                            : 32 + safeAreaBottom,
                        child: FloatingCreateButton(
                          type: CreateButtonType.memory,
                          onPressed: () => navigateToScreen('create'),
                          showNavigation: _showNavigation,
                        ),
                      ),
                    
                    if (_showCreateTrailButton)
                      Positioned(
                        right: responsivePadding,
                        bottom: _showNavigation 
                            ? 120 + safeAreaBottom 
                            : 32 + safeAreaBottom,
                        child: FloatingCreateButton(
                          type: CreateButtonType.trail,
                          onPressed: () => navigateToScreen('create-trail'),
                          showNavigation: _showNavigation,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}