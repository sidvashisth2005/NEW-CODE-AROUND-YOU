import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_container.dart';
import '../widgets/logo.dart';
import '../models/memory_model.dart';
import '../core/utils/logger.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class AroundScreen extends StatefulWidget {
  final Function(String, {bool isSubScreen, dynamic data}) onNavigate;

  const AroundScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<AroundScreen> createState() => _AroundScreenState();
}

class _AroundScreenState extends State<AroundScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  String _selectedFilter = 'all';
  double _radiusFilter = 1000; // meters
  bool _isMapView = true;
  
  final List<Memory> _nearbyMemories = [
    Memory(
      id: '1',
      title: 'Coffee Date',
      description: 'Amazing latte art at this local cafe',
      imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=400',
      category: 'food',
      location: 'Central Perk Cafe',
      distance: 150,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      authorName: 'Sarah Chen',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b691?w=100',
      likes: 24,
      isLiked: false,
    ),
    Memory(
      id: '2',
      title: 'Street Art Discovery',
      description: 'Found this incredible mural tucked away in an alley',
      imageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=400',
      category: 'art',
      location: 'Heritage District',
      distance: 320,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      authorName: 'Alex Rivera',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
      likes: 18,
      isLiked: true,
    ),
    Memory(
      id: '3',
      title: 'Sunset Yoga',
      description: 'Perfect evening for outdoor meditation',
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
      category: 'wellness',
      location: 'Riverside Park',
      distance: 890,
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      authorName: 'Emma Wilson',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
      likes: 45,
      isLiked: false,
    ),
  ];

  List<Memory> get _filteredMemories {
    return _nearbyMemories.where((memory) {
      if (_selectedFilter != 'all' && memory.category != _selectedFilter) {
        return false;
      }
      return memory.distance <= _radiusFilter;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    Logger.info('Around screen initialized');
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
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
    _fadeController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    Logger.info('Around screen disposed');
    super.dispose();
  }

  void _handleMemoryTap(Memory memory) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('light');
    themeProvider.playSound('tap');
    widget.onNavigate('memory-detail', isSubScreen: true, data: memory);
  }

  void _toggleView() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('medium');
    themeProvider.playSound('tap');
    setState(() => _isMapView = !_isMapView);
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
                          _buildFilters(colors, themeProvider, isSmallScreen, isMediumScreen),
                          Expanded(
                            child: _isMapView 
                                ? _buildMapView(colors, themeProvider, isSmallScreen, isMediumScreen)
                                : _buildListView(colors, themeProvider, isSmallScreen, isMediumScreen),
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
                      'Around You',
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
                  '${_filteredMemories.length} memories nearby',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // View toggle button
          GlassContainer(
            onTap: _toggleView,
            padding: EdgeInsets.all(isSmallScreen ? 8.0 : 10.0),
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Icon(
              _isMapView ? Icons.list_rounded : Icons.map_rounded,
              color: colors.textPrimary,
              size: iconSize,
            ),
          ),
          
          const SizedBox(width: 8),
          
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
        ],
      ),
    );
  }

  Widget _buildFilters(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    final filterHeight = isSmallScreen ? 36.0 : isMediumScreen ? 40.0 : 44.0;
    final fontSize = isSmallScreen ? 12.0 : isMediumScreen ? 13.0 : 14.0;
    
    final filters = [
      {'id': 'all', 'label': 'All', 'icon': Icons.explore_rounded},
      {'id': 'food', 'label': 'Food', 'icon': Icons.restaurant_rounded},
      {'id': 'art', 'label': 'Art', 'icon': Icons.palette_rounded},
      {'id': 'wellness', 'label': 'Wellness', 'icon': Icons.spa_rounded},
      {'id': 'events', 'label': 'Events', 'icon': Icons.event_rounded},
    ];
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          // Category filters
          SizedBox(
            height: filterHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              separatorBuilder: (context, index) => SizedBox(width: isSmallScreen ? 8.0 : 12.0),
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isActive = _selectedFilter == filter['id'];
                
                return GestureDetector(
                  onTap: () {
                    themeProvider.hapticFeedback('light');
                    themeProvider.playSound('tap');
                    setState(() => _selectedFilter = filter['id'] as String);
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
                          filter['icon'] as IconData,
                          size: isSmallScreen ? 16.0 : 18.0,
                          color: isActive ? Colors.white : colors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          filter['label'] as String,
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
          
          const SizedBox(height: 16),
          
          // Distance filter
          Row(
            children: [
              Icon(
                Icons.near_me_rounded,
                size: isSmallScreen ? 16.0 : 18.0,
                color: colors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Within ${(_radiusFilter / 1000).toStringAsFixed(1)}km',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: colors.accent,
                    inactiveTrackColor: colors.glassBorder,
                    thumbColor: colors.accent,
                    overlayColor: colors.accent.withOpacity(0.2),
                    trackHeight: 4.0,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  ),
                  child: Slider(
                    value: _radiusFilter,
                    min: 100,
                    max: 5000,
                    divisions: 49,
                    onChanged: (value) {
                      setState(() => _radiusFilter = value);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapView(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    return Container(
      margin: EdgeInsets.all(isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.premium),
        child: Stack(
          children: [
            // Simulated map background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green.shade100,
                    Colors.blue.shade100,
                    Colors.grey.shade100,
                  ],
                ),
              ),
              child: CustomPaint(
                painter: MapGridPainter(colors: colors),
                child: Container(),
              ),
            ),
            
            // Memory markers
            ...List.generate(_filteredMemories.length, (index) {
              final memory = _filteredMemories[index];
              final x = 80.0 + (index * 100) % 200;
              final y = 100.0 + (index * 80) % 300;
              
              return Positioned(
                left: x,
                top: y,
                child: _buildMapMarker(memory, colors, themeProvider, isSmallScreen),
              );
            }),
            
            // User location indicator
            Positioned(
              left: MediaQuery.of(context).size.width * 0.5 - 50,
              top: MediaQuery.of(context).size.height * 0.4,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: colors.shadowPurple,
                      ),
                      child: const Icon(
                        Icons.person_pin_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapMarker(Memory memory, AppColors colors, ThemeProvider themeProvider, bool isSmallScreen) {
    return GestureDetector(
      onTap: () => _handleMemoryTap(memory),
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 6.0 : 8.0),
        decoration: BoxDecoration(
          gradient: colors.gradientPrimary,
          borderRadius: BorderRadius.circular(isSmallScreen ? 12.0 : 16.0),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: colors.shadowMd,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getCategoryIcon(memory.category),
              size: isSmallScreen ? 16.0 : 20.0,
              color: Colors.white,
            ),
            const SizedBox(height: 2),
            Text(
              '${memory.distance}m',
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 10.0 : 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
      itemCount: _filteredMemories.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final memory = _filteredMemories[index];
        return _buildMemoryCard(memory, colors, themeProvider, isSmallScreen, isMediumScreen);
      },
    );
  }

  Widget _buildMemoryCard(Memory memory, AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final cardHeight = isSmallScreen ? 120.0 : isMediumScreen ? 140.0 : 160.0;
    final titleFontSize = isSmallScreen ? 14.0 : isMediumScreen ? 16.0 : 18.0;
    final bodyFontSize = isSmallScreen ? 12.0 : isMediumScreen ? 13.0 : 14.0;
    final metaFontSize = isSmallScreen ? 10.0 : isMediumScreen ? 11.0 : 12.0;
    
    return GlassContainer(
      onTap: () => _handleMemoryTap(memory),
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      borderRadius: BorderRadius.circular(AppRadius.premium),
      child: Row(
        children: [
          // Memory image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Image.network(
              memory.imageUrl,
              width: cardHeight - 24,
              height: cardHeight - 24,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: cardHeight - 24,
                  height: cardHeight - 24,
                  color: colors.glassBg,
                  child: Icon(
                    _getCategoryIcon(memory.category),
                    color: colors.textSecondary,
                    size: 32,
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Memory details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getCategoryIcon(memory.category),
                      size: isSmallScreen ? 14.0 : 16.0,
                      color: colors.accent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      memory.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: metaFontSize,
                        fontWeight: FontWeight.w600,
                        color: colors.accent,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${memory.distance}m',
                      style: TextStyle(
                        fontSize: metaFontSize,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  memory.title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  memory.description,
                  style: TextStyle(
                    fontSize: bodyFontSize,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    CircleAvatar(
                      radius: isSmallScreen ? 10.0 : 12.0,
                      backgroundImage: NetworkImage(memory.authorAvatar),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      memory.authorName,
                      style: TextStyle(
                        fontSize: metaFontSize,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      memory.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: isSmallScreen ? 14.0 : 16.0,
                      color: memory.isLiked ? Colors.red.shade400 : colors.textSecondary,
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'art':
        return Icons.palette_rounded;
      case 'wellness':
        return Icons.spa_rounded;
      case 'events':
        return Icons.event_rounded;
      case 'nature':
        return Icons.nature_rounded;
      default:
        return Icons.place_rounded;
    }
  }
}

class MapGridPainter extends CustomPainter {
  final AppColors colors;

  MapGridPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw grid for map-like appearance
    const spacing = 40.0;
    
    for (double x = spacing; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    for (double y = spacing; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw some map-like features
    final featurePaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw a "river"
    final riverPath = Path();
    riverPath.moveTo(0, size.height * 0.6);
    riverPath.quadraticBezierTo(
      size.width * 0.3, size.height * 0.4,
      size.width * 0.6, size.height * 0.7,
    );
    riverPath.quadraticBezierTo(
      size.width * 0.8, size.height * 0.9,
      size.width, size.height * 0.8,
    );
    riverPath.lineTo(size.width, size.height);
    riverPath.lineTo(0, size.height);
    riverPath.close();

    canvas.drawPath(riverPath, featurePaint);

    // Draw "park" areas
    final parkPaint = Paint()
      ..color = Colors.green.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      30,
      parkPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.4),
      25,
      parkPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}