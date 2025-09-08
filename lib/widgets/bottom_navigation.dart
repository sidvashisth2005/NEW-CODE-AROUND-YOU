import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_colors.dart';
import 'glass_container.dart';

class BottomNavigation extends StatefulWidget {
  final String activeTab;
  final Function(String) onTabChanged;

  const BottomNavigation({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _rippleController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  final List<NavItem> _navItems = [
    NavItem(
      id: 'home',
      icon: Icons.camera_alt_rounded,
      label: 'Home',
    ),
    NavItem(
      id: 'around',
      icon: Icons.map_rounded,
      label: 'Around',
    ),
    NavItem(
      id: 'chat',
      icon: Icons.forum_rounded,
      label: 'Chat',
    ),
    NavItem(
      id: 'trails',
      icon: Icons.route_rounded,
      label: 'Trails',
    ),
    NavItem(
      id: 'profile',
      icon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  void _handleTabTap(String tabId) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('light');
    themeProvider.playSound('tap');
    
    widget.onTabChanged(tabId);
    _rippleController.forward().then((_) {
      _rippleController.reset();
    });
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
        
        // Responsive calculations
        final horizontalPadding = isSmallScreen ? 12.0 : isMediumScreen ? 16.0 : 20.0;
        final navHeight = isSmallScreen ? 64.0 : isMediumScreen ? 70.0 : 76.0;
        final borderRadius = isSmallScreen ? 20.0 : isMediumScreen ? 24.0 : 28.0;
        
        return Container(
          height: navHeight,
          margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: GlassContainer(
            type: GlassType.navigation,
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 4.0 : 6.0,
              vertical: isSmallScreen ? 6.0 : 8.0,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _navItems.map((item) {
                final isActive = widget.activeTab == item.id;
                return Expanded(
                  child: _NavButton(
                    item: item,
                    isActive: isActive,
                    onTap: () => _handleTabTap(item.id),
                    colors: colors,
                    isSmallScreen: isSmallScreen,
                    isMediumScreen: isMediumScreen,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _NavButton extends StatefulWidget {
  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;
  final AppColors colors;
  final bool isSmallScreen;
  final bool isMediumScreen;

  const _NavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
    required this.colors,
    required this.isSmallScreen,
    required this.isMediumScreen,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconScaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    _iconScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    if (widget.isActive) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_NavButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizing
    final iconSize = widget.isSmallScreen ? 20.0 : widget.isMediumScreen ? 22.0 : 24.0;
    final fontSize = widget.isSmallScreen ? 10.0 : widget.isMediumScreen ? 11.0 : 12.0;
    final verticalPadding = widget.isSmallScreen ? 6.0 : widget.isMediumScreen ? 8.0 : 10.0;
    final horizontalPadding = widget.isSmallScreen ? 8.0 : widget.isMediumScreen ? 10.0 : 12.0;
    final borderRadius = widget.isSmallScreen ? 12.0 : widget.isMediumScreen ? 14.0 : 16.0;
    
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: widget.isSmallScreen ? 2.0 : 3.0,
              vertical: widget.isSmallScreen ? 4.0 : 6.0,
            ),
            child: Stack(
              children: [
                // Active background with enhanced design
                if (widget.isActive)
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: AppAnimations.medium,
                      curve: Curves.easeOutCubic,
                      decoration: BoxDecoration(
                        gradient: widget.colors.gradientPrimary,
                        borderRadius: BorderRadius.circular(borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: widget.colors.accent.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: widget.colors.accent.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // Content with better responsive design
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon with enhanced scale animation
                      Transform.scale(
                        scale: _iconScaleAnimation.value,
                        child: Icon(
                          widget.item.icon,
                          size: iconSize,
                          color: widget.isActive 
                              ? Colors.white 
                              : widget.colors.textSecondary,
                        ),
                      ),
                      
                      SizedBox(height: widget.isSmallScreen ? 1.0 : 2.0),
                      
                      // Label with responsive typography
                      AnimatedDefaultTextStyle(
                        duration: AppAnimations.medium,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
                          color: widget.isActive 
                              ? Colors.white 
                              : widget.colors.textSecondary,
                          letterSpacing: 0.1,
                          height: 1.0,
                        ),
                        child: Text(
                          widget.item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Enhanced ripple effect for active state
                if (widget.isActive)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.0,
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.05),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NavItem {
  final String id;
  final IconData icon;
  final String label;

  const NavItem({
    required this.id,
    required this.icon,
    required this.label,
  });
}

// Custom nav bar with enhanced animations
class PremiumBottomNavigation extends StatefulWidget {
  final String activeTab;
  final Function(String) onTabChanged;
  final List<NavItem> items;

  const PremiumBottomNavigation({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
    required this.items,
  });

  @override
  State<PremiumBottomNavigation> createState() => _PremiumBottomNavigationState();
}

class _PremiumBottomNavigationState extends State<PremiumBottomNavigation>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
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

    // Start animations
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_slideAnimation, _fadeAnimation]),
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: BottomNavigation(
              activeTab: widget.activeTab,
              onTabChanged: widget.onTabChanged,
            ),
          ),
        );
      },
    );
  }
}