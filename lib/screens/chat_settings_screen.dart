import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../widgets/glass_container.dart';
import '../core/utils/logger.dart';

class ChatSettingsScreen extends StatefulWidget {
  final Function(String, {bool isSubScreen, dynamic data}) onNavigate;
  final dynamic chat;

  const ChatSettingsScreen({
    super.key,
    required this.onNavigate,
    this.chat,
  });

  @override
  State<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late ScrollController _scrollController;
  
  bool _notificationsEnabled = true;
  bool _muteChat = false;
  bool _readReceipts = true;
  bool _typingIndicators = true;
  bool _mediaAutoDownload = true;
  String _wallpaper = 'default';
  
  // Mock chat data
  final ChatData _chatData = ChatData(
    id: '1',
    name: 'Sarah Chen',
    avatar: 'https://images.unsplash.com/photo-1494790108755-2616b08ac1c8?w=150&h=150&fit=crop&crop=face',
    isOnline: true,
    lastSeen: null,
    messageCount: 143,
    mediaCount: 28,
    sharedMemories: 12,
  );

  final List<String> _wallpaperOptions = [
    'default',
    'gradient',
    'nature',
    'city',
    'abstract',
  ];

  final List<ChatSettingsSection> _sections = [
    ChatSettingsSection(
      title: 'Chat Info',
      items: [
        ChatSettingsItem(
          icon: Icons.person,
          title: 'View Profile',
          subtitle: 'See profile and shared memories',
          action: 'view-profile',
        ),
        ChatSettingsItem(
          icon: Icons.camera_alt,
          title: 'Shared Memories',
          subtitle: '12 memories shared',
          action: 'shared-memories',
        ),
        ChatSettingsItem(
          icon: Icons.photo_library,
          title: 'Media Gallery',
          subtitle: '28 photos and videos',
          action: 'media-gallery',
        ),
      ],
    ),
    ChatSettingsSection(
      title: 'Chat Settings',
      items: [
        ChatSettingsItem(
          icon: Icons.notifications,
          title: 'Notifications',
          subtitle: 'Message alerts and sounds',
          hasToggle: true,
        ),
        ChatSettingsItem(
          icon: Icons.volume_off,
          title: 'Mute Chat',
          subtitle: 'Stop receiving notifications',
          hasToggle: true,
        ),
        ChatSettingsItem(
          icon: Icons.done_all,
          title: 'Read Receipts',
          subtitle: 'Let others know when you\'ve read messages',
          hasToggle: true,
        ),
        ChatSettingsItem(
          icon: Icons.keyboard,
          title: 'Typing Indicators',
          subtitle: 'Show when you\'re typing',
          hasToggle: true,
        ),
      ],
    ),
    ChatSettingsSection(
      title: 'Media & Storage',
      items: [
        ChatSettingsItem(
          icon: Icons.download,
          title: 'Auto-download Media',
          subtitle: 'Automatically download photos and videos',
          hasToggle: true,
        ),
        ChatSettingsItem(
          icon: Icons.wallpaper,
          title: 'Chat Wallpaper',
          subtitle: 'Customize chat background',
          action: 'wallpaper',
        ),
        ChatSettingsItem(
          icon: Icons.storage,
          title: 'Storage Usage',
          subtitle: '245 MB used',
          action: 'storage',
        ),
      ],
    ),
    ChatSettingsSection(
      title: 'Privacy & Safety',
      items: [
        ChatSettingsItem(
          icon: Icons.block,
          title: 'Block User',
          subtitle: 'Stop receiving messages from this user',
          action: 'block-user',
          isDestructive: true,
        ),
        ChatSettingsItem(
          icon: Icons.report,
          title: 'Report User',
          subtitle: 'Report inappropriate behavior',
          action: 'report-user',
          isDestructive: true,
        ),
      ],
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
    Logger.navigation('unknown', 'ChatSettingsScreen', arguments: {'chatId': _chatData.id});
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleItemTap(ChatSettingsItem item, ThemeProvider themeProvider) {
    themeProvider.hapticFeedback('light');
    
    Logger.userAction('chat_settings_action', context: {
      'action': item.action,
      'chatId': _chatData.id,
    });
    
    switch (item.action) {
      case 'view-profile':
        // Navigate to user profile
        break;
      case 'shared-memories':
        // Show shared memories
        break;
      case 'media-gallery':
        // Show media gallery
        break;
      case 'wallpaper':
        _showWallpaperPicker(themeProvider);
        break;
      case 'storage':
        _showStorageInfo(themeProvider);
        break;
      case 'block-user':
        _showBlockUserDialog(themeProvider);
        break;
      case 'report-user':
        _showReportUserDialog(themeProvider);
        break;
    }
  }

  void _showWallpaperPicker(ThemeProvider themeProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GlassContainer(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Wallpaper',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: themeProvider.colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: _wallpaperOptions.length,
                itemBuilder: (context, index) {
                  final wallpaper = _wallpaperOptions[index];
                  final isSelected = _wallpaper == wallpaper;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _wallpaper = wallpaper;
                      });
                      Navigator.pop(context);
                      themeProvider.hapticFeedback('medium');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getWallpaperColor(wallpaper),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? themeProvider.colors.accent
                              : themeProvider.colors.glassBorder,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getWallpaperIcon(wallpaper),
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            wallpaper.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStorageInfo(ThemeProvider themeProvider) {
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
                Icon(
                  Icons.storage,
                  size: 48,
                  color: themeProvider.colors.accent,
                ),
                const SizedBox(height: 20),
                Text(
                  'Storage Usage',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: themeProvider.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildStorageItem('Photos', '156 MB', 0.6, themeProvider),
                const SizedBox(height: 8),
                _buildStorageItem('Videos', '78 MB', 0.3, themeProvider),
                const SizedBox(height: 8),
                _buildStorageItem('Messages', '11 MB', 0.1, themeProvider),
                
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Clear Cache',
                          style: TextStyle(color: themeProvider.colors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeProvider.colors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(color: Colors.white),
                        ),
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

  void _showBlockUserDialog(ThemeProvider themeProvider) {
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
                    color: Colors.red.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.block,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Block ${_chatData.name}?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: themeProvider.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You won\'t receive messages from this user. They won\'t be notified that you blocked them.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: themeProvider.colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: themeProvider.colors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onNavigate('chat');
                          themeProvider.hapticFeedback('heavy');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Block',
                          style: TextStyle(color: Colors.white),
                        ),
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

  void _showReportUserDialog(ThemeProvider themeProvider) {
    final List<String> reportReasons = [
      'Spam',
      'Harassment',
      'Inappropriate content',
      'Fake profile',
      'Other',
    ];
    
    String selectedReason = reportReasons.first;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GlassContainer(
            padding: const EdgeInsets.all(24),
            borderRadius: BorderRadius.circular(20),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.report,
                        color: Colors.orange,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Report ${_chatData.name}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: themeProvider.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Why are you reporting this user?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: themeProvider.colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    ...reportReasons.map((reason) {
                      final isSelected = selectedReason == reason;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedReason = reason;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? themeProvider.colors.accent.withOpacity(0.1)
                                : themeProvider.colors.glassBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected 
                                  ? themeProvider.colors.accent
                                  : themeProvider.colors.glassBorder,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                color: isSelected 
                                    ? themeProvider.colors.accent
                                    : themeProvider.colors.textTertiary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                reason,
                                style: TextStyle(
                                  color: themeProvider.colors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: themeProvider.colors.textSecondary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              themeProvider.hapticFeedback('medium');
                              _showReportSubmittedDialog(themeProvider);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Report',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showReportSubmittedDialog(ThemeProvider themeProvider) {
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
                    color: const Color(0xFF00D4AA),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00D4AA).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Report Submitted',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Thank you for your report. We\'ll review it and take appropriate action.',
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
                    backgroundColor: const Color(0xFF00D4AA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Done',
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
            appBar: _buildAppBar(themeProvider),
            body: AnimatedBuilder(
              animation: _fadeController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeController.value,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Chat info header
                        _buildChatInfoHeader(themeProvider),
                        
                        const SizedBox(height: 32),
                        
                        // Settings sections
                        ..._sections.map((section) => 
                          _buildSection(section, themeProvider)
                        ).toList(),
                        
                        const SizedBox(height: 100), // Bottom padding
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeProvider themeProvider) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          themeProvider.hapticFeedback('light');
          widget.onNavigate('chat-interface', data: widget.chat);
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
      title: Text(
        'Chat Settings',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: themeProvider.colors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildChatInfoHeader(ThemeProvider themeProvider) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(_chatData.avatar),
              ),
              if (_chatData.isOnline)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D4AA),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            _chatData.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: themeProvider.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            _chatData.isOnline ? 'Online' : 'Last seen ${_chatData.lastSeen}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: themeProvider.colors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('${_chatData.messageCount}', 'Messages', themeProvider),
              _buildStatItem('${_chatData.mediaCount}', 'Media', themeProvider),
              _buildStatItem('${_chatData.sharedMemories}', 'Memories', themeProvider),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, ThemeProvider themeProvider) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: themeProvider.colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: themeProvider.colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(ChatSettingsSection section, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            section.title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: themeProvider.colors.textTertiary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        GlassContainer(
          padding: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: section.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == section.items.length - 1;
              
              return _buildSettingsItem(item, themeProvider, !isLast);
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSettingsItem(ChatSettingsItem item, ThemeProvider themeProvider, bool showDivider) {
    return Column(
      children: [
        GestureDetector(
          onTap: item.hasToggle ? null : () => _handleItemTap(item, themeProvider),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.isDestructive
                        ? Colors.red.withOpacity(0.1)
                        : themeProvider.colors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.isDestructive
                        ? Colors.red
                        : themeProvider.colors.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: item.isDestructive
                              ? Colors.red
                              : themeProvider.colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        item.subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: themeProvider.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.hasToggle)
                  Switch(
                    value: _getToggleValue(item.title),
                    onChanged: (value) => _handleToggle(item.title, value, themeProvider),
                    activeColor: themeProvider.colors.accent,
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: themeProvider.colors.textTertiary,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: themeProvider.colors.glassBorder,
            indent: 72,
          ),
      ],
    );
  }

  Widget _buildStorageItem(String label, String size, double percentage, ThemeProvider themeProvider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: themeProvider.colors.textPrimary,
              ),
            ),
            Text(
              size,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: themeProvider.colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: themeProvider.colors.glassBg,
          valueColor: AlwaysStoppedAnimation<Color>(themeProvider.colors.accent),
        ),
      ],
    );
  }

  bool _getToggleValue(String title) {
    switch (title) {
      case 'Notifications':
        return _notificationsEnabled;
      case 'Mute Chat':
        return _muteChat;
      case 'Read Receipts':
        return _readReceipts;
      case 'Typing Indicators':
        return _typingIndicators;
      case 'Auto-download Media':
        return _mediaAutoDownload;
      default:
        return false;
    }
  }

  void _handleToggle(String title, bool value, ThemeProvider themeProvider) {
    themeProvider.hapticFeedback('light');
    
    setState(() {
      switch (title) {
        case 'Notifications':
          _notificationsEnabled = value;
          break;
        case 'Mute Chat':
          _muteChat = value;
          break;
        case 'Read Receipts':
          _readReceipts = value;
          break;
        case 'Typing Indicators':
          _typingIndicators = value;
          break;
        case 'Auto-download Media':
          _mediaAutoDownload = value;
          break;
      }
    });
  }

  Color _getWallpaperColor(String wallpaper) {
    switch (wallpaper) {
      case 'default':
        return const Color(0xFF6B1FB3);
      case 'gradient':
        return const Color(0xFF8B4FD9);
      case 'nature':
        return const Color(0xFF00D4AA);
      case 'city':
        return const Color(0xFFFFD700);
      case 'abstract':
        return const Color(0xFFFF6B6B);
      default:
        return const Color(0xFF6B1FB3);
    }
  }

  IconData _getWallpaperIcon(String wallpaper) {
    switch (wallpaper) {
      case 'default':
        return Icons.color_lens;
      case 'gradient':
        return Icons.gradient;
      case 'nature':
        return Icons.nature;
      case 'city':
        return Icons.location_city;
      case 'abstract':
        return Icons.brush;
      default:
        return Icons.wallpaper;
    }
  }
}

class ChatData {
  final String id;
  final String name;
  final String avatar;
  final bool isOnline;
  final String? lastSeen;
  final int messageCount;
  final int mediaCount;
  final int sharedMemories;

  ChatData({
    required this.id,
    required this.name,
    required this.avatar,
    required this.isOnline,
    this.lastSeen,
    required this.messageCount,
    required this.mediaCount,
    required this.sharedMemories,
  });
}

class ChatSettingsSection {
  final String title;
  final List<ChatSettingsItem> items;

  ChatSettingsSection({
    required this.title,
    required this.items,
  });
}

class ChatSettingsItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? action;
  final bool hasToggle;
  final bool isDestructive;

  ChatSettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
    this.hasToggle = false,
    this.isDestructive = false,
  });
}