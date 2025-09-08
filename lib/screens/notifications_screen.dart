import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../widgets/glass_container.dart';

class NotificationsScreen extends StatefulWidget {
  final Function(String, {bool isSubScreen, dynamic data}) onNavigate;

  const NotificationsScreen({super.key, required this.onNavigate});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late ScrollController _scrollController;
  
  String _selectedFilter = 'all';
  final List<String> _filters = ['all', 'memories', 'social', 'system'];

  // Mock notifications
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      type: 'like',
      category: 'social',
      title: 'Sarah Chen liked your memory',
      message: 'Golden Gate Park sunset photo',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
      avatar: 'https://images.unsplash.com/photo-1494790108755-2616b08ac1c8?w=150&h=150&fit=crop&crop=face',
      actionData: {'memoryId': '123'},
    ),
    NotificationItem(
      id: '2',
      type: 'comment',
      category: 'social',
      title: 'Mike Johnson commented on your memory',
      message: '"Amazing shot! What camera did you use?"',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
      avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      actionData: {'memoryId': '123'},
    ),
    NotificationItem(
      id: '3',
      type: 'new_memory',
      category: 'memories',
      title: 'New memory near you',
      message: 'Alex Rivera shared a memory 200m away',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: true,
      avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      actionData: {'memoryId': '124'},
    ),
    NotificationItem(
      id: '4',
      type: 'follow',
      category: 'social',
      title: 'Emma Watson started following you',
      message: 'Check out her photography trail',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
      avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      actionData: {'userId': 'emma'},
    ),
    NotificationItem(
      id: '5',
      type: 'trail_update',
      category: 'memories',
      title: 'Trail completed!',
      message: 'You completed "Mission District Food Tour"',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
      actionData: {'trailId': 'trail_2'},
    ),
    NotificationItem(
      id: '6',
      type: 'streak',
      category: 'system',
      title: 'Streak milestone! 🔥',
      message: 'You\'ve maintained a 5-day sharing streak',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      isRead: true,
      actionData: {},
    ),
    NotificationItem(
      id: '7',
      type: 'premium',
      category: 'system',
      title: 'Premium features available',
      message: 'Unlock unlimited storage and advanced filters',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      actionData: {'action': 'upgrade'},
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scrollController = ScrollController();
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<NotificationItem> get _filteredNotifications {
    if (_selectedFilter == 'all') return _notifications;
    return _notifications.where((n) => n.category == _selectedFilter).toList();
  }

  void _handleNotificationTap(NotificationItem notification) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('light');
    
    // Mark as read
    setState(() {
      notification.isRead = true;
    });
    
    // Handle navigation based on notification type
    switch (notification.type) {
      case 'like':
      case 'comment':
      case 'new_memory':
        widget.onNavigate('memory-detail', data: notification.actionData);
        break;
      case 'follow':
        // Navigate to user profile
        break;
      case 'trail_update':
        widget.onNavigate('trail-detail', data: notification.actionData);
        break;
      case 'premium':
        // Show premium upgrade
        break;
    }
  }

  void _markAllAsRead() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('medium');
    
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;
    
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: themeProvider.colors.background,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildAppBar(themeProvider, unreadCount),
            body: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 1000));
              },
              color: themeProvider.colors.accent,
              child: Column(
                children: [
                  // Filter tabs
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: _buildFilterTabs(themeProvider),
                  ),
                  
                  // Notifications list
                  Expanded(
                    child: _filteredNotifications.isEmpty
                        ? _buildEmptyState(themeProvider)
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _filteredNotifications.length,
                            itemBuilder: (context, index) {
                              return AnimatedBuilder(
                                animation: _fadeController,
                                builder: (context, child) {
                                  final delay = index * 0.05;
                                  final animation = Tween<double>(
                                    begin: 0.0,
                                    end: 1.0,
                                  ).animate(CurvedAnimation(
                                    parent: _fadeController,
                                    curve: Interval(
                                      delay,
                                      (delay + 0.3).clamp(0.0, 1.0),
                                      curve: Curves.easeOut,
                                    ),
                                  ));
                                  
                                  return Transform.translate(
                                    offset: Offset(50 * (1 - animation.value), 0),
                                    child: Opacity(
                                      opacity: animation.value,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: _buildNotificationItem(
                                          _filteredNotifications[index],
                                          themeProvider,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeProvider themeProvider, int unreadCount) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          themeProvider.hapticFeedback('light');
          widget.onNavigate('home');
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: themeProvider.colors.glassBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: themeProvider.colors.glassBorder,
            ),
          ),
          child: const Icon(Icons.arrow_back_ios_new, size: 18),
        ),
      ),
      title: Column(
        children: [
          Text(
            'Notifications',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: themeProvider.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (unreadCount > 0)
            Text(
              '$unreadCount unread',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: themeProvider.colors.accent,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
      centerTitle: true,
      actions: [
        if (unreadCount > 0)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: _markAllAsRead,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: themeProvider.colors.glassBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: themeProvider.colors.glassBorder,
                  ),
                ),
                child: const Icon(Icons.done_all, size: 18),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterTabs(ThemeProvider themeProvider) {
    return GlassContainer(
      padding: const EdgeInsets.all(4),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: _filters.map((filter) {
          final isActive = _selectedFilter == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
                themeProvider.hapticFeedback('light');
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isActive ? themeProvider.colors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  filter.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isActive 
                        ? Colors.white 
                        : themeProvider.colors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification, ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: () => _handleNotificationTap(notification),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(20),
        backgroundColor: notification.isRead 
            ? null 
            : themeProvider.colors.accent.withOpacity(0.05),
        borderColor: notification.isRead 
            ? null 
            : themeProvider.colors.accent.withOpacity(0.2),
        child: Row(
          children: [
            // Notification icon/avatar
            Stack(
              children: [
                if (notification.avatar != null)
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(notification.avatar!),
                  )
                else
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getNotificationColor(notification.type).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getNotificationIcon(notification.type),
                      color: _getNotificationColor(notification.type),
                      size: 24,
                    ),
                  ),
                
                // Unread indicator
                if (!notification.isRead)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: themeProvider.colors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(width: 16),
            
            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: themeProvider.colors.textPrimary,
                      fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: themeProvider.colors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: themeProvider.colors.textTertiary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            
            // Action indicator
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: themeProvider.colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeProvider themeProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: themeProvider.colors.glassBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              size: 40,
              color: themeProvider.colors.textTertiary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No notifications yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: themeProvider.colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ll see updates about your memories and social activity here',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: themeProvider.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.comment;
      case 'follow':
        return Icons.person_add;
      case 'new_memory':
        return Icons.camera_alt;
      case 'trail_update':
        return Icons.route;
      case 'streak':
        return Icons.local_fire_department;
      case 'premium':
        return Icons.star;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'like':
        return Colors.red;
      case 'comment':
        return const Color(0xFF00D4AA);
      case 'follow':
        return const Color(0xFF6B1FB3);
      case 'new_memory':
        return const Color(0xFFFFD700);
      case 'trail_update':
        return const Color(0xFF6B1FB3);
      case 'streak':
        return Colors.orange;
      case 'premium':
        return const Color(0xFFFFD700);
      default:
        return const Color(0xFF6B1FB3);
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class NotificationItem {
  final String id;
  final String type;
  final String category;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;
  final String? avatar;
  final Map<String, dynamic> actionData;

  NotificationItem({
    required this.id,
    required this.type,
    required this.category,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    this.avatar,
    required this.actionData,
  });
}