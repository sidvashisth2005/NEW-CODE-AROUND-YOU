import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_container.dart';
import '../widgets/logo.dart';
import '../models/trail_model.dart';
import '../core/utils/logger.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class TrailsScreen extends StatefulWidget {
  final Function(String, {bool isSubScreen, dynamic data}) onNavigate;

  const TrailsScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<TrailsScreen> createState() => _TrailsScreenState();
}

class _TrailsScreenState extends State<TrailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _staggerController;
  late AnimationController _pulseController;
  
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  String _selectedCategory = 'popular';
  String _selectedDifficulty = 'all';
  
  final List<Trail> _allTrails = [
    Trail(
      id: '1',
      name: 'Heritage Art Walk',
      description: 'Discover street art and murals in the historic district',
      difficulty: 'Easy',
      estimatedTime: '2 hours',
      distance: 3.2,
      memoryCount: 15,
      creatorName: 'Sarah Chen',
      creatorAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b691?w=100',
      imageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=400',
      category: 'art',
      rating: 4.8,
      completedCount: 234,
      isBookmarked: true,
      waypoints: [
        TrailWaypoint(
          id: '1',
          title: 'Central Plaza Mural',
          description: 'Vibrant community artwork',
          location: LatLng(37.7749, -122.4194),
          memoryId: 'mem1',
        ),
        TrailWaypoint(
          id: '2',
          title: 'Heritage Wall',
          description: 'Historical timeline in art',
          location: LatLng(37.7751, -122.4196),
          memoryId: 'mem2',
        ),
      ],
    ),
    Trail(
      id: '2',
      name: 'Sunset Wellness Journey',
      description: 'Mindful spots for meditation and reflection',
      difficulty: 'Medium',
      estimatedTime: '3 hours',
      distance: 5.7,
      memoryCount: 8,
      creatorName: 'Emma Wilson',
      creatorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
      category: 'wellness',
      rating: 4.9,
      completedCount: 156,
      isBookmarked: false,
      waypoints: [],
    ),
    Trail(
      id: '3',
      name: 'Foodie Adventure',
      description: 'Hidden culinary gems and local favorites',
      difficulty: 'Easy',
      estimatedTime: '4 hours',
      distance: 2.8,
      memoryCount: 12,
      creatorName: 'Alex Rivera',
      creatorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
      imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400',
      category: 'food',
      rating: 4.7,
      completedCount: 89,
      isBookmarked: true,
      waypoints: [],
    ),
    Trail(
      id: '4',
      name: 'Urban Photography Quest',
      description: 'Capture the city\'s most photogenic spots',
      difficulty: 'Hard',
      estimatedTime: '5 hours',
      distance: 8.5,
      memoryCount: 20,
      creatorName: 'Mike Johnson',
      creatorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      imageUrl: 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400',
      category: 'photography',
      rating: 4.6,
      completedCount: 67,
      isBookmarked: false,
      waypoints: [],
    ),
  ];

  List<Trail> get _filteredTrails {
    var trails = _allTrails;
    
    // Filter by difficulty
    if (_selectedDifficulty != 'all') {
      trails = trails.where((trail) => 
        trail.difficulty.toLowerCase() == _selectedDifficulty.toLowerCase()
      ).toList();
    }
    
    // Sort by category
    switch (_selectedCategory) {
      case 'popular':
        trails.sort((a, b) => b.completedCount.compareTo(a.completedCount));
        break;
      case 'recent':
        // For demo, just reverse the list
        trails = trails.reversed.toList();
        break;
      case 'nearby':
        // For demo, sort by distance
        trails.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case 'bookmarked':
        trails = trails.where((trail) => trail.isBookmarked).toList();
        break;
    }
    
    return trails;
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    Logger.info('Trails screen initialized');
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
    
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
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

    _slideController.forward();
    _fadeController.forward();
    _staggerController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _staggerController.dispose();
    _pulseController.dispose();
    Logger.info('Trails screen disposed');
    super.dispose();
  }

  void _handleTrailTap(Trail trail) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('light');
    themeProvider.playSound('tap');
    widget.onNavigate('trail-detail', isSubScreen: true, data: trail);
  }

  void _toggleBookmark(Trail trail) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('light');
    setState(() {
      trail.isBookmarked = !trail.isBookmarked;
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
                      child: Column(
                        children: [
                          _buildHeader(colors, themeProvider, isSmallScreen, isMediumScreen),
                          _buildFilterTabs(colors, themeProvider, isSmallScreen, isMediumScreen),
                          _buildDifficultyFilter(colors, themeProvider, isSmallScreen, isMediumScreen),
                          Expanded(
                            child: _buildTrailsList(colors, themeProvider, isSmallScreen, isMediumScreen),
                          ),
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
    final iconSize = isSmallScreen ? 20.0 : isMediumScreen ? 22.0 : 24.0;
    final titleFontSize = isSmallScreen ? 20.0 : isMediumScreen ? 22.0 : 24.0;
    final subtitleFontSize = isSmallScreen ? 12.0 : isMediumScreen ? 13.0 : 14.0;
    
    return Container(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 16),
      child: Row(
        children: [
          // Logo and title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const LogoIcon(size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'Trails',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: titleFontSize,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${_filteredTrails.length} adventures nearby',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Search button
          GlassContainer(
            onTap: () {
              themeProvider.hapticFeedback('light');
              // TODO: Implement search functionality
            },
            padding: EdgeInsets.all(isSmallScreen ? 8.0 : 10.0),
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Icon(
              Icons.search_rounded,
              color: colors.textPrimary,
              size: iconSize,
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Map view button
          GlassContainer(
            onTap: () {
              themeProvider.hapticFeedback('light');
              // TODO: Implement map view
            },
            padding: EdgeInsets.all(isSmallScreen ? 8.0 : 10.0),
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Icon(
              Icons.map_rounded,
              color: colors.textPrimary,
              size: iconSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    final tabHeight = isSmallScreen ? 36.0 : isMediumScreen ? 40.0 : 44.0;
    final fontSize = isSmallScreen ? 12.0 : isMediumScreen ? 13.0 : 14.0;
    
    final categories = [
      {'id': 'popular', 'label': 'Popular', 'icon': Icons.trending_up_rounded},
      {'id': 'recent', 'label': 'Recent', 'icon': Icons.access_time_rounded},
      {'id': 'nearby', 'label': 'Nearby', 'icon': Icons.near_me_rounded},
      {'id': 'bookmarked', 'label': 'Saved', 'icon': Icons.bookmark_rounded},
    ];
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SizedBox(
        height: tabHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (context, index) => SizedBox(width: isSmallScreen ? 8.0 : 12.0),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isActive = _selectedCategory == category['id'];
            
            return GestureDetector(
              onTap: () {
                themeProvider.hapticFeedback('light');
                themeProvider.playSound('tap');
                setState(() => _selectedCategory = category['id'] as String);
              },
              child: AnimatedContainer(
                duration: AppAnimations.medium,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12.0 : 16.0,
                  vertical: isSmallScreen ? 8.0 : 10.0,
                ),
                decoration: BoxDecoration(
                  gradient: isActive ? colors.gradientPrimary : null,
                  color: isActive ? null : colors.glassBg,
                  borderRadius: BorderRadius.circular(AppRadius.large),
                  border: Border.all(
                    color: isActive ? Colors.transparent : colors.glassBorder,
                    width: 1.5,
                  ),
                  boxShadow: isActive ? colors.shadowPurple : colors.shadowSm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      size: isSmallScreen ? 16.0 : 18.0,
                      color: isActive ? Colors.white : colors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category['label'] as String,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.white : colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDifficultyFilter(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    final fontSize = isSmallScreen ? 12.0 : isMediumScreen ? 13.0 : 14.0;
    
    final difficulties = ['all', 'easy', 'medium', 'hard'];
    
    return Container(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 0),
      child: Row(
        children: [
          Icon(
            Icons.terrain_rounded,
            size: isSmallScreen ? 16.0 : 18.0,
            color: colors.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            'Difficulty:',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: difficulties.map((difficulty) {
                  final isActive = _selectedDifficulty == difficulty;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        themeProvider.hapticFeedback('light');
                        setState(() => _selectedDifficulty = difficulty);
                      },
                      child: AnimatedContainer(
                        duration: AppAnimations.medium,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 10.0 : 12.0,
                          vertical: isSmallScreen ? 4.0 : 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? colors.accent : colors.glassBg,
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          border: Border.all(
                            color: isActive ? Colors.transparent : colors.glassBorder,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          difficulty.toUpperCase(),
                          style: TextStyle(
                            fontSize: fontSize * 0.85,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.white : colors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailsList(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 100),
      itemCount: _filteredTrails.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _staggerController,
          builder: (context, child) {
            final delay = index * 0.1;
            final animValue = Curves.easeOutCubic.transform(
              math.max(0, (_staggerController.value - delay) / (1 - delay)),
            );
            
            return Transform.translate(
              offset: Offset(0, 30 * (1 - animValue)),
              child: Opacity(
                opacity: animValue,
                child: _buildTrailCard(_filteredTrails[index], colors, themeProvider, isSmallScreen, isMediumScreen),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTrailCard(Trail trail, AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final cardPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    final imageHeight = isSmallScreen ? 180.0 : isMediumScreen ? 200.0 : 220.0;
    final titleFontSize = isSmallScreen ? 18.0 : isMediumScreen ? 20.0 : 22.0;
    final bodyFontSize = isSmallScreen ? 13.0 : isMediumScreen ? 14.0 : 15.0;
    final metaFontSize = isSmallScreen ? 11.0 : isMediumScreen ? 12.0 : 13.0;
    
    return GlassContainer(
      onTap: () => _handleTrailTap(trail),
      padding: EdgeInsets.all(cardPadding),
      borderRadius: BorderRadius.circular(AppRadius.premium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trail image with overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                child: Image.network(
                  trail.imageUrl,
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: imageHeight,
                      color: colors.glassBg,
                      child: Icon(
                        Icons.route_rounded,
                        color: colors.textSecondary,
                        size: 64,
                      ),
                    );
                  },
                ),
              ),
              
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Difficulty badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8.0 : 10.0,
                    vertical: isSmallScreen ? 4.0 : 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(trail.difficulty),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    boxShadow: colors.shadowSm,
                  ),
                  child: Text(
                    trail.difficulty.toUpperCase(),
                    style: TextStyle(
                      fontSize: metaFontSize,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              
              // Bookmark button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => _toggleBookmark(trail),
                  child: Container(
                    padding: EdgeInsets.all(isSmallScreen ? 6.0 : 8.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      trail.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: trail.isBookmarked ? colors.accent : Colors.white,
                      size: isSmallScreen ? 18.0 : 20.0,
                    ),
                  ),
                ),
              ),
              
              // Stats overlay
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    _buildStatChip(
                      Icons.schedule_rounded,
                      trail.estimatedTime,
                      colors,
                      isSmallScreen,
                    ),
                    const SizedBox(width: 8),
                    _buildStatChip(
                      Icons.straighten_rounded,
                      '${trail.distance}km',
                      colors,
                      isSmallScreen,
                    ),
                    const SizedBox(width: 8),
                    _buildStatChip(
                      Icons.photo_camera_rounded,
                      '${trail.memoryCount}',
                      colors,
                      isSmallScreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Trail details
          Text(
            trail.name,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            trail.description,
            style: TextStyle(
              fontSize: bodyFontSize,
              fontWeight: FontWeight.w400,
              color: colors.textSecondary,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 16),
          
          // Creator and rating
          Row(
            children: [
              CircleAvatar(
                radius: isSmallScreen ? 12.0 : 14.0,
                backgroundImage: NetworkImage(trail.creatorAvatar),
              ),
              const SizedBox(width: 8),
              Text(
                trail.creatorName,
                style: TextStyle(
                  fontSize: metaFontSize,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.star_rounded,
                size: isSmallScreen ? 14.0 : 16.0,
                color: Colors.amber,
              ),
              const SizedBox(width: 4),
              Text(
                '${trail.rating}',
                style: TextStyle(
                  fontSize: metaFontSize,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${trail.completedCount})',
                style: TextStyle(
                  fontSize: metaFontSize,
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, AppColors colors, bool isSmallScreen) {
    final fontSize = isSmallScreen ? 10.0 : 11.0;
    final padding = isSmallScreen ? 6.0 : 8.0;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isSmallScreen ? 12.0 : 14.0,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}