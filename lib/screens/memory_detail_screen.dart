import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../models/streak_provider.dart';
import '../widgets/glass_container.dart';

class MemoryDetailScreen extends StatefulWidget {
  final Function(String, {bool isSubScreen, dynamic data}) onNavigate;
  final dynamic memory;

  const MemoryDetailScreen({
    super.key,
    required this.onNavigate,
    this.memory,
  });

  @override
  State<MemoryDetailScreen> createState() => _MemoryDetailScreenState();
}

class _MemoryDetailScreenState extends State<MemoryDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _likeController;
  late TextEditingController _commentController;
  late ScrollController _scrollController;
  
  bool _isLiked = false;
  bool _isBookmarked = false;
  int _likesCount = 42;
  
  // Mock memory data
  final MemoryDetail _memoryDetail = MemoryDetail(
    id: '1',
    user: 'Sarah Chen',
    avatar: 'https://images.unsplash.com/photo-1494790108755-2616b08ac1c8?w=150&h=150&fit=crop&crop=face',
    image: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=600&fit=crop',
    caption: 'Amazing sunset at Golden Gate Park! The colors were absolutely incredible tonight. Nature never ceases to amaze me 🌅✨',
    location: 'Golden Gate Park, San Francisco',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    likes: 42,
    comments: 8,
    isLiked: false,
    isBookmarked: false,
    tags: ['sunset', 'nature', 'photography', 'goldengatepark'],
  );

  final List<CommentItem> _comments = [
    CommentItem(
      id: '1',
      user: 'Mike Johnson',
      avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      comment: 'Wow, this is stunning! What camera did you use?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      likes: 5,
      isLiked: false,
    ),
    CommentItem(
      id: '2',
      user: 'Alex Rivera',
      avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      comment: 'The lighting is perfect! 📸',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      likes: 3,
      isLiked: true,
    ),
    CommentItem(
      id: '3',
      user: 'Emma Watson',
      avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      comment: 'I was there yesterday! Such a beautiful spot for photography.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      likes: 2,
      isLiked: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _commentController = TextEditingController();
    _scrollController = ScrollController();
    
    _isLiked = _memoryDetail.isLiked;
    _isBookmarked = _memoryDetail.isBookmarked;
    _likesCount = _memoryDetail.likes;
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _likeController.dispose();
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleLike() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final streakProvider = Provider.of<StreakProvider>(context, listen: false);
    
    themeProvider.hapticFeedback('light');
    
    setState(() {
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
    });
    
    if (_isLiked) {
      _likeController.forward().then((_) => _likeController.reverse());
      // Update user streak
      streakProvider.updateStreak('current-user');
    }
  }

  void _handleBookmark() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('medium');
    
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  void _handleAddComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('light');
    
    setState(() {
      _comments.insert(0, CommentItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        user: 'You',
        avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        comment: text,
        timestamp: DateTime.now(),
        likes: 0,
        isLiked: false,
      ));
      _commentController.clear();
    });
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
                // Image header
                SliverAppBar(
                  expandedHeight: 400,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  leading: GestureDetector(
                    onTap: () {
                      themeProvider.hapticFeedback('light');
                      widget.onNavigate('home');
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
                          _memoryDetail.image,
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
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // User info and actions
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundImage: NetworkImage(_memoryDetail.avatar),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _memoryDetail.user,
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              color: themeProvider.colors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 14,
                                                color: themeProvider.colors.textTertiary,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                _memoryDetail.location,
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: themeProvider.colors.textTertiary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: _handleLike,
                                          child: AnimatedBuilder(
                                            animation: _likeController,
                                            builder: (context, child) {
                                              return Transform.scale(
                                                scale: 1.0 + (_likeController.value * 0.3),
                                                child: Container(
                                                  width: 44,
                                                  height: 44,
                                                  decoration: BoxDecoration(
                                                    color: _isLiked 
                                                        ? Colors.red.withOpacity(0.1)
                                                        : themeProvider.colors.glassBg,
                                                    borderRadius: BorderRadius.circular(22),
                                                    border: Border.all(
                                                      color: _isLiked 
                                                          ? Colors.red.withOpacity(0.3)
                                                          : themeProvider.colors.glassBorder,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    _isLiked ? Icons.favorite : Icons.favorite_border,
                                                    size: 20,
                                                    color: _isLiked 
                                                        ? Colors.red 
                                                        : themeProvider.colors.textSecondary,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: _handleBookmark,
                                          child: Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: _isBookmarked 
                                                  ? const Color(0xFFFFD700).withOpacity(0.1)
                                                  : themeProvider.colors.glassBg,
                                              borderRadius: BorderRadius.circular(22),
                                              border: Border.all(
                                                color: _isBookmarked 
                                                    ? const Color(0xFFFFD700).withOpacity(0.3)
                                                    : themeProvider.colors.glassBorder,
                                              ),
                                            ),
                                            child: Icon(
                                              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                              size: 20,
                                              color: _isBookmarked 
                                                  ? const Color(0xFFFFD700)
                                                  : themeProvider.colors.textSecondary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Caption
                                Text(
                                  _memoryDetail.caption,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: themeProvider.colors.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Tags
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _memoryDetail.tags.map((tag) => Container(
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
                                
                                const SizedBox(height: 20),
                                
                                // Stats
                                Row(
                                  children: [
                                    Text(
                                      '$_likesCount likes',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: themeProvider.colors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      '${_comments.length} comments',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: themeProvider.colors.textSecondary,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      _formatTimestamp(_memoryDetail.timestamp),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: themeProvider.colors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 32),
                                
                                // Comments section
                                Text(
                                  'Comments',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: themeProvider.colors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Add comment
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: themeProvider.colors.accent,
                                      child: const Icon(
                                        Icons.person,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextField(
                                        controller: _commentController,
                                        decoration: InputDecoration(
                                          hintText: 'Add a comment...',
                                          hintStyle: TextStyle(
                                            color: themeProvider.colors.textTertiary,
                                          ),
                                          filled: true,
                                          fillColor: themeProvider.colors.glassBg,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(24),
                                            borderSide: BorderSide(
                                              color: themeProvider.colors.glassBorder,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(24),
                                            borderSide: BorderSide(
                                              color: themeProvider.colors.glassBorder,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(24),
                                            borderSide: BorderSide(
                                              color: themeProvider.colors.accent,
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                        ),
                                        style: TextStyle(
                                          color: themeProvider.colors.textPrimary,
                                        ),
                                        onSubmitted: (_) => _handleAddComment(),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: _handleAddComment,
                                      child: Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              themeProvider.colors.accent,
                                              themeProvider.colors.accent.withOpacity(0.8),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(22),
                                        ),
                                        child: const Icon(
                                          Icons.send,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Comments list
                                ..._comments.map((comment) => _buildCommentItem(comment, themeProvider)),
                                
                                const SizedBox(height: 100), // Bottom padding
                              ],
                            ),
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

  Widget _buildCommentItem(CommentItem comment, ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(comment.avatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.user,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: themeProvider.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTimestamp(comment.timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: themeProvider.colors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.comment,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: themeProvider.colors.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        themeProvider.hapticFeedback('light');
                        // Handle comment like
                      },
                      child: Row(
                        children: [
                          Icon(
                            comment.isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: comment.isLiked 
                                ? Colors.red 
                                : themeProvider.colors.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${comment.likes}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: themeProvider.colors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        themeProvider.hapticFeedback('light');
                        // Reply to comment
                      },
                      child: Text(
                        'Reply',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: themeProvider.colors.textTertiary,
                          fontWeight: FontWeight.w600,
                        ),
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}

class MemoryDetail {
  final String id;
  final String user;
  final String avatar;
  final String image;
  final String caption;
  final String location;
  final DateTime timestamp;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isBookmarked;
  final List<String> tags;

  MemoryDetail({
    required this.id,
    required this.user,
    required this.avatar,
    required this.image,
    required this.caption,
    required this.location,
    required this.timestamp,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.isBookmarked,
    required this.tags,
  });
}

class CommentItem {
  final String id;
  final String user;
  final String avatar;
  final String comment;
  final DateTime timestamp;
  final int likes;
  final bool isLiked;

  CommentItem({
    required this.id,
    required this.user,
    required this.avatar,
    required this.comment,
    required this.timestamp,
    required this.likes,
    required this.isLiked,
  });
}