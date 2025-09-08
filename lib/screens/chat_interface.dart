import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../widgets/glass_container.dart';

class ChatInterface extends StatefulWidget {
  final dynamic chat;
  final VoidCallback onBack;
  final Function(String, {bool isSubScreen, dynamic data}) onNavigate;

  const ChatInterface({
    super.key,
    required this.chat,
    required this.onBack,
    required this.onNavigate,
  });

  @override
  State<ChatInterface> createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<ChatInterface>
    with TickerProviderStateMixin {
  late AnimationController _messageController;
  late AnimationController _inputController;
  late TextEditingController _textController;
  late ScrollController _scrollController;
  
  bool _isTyping = false;
  
  // Mock messages
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      senderId: 'other',
      senderName: 'Sarah Chen',
      message: 'Hey! How are you doing? 👋',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isMe: false,
    ),
    ChatMessage(
      id: '2',
      senderId: 'me',
      senderName: 'Me',
      message: 'Hi Sarah! I\'m great, thanks for asking. Just explored a new trail today!',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
      isMe: true,
    ),
    ChatMessage(
      id: '3',
      senderId: 'other',
      senderName: 'Sarah Chen',
      message: 'That sounds amazing! Which trail did you explore?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
      isMe: false,
    ),
    ChatMessage(
      id: '4',
      senderId: 'me',
      senderName: 'Me',
      message: 'The one near Golden Gate Park! The views were incredible 🌅',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      isMe: true,
    ),
    ChatMessage(
      id: '5',
      senderId: 'other',
      senderName: 'Sarah Chen',
      message: 'I love that trail! Did you see the new memory I shared from there yesterday?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isMe: false,
    ),
    ChatMessage(
      id: '6',
      senderId: 'me',
      senderName: 'Me',
      message: 'Yes, I saw it! The sunset photo was absolutely stunning 📸',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      isMe: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _messageController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _inputController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _textController = TextEditingController();
    _scrollController = ScrollController();
    
    _messageController.forward();
    _inputController.forward();
    
    // Auto scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _inputController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('light');
    
    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'me',
        senderName: 'Me',
        message: text,
        timestamp: DateTime.now(),
        isMe: true,
      ));
      _textController.clear();
    });
    
    // Auto scroll to bottom after sending
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });
    
    // Simulate other user typing
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });
      }
    });
    
    // Simulate response
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            senderId: 'other',
            senderName: widget.chat?.name ?? 'Other User',
            message: 'Thanks for sharing! 😊',
            timestamp: DateTime.now(),
            isMe: false,
          ));
        });
        _scrollToBottom();
      }
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
            appBar: _buildAppBar(themeProvider),
            body: Column(
              children: [
                // Messages
                Expanded(
                  child: _buildMessagesList(themeProvider),
                ),
                
                // Typing indicator
                if (_isTyping) _buildTypingIndicator(themeProvider),
                
                // Input area
                _buildInputArea(themeProvider),
              ],
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
          widget.onBack();
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
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              widget.chat?.avatar ?? 'https://via.placeholder.com/150',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chat?.name ?? 'Chat',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: themeProvider.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.chat?.isOnline == true ? 'Online' : 'Last seen recently',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: themeProvider.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {
            themeProvider.hapticFeedback('light');
            widget.onNavigate('chat-settings', data: widget.chat);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: themeProvider.colors.glassBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: themeProvider.colors.glassBorder,
              ),
            ),
            child: const Icon(Icons.more_vert, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildMessagesList(ThemeProvider themeProvider) {
    return AnimatedBuilder(
      animation: _messageController,
      builder: (context, child) {
        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            final message = _messages[index];
            final delay = index * 0.05;
            final animation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: _messageController,
              curve: Interval(
                delay,
                (delay + 0.3).clamp(0.0, 1.0),
                curve: Curves.easeOut,
              ),
            ));
            
            return Transform.translate(
              offset: Offset(
                message.isMe ? 50 * (1 - animation.value) : -50 * (1 - animation.value),
                0,
              ),
              child: Opacity(
                opacity: animation.value,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildMessageBubble(message, themeProvider),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message, ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!message.isMe) ...[
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              widget.chat?.avatar ?? 'https://via.placeholder.com/150',
            ),
          ),
          const SizedBox(width: 8),
        ],
        
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: message.isMe 
                  ? themeProvider.colors.accent
                  : themeProvider.colors.glassBg,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: message.isMe ? const Radius.circular(16) : const Radius.circular(4),
                bottomRight: message.isMe ? const Radius.circular(4) : const Radius.circular(16),
              ),
              border: message.isMe 
                  ? null
                  : Border.all(color: themeProvider.colors.glassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: message.isMe 
                        ? Colors.white
                        : themeProvider.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: message.isMe 
                        ? Colors.white.withOpacity(0.7)
                        : themeProvider.colors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        if (message.isMe) ...[
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 16,
            backgroundColor: themeProvider.colors.accent,
            child: const Icon(
              Icons.person,
              size: 18,
              color: Colors.white,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTypingIndicator(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              widget.chat?.avatar ?? 'https://via.placeholder.com/150',
            ),
          ),
          const SizedBox(width: 8),
          GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            borderRadius: BorderRadius.circular(16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Typing',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: themeProvider.colors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 20,
                  height: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(3, (index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 600 + (index * 100)),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: themeProvider.colors.textSecondary,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(ThemeProvider themeProvider) {
    return AnimatedBuilder(
      animation: _inputController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 100 * (1 - _inputController.value)),
          child: Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: 16 + MediaQuery.of(context).padding.bottom,
            ),
            child: Row(
              children: [
                // Attachment button
                GestureDetector(
                  onTap: () {
                    themeProvider.hapticFeedback('light');
                    // Show attachment options
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: themeProvider.colors.glassBg,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: themeProvider.colors.glassBorder,
                      ),
                    ),
                    child: const Icon(Icons.add, size: 20),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Text input
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeProvider.colors.glassBg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: themeProvider.colors.glassBorder,
                      ),
                    ),
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: themeProvider.colors.textTertiary,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: themeProvider.colors.textPrimary,
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Send button
                GestureDetector(
                  onTap: _sendMessage,
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
                      boxShadow: themeProvider.colors.shadowPurple,
                    ),
                    child: const Icon(
                      Icons.send,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime timestamp) {
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

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    required this.isMe,
  });
}