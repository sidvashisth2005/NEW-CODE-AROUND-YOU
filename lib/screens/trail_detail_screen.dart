import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../widgets/glass_container.dart';
import '../models/trail_model.dart';
import '../core/utils/logger.dart';

class TrailDetailScreen extends StatefulWidget {
  final Function(String, {bool isSubScreen, dynamic data}) onNavigate;
  final dynamic trail;

  const TrailDetailScreen({super.key, required this.onNavigate, this.trail});

  @override
  State<TrailDetailScreen> createState() => _TrailDetailScreenState();
}

class _TrailDetailScreenState extends State<TrailDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late ScrollController _scrollController;
  late TabController _tabController;
  
  bool _isBookmarked = false;
  bool _isStarted = false;
  int _completedPoints = 0;
  
  // Mock trail data - in real app, this would come from widget.trail
  final Trail _trailDetail = Trail(
    id: '1',
    title: 'Golden Gate Photography Walk',
    description: 'Capture stunning shots of SF\'s most iconic landmark and surrounding areas. This trail takes you through the best viewpoints and hidden gems around the Golden Gate Bridge.',
    authorId: 'sarah-chen',
    authorName: 'Sarah Chen',
    authorAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b08ac1c8?w=150&h=150&fit=crop&crop=face',
    coverImage: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop',
    difficulty: TrailDifficulty.easy,
    distance: 3.2,
    estimatedDuration: const Duration(hours: 2),
    memoryCount: 24,
    rating: 4.8,
    reviewCount: 156,
    category: 'photography',
    isBookmarked: false,
    isCompleted: false,
    tags: ['photography', 'scenic', 'landmarks', 'walking'],
    status: TrailStatus.published,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    points: [
      TrailPoint(
        id: '1',
        order: 1,
        title: 'Battery Spencer Viewpoint',
        description: 'Classic view of the Golden Gate Bridge from the north',
        latitude: 37.8330,
        longitude: -122.4836,
        type: TrailPointType.viewpoint,
        isRequired: true,
        instructions: 'Take a wide-angle shot of the bridge with the city skyline',
        hints: ['Best lighting in the morning', 'Use the trees as framing'],
        isCompleted: false,
      ),
      TrailPoint(
        id: '2',
        order: 2,
        title: 'Crissy Field',
        description: 'Ground-level view with beach and bridge',
        latitude: 37.8021,
        longitude: -122.4662,
        type: TrailPointType.activity,
        isRequired: true,
        instructions: 'Capture the bridge from beach level',
        hints: ['Look for interesting foreground elements', 'Try different angles'],
        isCompleted: false,
      ),
      TrailPoint(
        id: '3',
        order: 3,
        title: 'Lands End Lookout',
        description: 'Dramatic coastal views and bridge perspective',
        latitude: 37.7787,
        longitude: -122.5097,
        type: TrailPointType.landmark,
        isRequired: false,
        instructions: 'Capture the rugged coastline with bridge in distance',
        hints: ['Golden hour provides best lighting', 'Watch for fog conditions'],
        isCompleted: false,
      ),
    ],
    stats: const TrailStats(
      totalViews: 2847,
      totalCompletions: 156,
      totalBookmarks: 234,
      totalShares: 89,
      averageRating: 4.8,
      averageCompletionTime: Duration(hours: 2, minutes: 15),
      categoryBreakdown: {'photography': 80, 'scenic': 60, 'walking': 40},
      difficultyRatings: {'easy': 4.2, 'medium': 4.9, 'hard': 5.0},
    ),
    completedBy: ['user1', 'user2'],
    isPublic: true,
    allowCollaboration: true,
  );

  final List<TrailReview> _reviews = [
    TrailReview(
      id: '1',
      trailId: '1',
      userId: 'mike-johnson',
      userName: 'Mike Johnson',
      userAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      rating: 5.0,
      comment: 'Amazing trail! Got some incredible shots. The viewpoints are perfectly chosen and the instructions are super helpful.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      pros: ['Great viewpoints', 'Clear instructions', 'Perfect for beginners'],
      cons: ['Can get crowded on weekends'],
      completionTime: const Duration(hours: 1, minutes: 45),
      perceivedDifficulty: TrailDifficulty.easy,
    ),
    TrailReview(
      id: '2',
      trailId: '1',
      userId: 'alex-rivera',
      userName: 'Alex Rivera',
      userAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      rating: 4.5,
      comment: 'Well-planned route with diverse perspectives of the bridge. Really enjoyed the variety of shots possible.',
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
      pros: ['Diverse viewpoints', 'Good distance', 'Well marked'],
      cons: ['Parking can be challenging'],
      completionTime: const Duration(hours: 2, minutes: 30),
      perceivedDifficulty: TrailDifficulty.easy,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scrollController = ScrollController();
    _tabController = TabController(length: 3, vsync: this);
    
    _isBookmarked = _trailDetail.isBookmarked;
    _completedPoints = _trailDetail.points.where((p) => p.isCompleted).length;
    
    _fadeController.forward();
    Logger.navigation('unknown', 'TrailDetailScreen', arguments: {'trailId': _trailDetail.id});
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handleStartTrail() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('medium');
    themeProvider.playSound('tap');
    
    setState(() {
      _isStarted = !_isStarted;
    });
    
    Logger.userAction(_isStarted ? 'start_trail' : 'stop_trail', context: {
      'trailId': _trailDetail.id,
      'trailTitle': _trailDetail.title,
    });
    
    if (_isStarted) {
      _showStartTrailDialog();
    }
  }

  void _handleBookmark() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('light');
    
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    
    Logger.userAction(_isBookmarked ? 'bookmark_trail' : 'unbookmark_trail', context: {
      'trailId': _trailDetail.id,
    });
  }

  void _showStartTrailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GlassContainer(
            padding: const EdgeInsets.all(24),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6B1FB3), Color(0xFF8B4FD9)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6B1FB3).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.route,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Trail Started!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Follow the points in order and capture amazing memories along the way!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B1FB3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Let\'s Go!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: themeProvider.colors.background,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Cover image header
                SliverAppBar(
                  expandedHeight: 300,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  leading: GestureDetector(
                    onTap: () {
                      themeProvider.hapticFeedback('light');
                      widget.onNavigate('trails');
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: _handleBookmark,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: _isBookmarked ? const Color(0xFFFFD700) : Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        themeProvider.hapticFeedback('light');
                        // Show share options
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          _trailDetail.coverImage,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: themeProvider.colors.glassBg,
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                        // Difficulty badge
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(_trailDetail.difficulty).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _trailDetail.difficulty.name.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Content
                SliverToBoxAdapter(
                  child: AnimatedBuilder(
                    animation: _fadeController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeController.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeProvider.isDarkMode 
                                ? const Color(0xFF1A1A2E)
                                : const Color(0xFFF8FAFC),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header info
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title and rating
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _trailDetail.title,
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              color: themeProvider.colors.textPrimary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              size: 20,
                                              color: Color(0xFFFFD700),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${_trailDetail.rating}',
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: themeProvider.colors.textPrimary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              ' (${_trailDetail.reviewCount})',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: themeProvider.colors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 16),
                                    
                                    // Author info
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundImage: NetworkImage(_trailDetail.authorAvatar),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'by ${_trailDetail.authorName}',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: themeProvider.colors.textSecondary,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${_trailDetail.stats.totalCompletions} completions',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: themeProvider.colors.textTertiary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // Stats row
                                    Row(
                                      children: [
                                        _buildStatItem(Icons.straighten, '${_trailDetail.distance} km', themeProvider),
                                        const SizedBox(width: 24),
                                        _buildStatItem(Icons.access_time, '${_trailDetail.estimatedDuration.inHours}h ${_trailDetail.estimatedDuration.inMinutes % 60}m', themeProvider),
                                        const SizedBox(width: 24),
                                        _buildStatItem(Icons.camera_alt, '${_trailDetail.memoryCount}', themeProvider),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 24),
                                    
                                    // Start/Stop button
                                    GestureDetector(
                                      onTap: _handleStartTrail,
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: _isStarted
                                                ? [Colors.red, Colors.red.withOpacity(0.8)]
                                                : [const Color(0xFF6B1FB3), const Color(0xFF8B4FD9)],
                                          ),
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: themeProvider.colors.shadowPurple,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              _isStarted ? Icons.stop : Icons.play_arrow,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              _isStarted ? 'Stop Trail' : 'Start Trail',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    
                                    if (_isStarted) ...[
                                      const SizedBox(height: 16),
                                      GlassContainer(
                                        padding: const EdgeInsets.all(16),
                                        borderRadius: BorderRadius.circular(16),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: themeProvider.colors.accent,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Trail Progress',
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      color: themeProvider.colors.textPrimary,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    '$_completedPoints of ${_trailDetail.points.length} points completed',
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      color: themeProvider.colors.textSecondary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              '${((_completedPoints / _trailDetail.points.length) * 100).round()}%',
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: themeProvider.colors.accent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              
                              // Tabs
                              TabBar(
                                controller: _tabController,
                                labelColor: themeProvider.colors.accent,
                                unselectedLabelColor: themeProvider.colors.textSecondary,
                                indicatorColor: themeProvider.colors.accent,
                                tabs: const [
                                  Tab(text: 'Overview'),
                                  Tab(text: 'Points'),
                                  Tab(text: 'Reviews'),
                                ],
                              ),
                              
                              // Tab content
                              SizedBox(
                                height: 600,
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    _buildOverviewTab(themeProvider),
                                    _buildPointsTab(themeProvider),
                                    _buildReviewsTab(themeProvider),
                                  ],
                                ),
                              ),
                            ],
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
      },
    );
  }

  Widget _buildStatItem(IconData icon, String value, ThemeProvider themeProvider) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: themeProvider.colors.textTertiary,
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: themeProvider.colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab(ThemeProvider themeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            'Description',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: themeProvider.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _trailDetail.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: themeProvider.colors.textPrimary,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Tags
          Text(
            'Tags',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: themeProvider.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _trailDetail.tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: themeProvider.colors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: themeProvider.colors.accent.withOpacity(0.3),
                ),
              ),
              child: Text(
                '#$tag',
                style: TextStyle(
                  color: themeProvider.colors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Statistics
          Text(
            'Statistics',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: themeProvider.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          GlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                _buildStatRow('Total Views', '${_trailDetail.stats.totalViews}', themeProvider),
                const Divider(height: 24),
                _buildStatRow('Completions', '${_trailDetail.stats.totalCompletions}', themeProvider),
                const Divider(height: 24),
                _buildStatRow('Bookmarks', '${_trailDetail.stats.totalBookmarks}', themeProvider),
                const Divider(height: 24),
                _buildStatRow('Average Time', '${_trailDetail.stats.averageCompletionTime.inHours}h ${_trailDetail.stats.averageCompletionTime.inMinutes % 60}m', themeProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsTab(ThemeProvider themeProvider) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _trailDetail.points.length,
      itemBuilder: (context, index) {
        final point = _trailDetail.points[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: GlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: point.isCompleted
                            ? const Color(0xFF00D4AA)
                            : themeProvider.colors.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: point.isCompleted
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : Text(
                                '${point.order}',
                                style: TextStyle(
                                  color: themeProvider.colors.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            point.title,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: themeProvider.colors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (point.description?.isNotEmpty == true)
                            Text(
                              point.description!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: themeProvider.colors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPointTypeColor(point.type).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        point.type.name.toUpperCase(),
                        style: TextStyle(
                          color: _getPointTypeColor(point.type),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                if (point.instructions?.isNotEmpty == true) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: themeProvider.colors.glassBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Instructions',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: themeProvider.colors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          point.instructions!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: themeProvider.colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                if (point.hints.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: point.hints.map((hint) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            size: 12,
                            color: Color(0xFFFFD700),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hint,
                            style: const TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab(ThemeProvider themeProvider) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _reviews.length + 1, // +1 for header
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reviews (${_reviews.length})',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: themeProvider.colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  themeProvider.hapticFeedback('light');
                  // Show add review dialog
                },
                child: GlassContainer(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  borderRadius: BorderRadius.circular(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.rate_review,
                        color: themeProvider.colors.accent,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Write a Review',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: themeProvider.colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: themeProvider.colors.textTertiary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        }
        
        final review = _reviews[index - 1];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: GlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(review.userAvatar),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.userName,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: themeProvider.colors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              ...List.generate(5, (i) => Icon(
                                Icons.star,
                                size: 14,
                                color: i < review.rating 
                                    ? const Color(0xFFFFD700)
                                    : themeProvider.colors.textTertiary,
                              )),
                              const SizedBox(width: 8),
                              Text(
                                _formatDate(review.createdAt),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: themeProvider.colors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                if (review.comment?.isNotEmpty == true) ...[
                  const SizedBox(height: 12),
                  Text(
                    review.comment!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: themeProvider.colors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ],
                
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 14,
                      color: themeProvider.colors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Completed in ${review.completionTime.inHours}h ${review.completionTime.inMinutes % 60}m',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: themeProvider.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value, ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: themeProvider.colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: themeProvider.colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(TrailDifficulty difficulty) {
    switch (difficulty) {
      case TrailDifficulty.easy:
        return const Color(0xFF00D4AA);
      case TrailDifficulty.medium:
        return const Color(0xFFFFD700);
      case TrailDifficulty.hard:
        return const Color(0xFFFF6B6B);
    }
  }

  Color _getPointTypeColor(TrailPointType type) {
    switch (type) {
      case TrailPointType.viewpoint:
        return const Color(0xFF6B1FB3);
      case TrailPointType.landmark:
        return const Color(0xFFFFD700);
      case TrailPointType.activity:
        return const Color(0xFF00D4AA);
      case TrailPointType.checkpoint:
        return const Color(0xFF8B4FD9);
      case TrailPointType.finish:
        return const Color(0xFFFF6B6B);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}