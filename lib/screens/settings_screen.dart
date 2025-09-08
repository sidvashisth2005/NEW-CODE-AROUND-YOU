import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_container.dart';
import '../core/utils/logger.dart';
import 'dart:ui' as ui;

class SettingsScreen extends StatefulWidget {
  final Function(String, {bool isSubScreen, dynamic data}) onNavigate;
  final VoidCallback onLogout;

  const SettingsScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Settings state
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _hapticFeedbackEnabled = true;
  bool _soundsEnabled = true;
  bool _autoBackupEnabled = true;
  bool _offlineModeEnabled = false;
  String _dataUsage = 'wifi_only';
  String _language = 'english';
  String _mapStyle = 'standard';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    Logger.info('Settings screen initialized');
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
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

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    Logger.info('Settings screen disposed');
    super.dispose();
  }

  void _showLogoutDialog(ThemeProvider themeProvider, AppColors colors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.glassBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.premium),
        ),
        title: Text(
          'Sign Out',
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(
            color: colors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              themeProvider.hapticFeedback('success');
              widget.onLogout();
            },
            child: Text(
              'Sign Out',
              style: TextStyle(color: colors.error),
            ),
          ),
        ],
      ),
    );
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
        
        return Container(
          decoration: BoxDecoration(gradient: colors.background),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: AnimatedBuilder(
                animation: Listenable.merge([_slideController, _fadeController]),
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: CustomScrollView(
                        slivers: [
                          _buildHeader(colors, themeProvider, isSmallScreen, isMediumScreen),
                          _buildAccountSection(colors, themeProvider, isSmallScreen, isMediumScreen),
                          _buildAppearanceSection(colors, themeProvider, isSmallScreen, isMediumScreen),
                          _buildNotificationsSection(colors, themeProvider, isSmallScreen, isMediumScreen),
                          _buildPrivacySection(colors, themeProvider, isSmallScreen, isMediumScreen),
                          _buildGeneralSection(colors, themeProvider, isSmallScreen, isMediumScreen),
                          _buildAboutSection(colors, themeProvider, isSmallScreen, isMediumScreen),
                          _buildLogoutSection(colors, themeProvider, isSmallScreen, isMediumScreen),
                          const SliverToBoxAdapter(child: SizedBox(height: 100)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    final titleFontSize = isSmallScreen ? 20.0 : isMediumScreen ? 22.0 : 24.0;
    
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(horizontalPadding),
        child: Row(
          children: [
            // Back button
            GlassContainer(
              onTap: () {
                themeProvider.hapticFeedback('light');
                widget.onNavigate('profile');
              },
              padding: EdgeInsets.all(isSmallScreen ? 8.0 : 10.0),
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: Icon(
                Icons.arrow_back_rounded,
                color: colors.textPrimary,
                size: isSmallScreen ? 20.0 : 22.0,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Title
            Text(
              'Settings',
              style: TextStyle(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: titleFontSize,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    return _buildSection(
      'Account',
      [
        _buildTile(
          'Edit Profile',
          'Update your personal information',
          Icons.person_rounded,
          colors,
          themeProvider,
          isSmallScreen,
          onTap: () {
            themeProvider.hapticFeedback('light');
            // TODO: Navigate to edit profile
          },
        ),
        _buildTile(
          'Privacy & Safety',
          'Manage who can see your content',
          Icons.security_rounded,
          colors,
          themeProvider,
          isSmallScreen,
          onTap: () {
            themeProvider.hapticFeedback('light');
            // TODO: Navigate to privacy settings
          },
        ),
        _buildTile(
          'Blocked Users',
          'Manage blocked accounts',
          Icons.block_rounded,
          colors,
          themeProvider,
          isSmallScreen,
          onTap: () {
            themeProvider.hapticFeedback('light');
            // TODO: Navigate to blocked users
          },
        ),
      ],
      colors,
      isSmallScreen,
      isMediumScreen,
    );
  }

  Widget _buildAppearanceSection(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    return _buildSection(
      'Appearance',
      [
        _buildSwitchTile(
          'Dark Mode',
          'Switch between light and dark themes',
          Icons.dark_mode_rounded,
          themeProvider.isDarkMode,
          (value) {
            themeProvider.hapticFeedback('light');
            themeProvider.toggleTheme();
          },
          colors,
          isSmallScreen,
        ),
        _buildDropdownTile(
          'Map Style',
          'Choose your preferred map appearance',
          Icons.map_rounded,
          _mapStyle,
          [
            {'value': 'standard', 'label': 'Standard'},
            {'value': 'satellite', 'label': 'Satellite'},
            {'value': 'terrain', 'label': 'Terrain'},
          ],
          (value) {
            setState(() => _mapStyle = value);
            themeProvider.hapticFeedback('light');
          },
          colors,
          themeProvider,
          isSmallScreen,
        ),
      ],
      colors,
      isSmallScreen,
      isMediumScreen,
    );
  }

  Widget _buildNotificationsSection(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    return _buildSection(
      'Notifications',
      [
        _buildSwitchTile(
          'Push Notifications',
          'Receive notifications about new memories',
          Icons.notifications_rounded,
          _notificationsEnabled,
          (value) {
            setState(() => _notificationsEnabled = value);
            themeProvider.hapticFeedback('light');
          },
          colors,
          isSmallScreen,
        ),
        _buildTile(
          'Notification Preferences',
          'Customize what notifications you receive',
          Icons.tune_rounded,
          colors,
          themeProvider,
          isSmallScreen,
          onTap: () {
            themeProvider.hapticFeedback('light');
            widget.onNavigate('notifications', isSubScreen: true);
          },
        ),
      ],
      colors,
      isSmallScreen,
      isMediumScreen,
    );
  }

  Widget _buildPrivacySection(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    return _buildSection(
      'Privacy & Data',
      [
        _buildSwitchTile(
          'Location Services',
          'Allow location access for better experiences',
          Icons.location_on_rounded,
          _locationEnabled,
          (value) {
            setState(() => _locationEnabled = value);
            themeProvider.hapticFeedback('light');
          },
          colors,
          isSmallScreen,
        ),
        _buildSwitchTile(
          'Auto Backup',
          'Automatically backup your memories',
          Icons.backup_rounded,
          _autoBackupEnabled,
          (value) {
            setState(() => _autoBackupEnabled = value);
            themeProvider.hapticFeedback('light');
          },
          colors,
          isSmallScreen,
        ),
        _buildDropdownTile(
          'Data Usage',
          'Control when to download content',
          Icons.data_usage_rounded,
          _dataUsage,
          [
            {'value': 'always', 'label': 'Always'},
            {'value': 'wifi_only', 'label': 'Wi-Fi Only'},
            {'value': 'never', 'label': 'Never'},
          ],
          (value) {
            setState(() => _dataUsage = value);
            themeProvider.hapticFeedback('light');
          },
          colors,
          themeProvider,
          isSmallScreen,
        ),
        _buildSwitchTile(
          'Offline Mode',
          'Download content for offline viewing',
          Icons.offline_bolt_rounded,
          _offlineModeEnabled,
          (value) {
            setState(() => _offlineModeEnabled = value);
            themeProvider.hapticFeedback('light');
          },
          colors,
          isSmallScreen,
        ),
      ],
      colors,
      isSmallScreen,
      isMediumScreen,
    );
  }

  Widget _buildGeneralSection(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    return _buildSection(
      'General',
      [
        _buildSwitchTile(
          'Haptic Feedback',
          'Feel vibrations when interacting',
          Icons.vibration_rounded,
          _hapticFeedbackEnabled,
          (value) {
            setState(() => _hapticFeedbackEnabled = value);
            themeProvider.hapticFeedback('light');
          },
          colors,
          isSmallScreen,
        ),
        _buildSwitchTile(
          'Sounds',
          'Play sounds for interactions',
          Icons.volume_up_rounded,
          _soundsEnabled,
          (value) {
            setState(() => _soundsEnabled = value);
            themeProvider.hapticFeedback('light');
          },
          colors,
          isSmallScreen,
        ),
        _buildDropdownTile(
          'Language',
          'Choose your preferred language',
          Icons.language_rounded,
          _language,
          [
            {'value': 'english', 'label': 'English'},
            {'value': 'spanish', 'label': 'Español'},
            {'value': 'french', 'label': 'Français'},
            {'value': 'german', 'label': 'Deutsch'},
            {'value': 'japanese', 'label': '日本語'},
          ],
          (value) {
            setState(() => _language = value);
            themeProvider.hapticFeedback('light');
          },
          colors,
          themeProvider,
          isSmallScreen,
        ),
        _buildTile(
          'Storage',
          'Manage app storage and cache',
          Icons.storage_rounded,
          colors,
          themeProvider,
          isSmallScreen,
          onTap: () {
            themeProvider.hapticFeedback('light');
            // TODO: Navigate to storage settings
          },
        ),
      ],
      colors,
      isSmallScreen,
      isMediumScreen,
    );
  }

  Widget _buildAboutSection(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    return _buildSection(
      'About',
      [
        _buildTile(
          'Help & Support',
          'Get help and contact support',
          Icons.help_rounded,
          colors,
          themeProvider,
          isSmallScreen,
          onTap: () {
            themeProvider.hapticFeedback('light');
            // TODO: Navigate to help
          },
        ),
        _buildTile(
          'Terms of Service',
          'Read our terms and conditions',
          Icons.description_rounded,
          colors,
          themeProvider,
          isSmallScreen,
          onTap: () {
            themeProvider.hapticFeedback('light');
            // TODO: Navigate to terms
          },
        ),
        _buildTile(
          'Privacy Policy',
          'Learn about our privacy practices',
          Icons.privacy_tip_rounded,
          colors,
          themeProvider,
          isSmallScreen,
          onTap: () {
            themeProvider.hapticFeedback('light');
            // TODO: Navigate to privacy policy
          },
        ),
        _buildTile(
          'About Around You',
          'Version 1.0.0 (Build 123)',
          Icons.info_rounded,
          colors,
          themeProvider,
          isSmallScreen,
          onTap: () {
            themeProvider.hapticFeedback('light');
            // TODO: Show app info
          },
        ),
      ],
      colors,
      isSmallScreen,
      isMediumScreen,
    );
  }

  Widget _buildLogoutSection(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        child: GlassContainer(
          onTap: () => _showLogoutDialog(themeProvider, colors),
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
          borderRadius: BorderRadius.circular(AppRadius.premium),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8.0 : 10.0),
                decoration: BoxDecoration(
                  color: colors.error.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: colors.error,
                  size: isSmallScreen ? 20.0 : 24.0,
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 15.0 : 16.0,
                        fontWeight: FontWeight.w600,
                        color: colors.error,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sign out of your account',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12.0 : 13.0,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              Icon(
                Icons.chevron_right_rounded,
                color: colors.textSecondary,
                size: isSmallScreen ? 20.0 : 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children, AppColors colors, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    final titleFontSize = isSmallScreen ? 16.0 : isMediumScreen ? 17.0 : 18.0;
    
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12, top: 16),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            GlassContainer(
              padding: const EdgeInsets.all(4),
              borderRadius: BorderRadius.circular(AppRadius.premium),
              child: Column(
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String title, String subtitle, IconData icon, AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 8.0 : 10.0),
              decoration: BoxDecoration(
                gradient: colors.gradientPrimary,
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: isSmallScreen ? 18.0 : 20.0,
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14.0 : 15.0,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11.0 : 12.0,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                color: colors.textSecondary,
                size: isSmallScreen ? 20.0 : 24.0,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged, AppColors colors, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8.0 : 10.0),
            decoration: BoxDecoration(
              gradient: colors.gradientPrimary,
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: isSmallScreen ? 18.0 : 20.0,
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14.0 : 15.0,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11.0 : 12.0,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: colors.accent,
            activeTrackColor: colors.accent.withOpacity(0.3),
            inactiveThumbColor: colors.textSecondary,
            inactiveTrackColor: colors.glassBorder,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile(String title, String subtitle, IconData icon, String value, List<Map<String, String>> options, ValueChanged<String> onChanged, AppColors colors, ThemeProvider themeProvider, bool isSmallScreen) {
    return GestureDetector(
      onTap: () {
        _showOptionsModal(title, options, value, onChanged, colors, themeProvider);
      },
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 8.0 : 10.0),
              decoration: BoxDecoration(
                gradient: colors.gradientPrimary,
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: isSmallScreen ? 18.0 : 20.0,
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14.0 : 15.0,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11.0 : 12.0,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            Text(
              options.firstWhere((option) => option['value'] == value)['label']!,
              style: TextStyle(
                fontSize: isSmallScreen ? 12.0 : 13.0,
                fontWeight: FontWeight.w500,
                color: colors.accent,
              ),
            ),
            
            const SizedBox(width: 8),
            
            Icon(
              Icons.chevron_right_rounded,
              color: colors.textSecondary,
              size: isSmallScreen ? 20.0 : 24.0,
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsModal(String title, List<Map<String, String>> options, String currentValue, ValueChanged<String> onChanged, AppColors colors, ThemeProvider themeProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            gradient: colors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.close_rounded,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              ...options.map((option) {
                final isSelected = option['value'] == currentValue;
                return GestureDetector(
                  onTap: () {
                    onChanged(option['value']!);
                    themeProvider.hapticFeedback('light');
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Text(
                          option['label']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? colors.accent : colors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Icon(
                            Icons.check_rounded,
                            color: colors.accent,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              
              SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
            ],
          ),
        );
      },
    );
  }
}