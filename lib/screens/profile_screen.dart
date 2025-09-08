import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_container.dart';
import '../widgets/logo.dart';
import '../models/memory_model.dart';
import '../models/streak_provider.dart';
import '../core/utils/logger.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class ProfileScreen extends StatefulWidget {
  final Function(String, {bool isSubScreen, dynamic data}) onNavigate;

  const ProfileScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  String _selectedTab = 'memories';
  
  final UserProfile _userProfile = UserProfile(
    id: 'current-user',
    name: 'Sarah Chen',
    username: '@sarahc_explorer',
    bio: 'Urban explorer & photography enthusiast. Capturing moments that matter ✨',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b691?w=200',
    joinDate: DateTime(2023, 6, 15),
    memoriesCount: 47,
    trailsCount: 8,
    followersCount: 234,
    followingCount: 189,
    totalLikes: 1247,
    level: 12,
    experiencePoints: 8450,
    nextLevelXP: 10000,
    badges: [
      'Art Explorer',
      'Trail Blazer',
      'Memory Master',
      'Social Butterfly',
    ],
    streakDays: 15,
    isVerified: true,
  );

  final List<Memory> _userMemories = [
    Memory(
      id: 'user1',
      title: 'Morning Coffee Ritual',
      description: 'Perfect latte art at my favorite spot',
      imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=400',
      category: 'food',
      location: 'Central Perk Cafe',
      distance: 0,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      authorName: 'Sarah Chen',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b691?w=100',
      likes: 34,
      isLiked: false,
    ),
    Memory(
      id: 'user2',
      title: 'Street Art Discovery',
      description: 'Found this amazing mural in the old district',
      imageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=400',
      category: 'art',
      location: 'Heritage Quarter',
      distance: 0,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      authorName: 'Sarah Chen',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b691?w=100',
      likes: 67,
      isLiked: false,
    ),
    Memory(
      id: 'user3',
      title: 'Sunset Meditation',
      description: 'Perfect end to a busy day',
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
      category: 'wellness',
      location: 'Riverside Park',
      distance: 0,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      authorName: 'Sarah Chen',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b691?w=100',
      likes: 89,
      isLiked: false,
    ),
  ];

  final List<Achievement> _achievements = [
    Achievement(
      id: '1',
      title: 'First Memory',
      description: 'Created your first memory',
      icon: Icons.photo_camera_rounded,
      earnedDate: DateTime.now().subtract(const Duration(days: 120)),
      rarity: 'Common',
    ),
    Achievement(
      id: '2',
      title: 'Art Enthusiast',
      description: 'Created 10 art memories',
      icon: Icons.palette_rounded,
      earnedDate: DateTime.now().subtract(const Duration(days: 45)),
      rarity: 'Rare',
    ),
    Achievement(
      id: '3',
      title: 'Trail Master',
      description: 'Completed 5 trails',
      icon: Icons.route_rounded,
      earnedDate: DateTime.now().subtract(const Duration(days: 15)),
      rarity: 'Epic',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    Logger.info('Profile screen initialized');
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
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
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

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.linear,
    ));

    _slideController.forward();
    _fadeController.forward();
    _pulseController.repeat(reverse: true);
    _rotateController.repeat();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    Logger.info('Profile screen disposed');
    super.dispose();
  }

  void _handleMemoryTap(Memory memory) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('light');
    themeProvider.playSound('tap');
    widget.onNavigate('memory-detail', isSubScreen: true, data: memory);
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
                          _buildProfileHeader(colors, themeProvider, isSmallScreen, isMediumScreen),
                          _buildStatsSection(colors, themeProvider, isSmallScreen, isMediumScreen),
                          _buildTabSection(colors, themeProvider, isSmallScreen, isMediumScreen),
                          _buildContentSection(colors, themeProvider, isSmallScreen, isMediumScreen),
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

  Widget _buildProfileHeader(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    final avatarSize = isSmallScreen ? 80.0 : isMediumScreen ? 90.0 : 100.0;
    final titleFontSize = isSmallScreen ? 18.0 : isMediumScreen ? 20.0 : 22.0;
    final bodyFontSize = isSmallScreen ? 13.0 : isMediumScreen ? 14.0 : 15.0;
    final metaFontSize = isSmallScreen ? 11.0 : isMediumScreen ? 12.0 : 13.0;
    
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          children: [
            // Header with settings
            Row(
              children: [
                const LogoIcon(size: 28),
                const SizedBox(width: 12),
                Text(
                  'Profile',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: titleFontSize,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                GlassContainer(
                  onTap: () {
                    themeProvider.hapticFeedback('light');
                    widget.onNavigate('settings', isSubScreen: true);
                  },
                  padding: EdgeInsets.all(isSmallScreen ? 8.0 : 10.0),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  child: Icon(
                    Icons.settings_rounded,
                    color: colors.textPrimary,
                    size: isSmallScreen ? 20.0 : 22.0,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Profile avatar and info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with level indicator
                Stack(
                  children: [
                    // Animated border
                    AnimatedBuilder(
                      animation: _rotateAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotateAnimation.value * 2 * math.pi,
                          child: Container(
                            width: avatarSize + 8,
                            height: avatarSize + 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  colors.accent,
                                  colors.accentSecondary,
                                  colors.accent,
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    // Avatar
                    Positioned(
                      left: 4,
                      top: 4,
                      child: CircleAvatar(
                        radius: avatarSize / 2,
                        backgroundColor: colors.glassBg,
                        backgroundImage: NetworkImage(_userProfile.avatarUrl),
                      ),
                    ),
                    
                    // Verified badge
                    if (_userProfile.isVerified)
                      Positioned(
                        right: 0,
                        bottom: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colors.accent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colors.glassBg,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.verified_rounded,
                            color: Colors.white,
                            size: isSmallScreen ? 12.0 : 14.0,
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(width: 20),
                
                // Profile info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userProfile.name,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Text(
                        _userProfile.username,
                        style: TextStyle(
                          fontSize: metaFontSize,
                          fontWeight: FontWeight.w500,
                          color: colors.accent,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Level and XP
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 8.0 : 10.0,
                          vertical: isSmallScreen ? 4.0 : 6.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: colors.gradientGold,
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          boxShadow: colors.shadowGold,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.military_tech_rounded,
                              size: isSmallScreen ? 14.0 : 16.0,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Level ${_userProfile.level}',
                              style: TextStyle(
                                fontSize: metaFontSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // XP Progress
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_userProfile.experiencePoints} / ${_userProfile.nextLevelXP} XP',
                            style: TextStyle(
                              fontSize: metaFontSize,
                              fontWeight: FontWeight.w500,
                              color: colors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: _userProfile.experiencePoints / _userProfile.nextLevelXP,
                            backgroundColor: colors.glassBorder,
                            valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
                            minHeight: 6,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Bio
            Text(
              _userProfile.bio,
              style: TextStyle(
                fontSize: bodyFontSize,
                fontWeight: FontWeight.w400,
                color: colors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    final statFontSize = isSmallScreen ? 16.0 : isMediumScreen ? 18.0 : 20.0;
    final labelFontSize = isSmallScreen ? 11.0 : isMediumScreen ? 12.0 : 13.0;
    
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        child: GlassContainer(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
          borderRadius: BorderRadius.circular(AppRadius.premium),
          child: Column(
            children: [
              // Main stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn(
                    '${_userProfile.memoriesCount}',
                    'Memories',
                    colors,
                    statFontSize,
                    labelFontSize,
                  ),
                  _buildStatColumn(
                    '${_userProfile.trailsCount}',
                    'Trails',
                    colors,
                    statFontSize,
                    labelFontSize,
                  ),
                  _buildStatColumn(
                    '${_userProfile.followersCount}',
                    'Followers',
                    colors,
                    statFontSize,
                    labelFontSize,
                  ),
                  _buildStatColumn(
                    '${_userProfile.followingCount}',
                    'Following',
                    colors,
                    statFontSize,
                    labelFontSize,
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Streak and badges
              Row(
                children: [
                  Expanded(
                    child: Consumer<StreakProvider>(
                      builder: (context, streakProvider, child) {
                        return GlassContainer(
                          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          child: Row(
                            children: [
                              AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: Icon(
                                      Icons.local_fire_department_rounded,
                                      color: Colors.orange,
                                      size: isSmallScreen ? 20.0 : 24.0,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_userProfile.streakDays} days',
                                    style: TextStyle(
                                      fontSize: statFontSize * 0.8,
                                      fontWeight: FontWeight.w700,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'Streak',
                                    style: TextStyle(
                                      fontSize: labelFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: GlassContainer(
                      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      child: Row(
                        children: [
                          Icon(
                            Icons.workspace_premium_rounded,
                            color: colors.accent,
                            size: isSmallScreen ? 20.0 : 24.0,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_userProfile.badges.length}',
                                style: TextStyle(
                                  fontSize: statFontSize * 0.8,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                ),
                              ),
                              Text(
                                'Badges',
                                style: TextStyle(
                                  fontSize: labelFontSize,
                                  fontWeight: FontWeight.w500,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, AppColors colors, double valueFontSize, double labelFontSize) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: valueFontSize,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTabSection(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    final tabHeight = isSmallScreen ? 44.0 : isMediumScreen ? 48.0 : 52.0;
    final fontSize = isSmallScreen ? 14.0 : isMediumScreen ? 15.0 : 16.0;
    
    final tabs = [
      {'id': 'memories', 'label': 'Memories', 'icon': Icons.photo_camera_rounded},
      {'id': 'achievements', 'label': 'Achievements', 'icon': Icons.emoji_events_rounded},
    ];
    
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        child: GlassContainer(
          padding: const EdgeInsets.all(4),
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: Row(
            children: tabs.map((tab) {
              final isActive = _selectedTab == tab['id'];
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    themeProvider.hapticFeedback('light');
                    themeProvider.playSound('tap');
                    setState(() => _selectedTab = tab['id'] as String);
                  },
                  child: AnimatedContainer(
                    duration: AppAnimations.medium,
                    height: tabHeight,
                    decoration: BoxDecoration(
                      gradient: isActive ? colors.gradientPrimary : null,
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      boxShadow: isActive ? colors.shadowPurple : null,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            tab['icon'] as IconData,
                            size: isSmallScreen ? 18.0 : 20.0,
                            color: isActive ? Colors.white : colors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            tab['label'] as String,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                              color: isActive ? Colors.white : colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    return _selectedTab == 'memories' 
        ? _buildMemoriesGrid(colors, themeProvider, isSmallScreen, isMediumScreen)
        : _buildAchievementsList(colors, themeProvider, isSmallScreen, isMediumScreen);
  }

  Widget _buildMemoriesGrid(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    final crossAxisCount = isSmallScreen ? 2 : 3;
    final childAspectRatio = isSmallScreen ? 0.8 : 0.85;
    
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 100),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final memory = _userMemories[index];
            return _buildMemoryGridItem(memory, colors, themeProvider, isSmallScreen, isMediumScreen);
          },
          childCount: _userMemories.length,
        ),
      ),
    );
  }

  Widget _buildMemoryGridItem(Memory memory, AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final titleFontSize = isSmallScreen ? 12.0 : isMediumScreen ? 13.0 : 14.0;
    final metaFontSize = isSmallScreen ? 10.0 : isMediumScreen ? 11.0 : 12.0;
    
    return GlassContainer(
      onTap: () => _handleMemoryTap(memory),
      padding: EdgeInsets.all(isSmallScreen ? 8.0 : 10.0),
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Memory image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.small),
              child: Image.network(
                memory.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    color: colors.glassBg,
                    child: Icon(
                      Icons.photo_rounded,
                      color: colors.textSecondary,
                      size: 32,
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Memory title
          Text(
            memory.title,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 4),
          
          // Likes and category
          Row(
            children: [
              Icon(
                Icons.favorite_rounded,
                size: isSmallScreen ? 12.0 : 14.0,
                color: Colors.red.shade400,
              ),
              const SizedBox(width: 4),
              Text(
                '${memory.likes}',
                style: TextStyle(
                  fontSize: metaFontSize,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  memory.category.toUpperCase(),
                  style: TextStyle(
                    fontSize: metaFontSize * 0.8,
                    fontWeight: FontWeight.w600,
                    color: colors.accent,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsList(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final achievement = _achievements[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildAchievementCard(achievement, colors, themeProvider, isSmallScreen, isMediumScreen),
            );
          },
          childCount: _achievements.length,
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement, AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final titleFontSize = isSmallScreen ? 16.0 : isMediumScreen ? 17.0 : 18.0;
    final bodyFontSize = isSmallScreen ? 13.0 : isMediumScreen ? 14.0 : 15.0;
    final metaFontSize = isSmallScreen ? 11.0 : isMediumScreen ? 12.0 : 13.0;
    final iconSize = isSmallScreen ? 40.0 : isMediumScreen ? 44.0 : 48.0;
    
    return GlassContainer(
      padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
      borderRadius: BorderRadius.circular(AppRadius.premium),
      child: Row(
        children: [
          // Achievement icon
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              gradient: _getRarityGradient(achievement.rarity, colors),
              shape: BoxShape.circle,
              boxShadow: colors.shadowMd,
            ),
            child: Icon(
              achievement.icon,
              color: Colors.white,
              size: iconSize * 0.5,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Achievement details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        achievement.title,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRarityColor(achievement.rarity),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        achievement.rarity,
                        style: TextStyle(
                          fontSize: metaFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 6),
                
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: bodyFontSize,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                    height: 1.3,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Earned ${_formatDate(achievement.earnedDate)}',
                  style: TextStyle(
                    fontSize: metaFontSize,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getRarityGradient(String rarity, AppColors colors) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return LinearGradient(colors: [Colors.grey.shade600, Colors.grey.shade800]);
      case 'rare':
        return LinearGradient(colors: [Colors.blue.shade500, Colors.blue.shade700]);
      case 'epic':
        return LinearGradient(colors: [Colors.purple.shade500, Colors.purple.shade700]);
      case 'legendary':
        return LinearGradient(colors: [Colors.orange.shade500, Colors.red.shade600]);
      default:
        return colors.gradientPrimary;
    }
  }

  Color _getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return Colors.grey.shade600;
      case 'rare':
        return Colors.blue.shade600;
      case 'epic':
        return Colors.purple.shade600;
      case 'legendary':
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }
}

class UserProfile {
  final String id;
  final String name;
  final String username;
  final String bio;
  final String avatarUrl;
  final DateTime joinDate;
  final int memoriesCount;
  final int trailsCount;
  final int followersCount;
  final int followingCount;
  final int totalLikes;
  final int level;
  final int experiencePoints;
  final int nextLevelXP;
  final List<String> badges;
  final int streakDays;
  final bool isVerified;

  UserProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.bio,
    required this.avatarUrl,
    required this.joinDate,
    required this.memoriesCount,
    required this.trailsCount,
    required this.followersCount,
    required this.followingCount,
    required this.totalLikes,
    required this.level,
    required this.experiencePoints,
    required this.nextLevelXP,
    required this.badges,
    required this.streakDays,
    required this.isVerified,
  });
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final DateTime earnedDate;
  final String rarity;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.earnedDate,
    required this.rarity,
  });
}