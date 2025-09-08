import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_container.dart';
import '../widgets/logo.dart';
import '../core/utils/logger.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class ChatScreen extends StatefulWidget {
  final Function(String, {bool isSubScreen, dynamic data}) onNavigate;

  const ChatScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _staggerController;
  
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  String _selectedTab = 'messages';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<ChatData> _allChats = [
    ChatData(
      id: '1',
      name: 'Sarah Chen',
      avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b691?w=100',
      lastMessage: 'Found an amazing coffee spot! 📍',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isOnline: true,
      unreadCount: 2,
      type: 'direct',
      participants: ['sarah-chen'],
    ),
    ChatData(
      id: '2',
      name: 'Memory Hunters',
      avatar: 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=100',
      lastMessage: 'Alex: Check out this street art! 🎨',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isOnline: false,
      unreadCount: 0,
      type: 'group',
      participants: ['alex-rivera', 'mike-johnson', 'emma-watson'],
    ),
    ChatData(
      id: '3',
      name: 'Emma Wilson',
      avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
      lastMessage: 'Yoga session was incredible today ✨',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isOnline: true,
      unreadCount: 1,
      type: 'direct',
      participants: ['emma-watson'],
    ),
    ChatData(
      id: '4',
      name: 'Trail Blazers',
      avatar: 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=100',
      lastMessage: 'Mike: Summit trail this weekend?',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isOnline: false,
      unreadCount: 5,
      type: 'group',
      participants: ['mike-johnson', 'alex-rivera'],
    ),
    ChatData(
      id: '5',
      name: 'Alex Rivera',
      avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
      lastMessage: 'Thanks for the memory tip! 🙏',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isOnline: false,
      unreadCount: 0,
      type: 'direct',
      participants: ['alex-rivera'],
    ),
  ];

  final List<CommunityData> _communities = [
    CommunityData(
      id: '1',
      name: 'Street Art Enthusiasts',
      avatar: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=100',
      description: 'Discovering urban art across the city',
      memberCount: 1247,
      isJoined: true,
      category: 'Art',
    ),
    CommunityData(
      id: '2',
      name: 'Foodie Adventures',
      avatar: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=100',
      description: 'Hidden gems and culinary discoveries',
      memberCount: 2156,
      isJoined: false,
      category: 'Food',
    ),
    CommunityData(
      id: '3',
      name: 'Wellness Warriors',
      avatar: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=100',
      description: 'Mindfulness and fitness journey together',
      memberCount: 834,
      isJoined: true,
      category: 'Wellness',
    ),
  ];

  List<ChatData> get _filteredChats {
    if (!_isSearching || _searchController.text.isEmpty) {
      return _allChats;
    }
    return _allChats.where((chat) {
      return chat.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
             chat.lastMessage.toLowerCase().contains(_searchController.text.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    Logger.info('Chat screen initialized');
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
      duration: const Duration(milliseconds: 800),
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
    _staggerController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _staggerController.dispose();
    _searchController.dispose();
    Logger.info('Chat screen disposed');
    super.dispose();
  }

  void _handleChatTap(ChatData chat) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('light');
    themeProvider.playSound('tap');
    widget.onNavigate('chat-interface', isSubScreen: true, data: chat);
  }

  void _toggleSearch() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('light');
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
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
                          if (_isSearching) _buildSearchBar(colors, themeProvider, isSmallScreen, isMediumScreen),
                          _buildTabBar(colors, themeProvider, isSmallScreen, isMediumScreen),
                          Expanded(
                            child: _selectedTab == 'messages' 
                                ? _buildMessagesTab(colors, themeProvider, isSmallScreen, isMediumScreen)
                                : _buildCommunitiesTab(colors, themeProvider, isSmallScreen, isMediumScreen),
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
    
    return Container(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 16),
      child: Row(
        children: [
          // Logo and title
          Expanded(
            child: Row(
              children: [
                const LogoIcon(size: 28),
                const SizedBox(width: 12),
                Text(
                  'Chat',
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
          
          // Search button
          GlassContainer(
            onTap: _toggleSearch,
            padding: EdgeInsets.all(isSmallScreen ? 8.0 : 10.0),
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Icon(
              _isSearching ? Icons.close_rounded : Icons.search_rounded,
              color: colors.textPrimary,
              size: iconSize,
            ),
          ),
          
          const SizedBox(width: 8),
          
          // New chat button
          GlassContainer(
            onTap: () {
              themeProvider.hapticFeedback('medium');
              // TODO: Implement new chat functionality
            },
            padding: EdgeInsets.all(isSmallScreen ? 8.0 : 10.0),
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Icon(
              Icons.add_comment_rounded,
              color: colors.accent,
              size: iconSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    final fontSize = isSmallScreen ? 14.0 : isMediumScreen ? 15.0 : 16.0;
    
    return Container(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 16),
      child: GlassContainer(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12.0 : 16.0,
          vertical: isSmallScreen ? 8.0 : 12.0,
        ),
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: colors.textSecondary,
              size: isSmallScreen ? 18.0 : 20.0,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: 'Search messages...',
                  hintStyle: TextStyle(
                    color: colors.textSecondary,
                    fontSize: fontSize,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    final tabHeight = isSmallScreen ? 40.0 : isMediumScreen ? 44.0 : 48.0;
    final fontSize = isSmallScreen ? 14.0 : isMediumScreen ? 15.0 : 16.0;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: GlassContainer(
        padding: const EdgeInsets.all(4),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Row(
          children: [
            Expanded(
              child: _buildTabButton(
                'messages',
                'Messages',
                _allChats.where((chat) => chat.unreadCount > 0).length,
                colors,
                themeProvider,
                tabHeight,
                fontSize,
              ),
            ),
            Expanded(
              child: _buildTabButton(
                'communities',
                'Communities',
                null,
                colors,
                themeProvider,
                tabHeight,
                fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String id, String label, int? badgeCount, AppColors colors, ThemeProvider themeProvider, double height, double fontSize) {
    final isActive = _selectedTab == id;
    
    return GestureDetector(
      onTap: () {
        themeProvider.hapticFeedback('light');
        themeProvider.playSound('tap');
        setState(() => _selectedTab = id);
      },
      child: AnimatedContainer(
        duration: AppAnimations.medium,
        height: height,
        decoration: BoxDecoration(
          gradient: isActive ? colors.gradientPrimary : null,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: isActive ? colors.shadowPurple : null,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : colors.textSecondary,
                ),
              ),
              if (badgeCount != null && badgeCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white.withOpacity(0.2) : colors.accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$badgeCount',
                    style: TextStyle(
                      fontSize: fontSize * 0.75,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesTab(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 100),
      itemCount: _filteredChats.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
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
                child: _buildChatCard(_filteredChats[index], colors, themeProvider, isSmallScreen, isMediumScreen),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChatCard(ChatData chat, AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final cardPadding = isSmallScreen ? 12.0 : isMediumScreen ? 16.0 : 20.0;
    final avatarSize = isSmallScreen ? 50.0 : isMediumScreen ? 56.0 : 60.0;
    final titleFontSize = isSmallScreen ? 15.0 : isMediumScreen ? 16.0 : 17.0;
    final messageFontSize = isSmallScreen ? 13.0 : isMediumScreen ? 14.0 : 15.0;
    final metaFontSize = isSmallScreen ? 11.0 : isMediumScreen ? 12.0 : 13.0;
    
    return GlassContainer(
      onTap: () => _handleChatTap(chat),
      padding: EdgeInsets.all(cardPadding),
      borderRadius: BorderRadius.circular(AppRadius.premium),
      child: Row(
        children: [
          // Avatar with online indicator
          Stack(
            children: [
              CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: colors.glassBg,
                backgroundImage: NetworkImage(chat.avatar),
              ),
              if (chat.isOnline)
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    width: isSmallScreen ? 12.0 : 14.0,
                    height: isSmallScreen ? 12.0 : 14.0,
                    decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.glassBg,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(width: 16),
          
          // Chat details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (chat.type == 'group') ...[
                            Icon(
                              Icons.group_rounded,
                              size: isSmallScreen ? 14.0 : 16.0,
                              color: colors.accent,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Expanded(
                            child: Text(
                              chat.name,
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTimestamp(chat.timestamp),
                      style: TextStyle(
                        fontSize: metaFontSize,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 6),
                
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        chat.lastMessage,
                        style: TextStyle(
                          fontSize: messageFontSize,
                          fontWeight: FontWeight.w400,
                          color: chat.unreadCount > 0 ? colors.textPrimary : colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (chat.unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 6.0 : 8.0,
                          vertical: isSmallScreen ? 2.0 : 4.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: colors.gradientPrimary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: colors.shadowPurple,
                        ),
                        child: Text(
                          chat.unreadCount > 99 ? '99+' : '${chat.unreadCount}',
                          style: TextStyle(
                            fontSize: metaFontSize,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunitiesTab(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 100),
      itemCount: _communities.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
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
                child: _buildCommunityCard(_communities[index], colors, themeProvider, isSmallScreen, isMediumScreen),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCommunityCard(CommunityData community, AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final cardPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    final imageSize = isSmallScreen ? 80.0 : isMediumScreen ? 90.0 : 100.0;
    final titleFontSize = isSmallScreen ? 16.0 : isMediumScreen ? 17.0 : 18.0;
    final bodyFontSize = isSmallScreen ? 13.0 : isMediumScreen ? 14.0 : 15.0;
    final metaFontSize = isSmallScreen ? 11.0 : isMediumScreen ? 12.0 : 13.0;
    
    return GlassContainer(
      onTap: () {
        themeProvider.hapticFeedback('light');
        // TODO: Navigate to community detail
      },
      padding: EdgeInsets.all(cardPadding),
      borderRadius: BorderRadius.circular(AppRadius.premium),
      child: Row(
        children: [
          // Community image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Image.network(
              community.avatar,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: imageSize,
                  height: imageSize,
                  color: colors.glassBg,
                  child: Icon(
                    Icons.group_rounded,
                    color: colors.textSecondary,
                    size: imageSize * 0.4,
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Community details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colors.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        community.category,
                        style: TextStyle(
                          fontSize: metaFontSize,
                          fontWeight: FontWeight.w600,
                          color: colors.accent,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 8.0 : 12.0,
                        vertical: isSmallScreen ? 4.0 : 6.0,
                      ),
                      decoration: BoxDecoration(
                        gradient: community.isJoined ? colors.gradientPrimary : null,
                        color: community.isJoined ? null : colors.glassBg,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        border: Border.all(
                          color: community.isJoined ? Colors.transparent : colors.glassBorder,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        community.isJoined ? 'Joined' : 'Join',
                        style: TextStyle(
                          fontSize: metaFontSize,
                          fontWeight: FontWeight.w600,
                          color: community.isJoined ? Colors.white : colors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  community.name,
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
                  community.description,
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
                    Icon(
                      Icons.people_rounded,
                      size: isSmallScreen ? 14.0 : 16.0,
                      color: colors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_formatMemberCount(community.memberCount)} members',
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  String _formatMemberCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
  }
}

class ChatData {
  final String id;
  final String name;
  final String avatar;
  final String lastMessage;
  final DateTime timestamp;
  final bool isOnline;
  final int unreadCount;
  final String type; // 'direct' or 'group'
  final List<String> participants;

  ChatData({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.timestamp,
    required this.isOnline,
    required this.unreadCount,
    required this.type,
    required this.participants,
  });
}

class CommunityData {
  final String id;
  final String name;
  final String avatar;
  final String description;
  final int memberCount;
  final bool isJoined;
  final String category;

  CommunityData({
    required this.id,
    required this.name,
    required this.avatar,
    required this.description,
    required this.memberCount,
    required this.isJoined,
    required this.category,
  });
}