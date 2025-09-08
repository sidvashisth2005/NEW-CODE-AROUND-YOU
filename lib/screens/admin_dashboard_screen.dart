import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../widgets/glass_container.dart';

class AdminDashboardScreen extends StatefulWidget {
  final Function(String, {bool isSubScreen, dynamic data}) onNavigate;

  const AdminDashboardScreen({super.key, required this.onNavigate});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late TabController _tabController;
  
  final List<AdminTab> _tabs = [
    AdminTab(id: 'overview', label: 'Overview', icon: Icons.dashboard),
    AdminTab(id: 'users', label: 'Users', icon: Icons.people),
    AdminTab(id: 'content', label: 'Content', icon: Icons.camera_alt),
    AdminTab(id: 'revenue', label: 'Revenue', icon: Icons.attach_money),
    AdminTab(id: 'moderation', label: 'Moderation', icon: Icons.shield),
    AdminTab(id: 'analytics', label: 'Analytics', icon: Icons.analytics),
  ];

  // Mock admin data
  final AdminStats _adminStats = AdminStats(
    totalUsers: 15847,
    activeUsers: 8934,
    newUsersToday: 234,
    totalMemories: 84562,
    totalTrails: 1247,
    totalMessages: 156789,
    premiumUsers: 2847,
    revenue: 94583.50,
    moderationQueue: 23,
    reportedContent: 8,
  );

  final List<ModerationItem> _moderationQueue = [
    ModerationItem(
      id: '1',
      type: 'memory',
      content: 'Inappropriate photo content',
      reporter: 'User #4523',
      timestamp: '2h ago',
    ),
    ModerationItem(
      id: '2',
      type: 'comment',
      content: 'Spam comment detected',
      reporter: 'System',
      timestamp: '3h ago',
    ),
    ModerationItem(
      id: '3',
      type: 'trail',
      content: 'Copyright violation claim',
      reporter: 'User #7834',
      timestamp: '5h ago',
    ),
    ModerationItem(
      id: '4',
      type: 'profile',
      content: 'Fake profile suspected',
      reporter: 'User #2901',
      timestamp: '6h ago',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _tabController = TabController(length: _tabs.length, vsync: this);
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _tabController.dispose();
    super.dispose();
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
            body: SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(themeProvider),
                  
                  // Tab navigation
                  _buildTabNavigation(themeProvider),
                  
                  // Content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOverviewTab(themeProvider),
                        _buildUsersTab(themeProvider),
                        _buildContentTab(themeProvider),
                        _buildRevenueTab(themeProvider),
                        _buildModerationTab(themeProvider),
                        _buildAnalyticsTab(themeProvider),
                      ],
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

  Widget _buildHeader(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      themeProvider.hapticFeedback('light');
                      widget.onNavigate('profile');
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: themeProvider.colors.glassBg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: themeProvider.colors.glassBorder,
                        ),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin Dashboard',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: themeProvider.colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'System overview and controls',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: themeProvider.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      themeProvider.hapticFeedback('light');
                      // Refresh data
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: themeProvider.colors.glassBg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: themeProvider.colors.glassBorder,
                        ),
                      ),
                      child: const Icon(Icons.refresh, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      themeProvider.hapticFeedback('light');
                      // Export data
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: themeProvider.colors.glassBg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: themeProvider.colors.glassBorder,
                        ),
                      ),
                      child: const Icon(Icons.download, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Admin badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6B1FB3), Color(0xFF8B4FD9)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield, size: 16, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Administrator Access',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigation(ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassContainer(
        padding: const EdgeInsets.all(4),
        borderRadius: BorderRadius.circular(20),
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6B1FB3), Color(0xFF8B4FD9)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6B1FB3).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          labelColor: Colors.white,
          unselectedLabelColor: themeProvider.colors.textSecondary,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          tabs: _tabs.map((tab) => Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(tab.icon, size: 16),
                const SizedBox(width: 8),
                Text(tab.label),
              ],
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildOverviewTab(ThemeProvider themeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Key metrics
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                'Total Users',
                _adminStats.totalUsers.toString(),
                Icons.people,
                '+12.5%',
                themeProvider,
              ),
              _buildStatCard(
                'Active Users',
                _adminStats.activeUsers.toString(),
                Icons.trending_up,
                '+8.3%',
                themeProvider,
              ),
              _buildStatCard(
                'Total Memories',
                _adminStats.totalMemories.toString(),
                Icons.camera_alt,
                '+15.2%',
                themeProvider,
              ),
              _buildStatCard(
                'Premium Users',
                _adminStats.premiumUsers.toString(),
                Icons.star,
                '+22.1%',
                themeProvider,
                color: const Color(0xFFFFD700),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Revenue overview
          GlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.attach_money,
                        color: Color(0xFFFFD700),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Monthly Revenue',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: themeProvider.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '\$${(_adminStats.revenue / 1000).toFixed(1)}K',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: themeProvider.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '+28.4% from last month',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF00D4AA),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab(ThemeProvider themeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'New Today',
                  _adminStats.newUsersToday.toString(),
                  Icons.person_add,
                  '+18.2%',
                  themeProvider,
                  color: const Color(0xFF00D4AA),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Premium Rate',
                  '18.5%',
                  Icons.star,
                  '+5.3%',
                  themeProvider,
                  color: const Color(0xFFFFD700),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          GlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Growth Trend',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: themeProvider.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        themeProvider.colors.accent.withOpacity(0.1),
                        themeProvider.colors.accentSecondary.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'User Growth Chart\n(Chart implementation would go here)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentTab(ThemeProvider themeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Trails',
                  _adminStats.totalTrails.toString(),
                  Icons.route,
                  '+9.7%',
                  themeProvider,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Avg/Day',
                  '2,847',
                  Icons.camera_alt,
                  '+12.1%',
                  themeProvider,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          GlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Content Distribution',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: themeProvider.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        themeProvider.colors.accent.withOpacity(0.1),
                        themeProvider.colors.accentSecondary.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Content Distribution Chart\n(Chart implementation would go here)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueTab(ThemeProvider themeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Monthly Revenue',
                  '\$${(_adminStats.revenue / 1000).toFixed(1)}K',
                  Icons.attach_money,
                  '+28.4%',
                  themeProvider,
                  color: const Color(0xFFFFD700),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Conversion Rate',
                  '3.2%',
                  Icons.trending_up,
                  '+15.7%',
                  themeProvider,
                  color: const Color(0xFF00D4AA),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          GlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revenue Breakdown',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: themeProvider.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFFFD700).withOpacity(0.1),
                        const Color(0xFFFFA500).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Revenue Chart\n(Chart implementation would go here)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModerationTab(ThemeProvider themeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Pending Reports',
                  _adminStats.moderationQueue.toString(),
                  Icons.warning,
                  '-12.3%',
                  themeProvider,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Auto-Resolved',
                  '156',
                  Icons.shield,
                  '+34.2%',
                  themeProvider,
                  color: const Color(0xFF00D4AA),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          GlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Moderation Queue',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: themeProvider.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ..._moderationQueue.map((item) => _buildModerationItem(item, themeProvider)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab(ThemeProvider themeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Server Uptime',
                  '99.9%',
                  Icons.trending_up,
                  '+0.1%',
                  themeProvider,
                  color: const Color(0xFF00D4AA),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Response Time',
                  '124ms',
                  Icons.speed,
                  '-8.5%',
                  themeProvider,
                  color: const Color(0xFF00D4AA),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          GlassContainer(
            padding: const EdgeInsets.all(40),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                Icon(
                  Icons.analytics,
                  size: 48,
                  color: themeProvider.colors.accent,
                ),
                const SizedBox(height: 16),
                Text(
                  'Advanced Analytics',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: themeProvider.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Detailed analytics dashboard with custom reports, A/B testing results, and predictive insights.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: themeProvider.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    String change,
    ThemeProvider themeProvider, {
    Color color = const Color(0xFF6B1FB3),
  }) {
    final isPositive = change.startsWith('+');
    
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive 
                      ? const Color(0xFF00D4AA).withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: isPositive ? const Color(0xFF00D4AA) : Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: themeProvider.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: themeProvider.colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModerationItem(ModerationItem item, ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.colors.glassBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeProvider.colors.glassBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getModerationTypeColor(item.type).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getModerationTypeColor(item.type).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        item.type.toUpperCase(),
                        style: TextStyle(
                          color: themeProvider.isDarkMode 
                              ? _getModerationTypeColor(item.type).withOpacity(0.8)
                              : _getModerationTypeColor(item.type),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.timestamp,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: themeProvider.colors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: themeProvider.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Reported by: ${item.reporter}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: themeProvider.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  themeProvider.hapticFeedback('light');
                  // Approve action
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D4AA).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF00D4AA).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    'Approve',
                    style: TextStyle(
                      color: themeProvider.isDarkMode 
                          ? const Color(0xFF00D4AA).withOpacity(0.8)
                          : const Color(0xFF00D4AA),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  themeProvider.hapticFeedback('light');
                  // Remove action
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      color: themeProvider.isDarkMode 
                          ? Colors.red.withOpacity(0.8)
                          : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getModerationTypeColor(String type) {
    switch (type) {
      case 'memory':
        return const Color(0xFF6B1FB3);
      case 'comment':
        return const Color(0xFF00D4AA);
      case 'trail':
        return const Color(0xFF00D4AA);
      case 'profile':
        return const Color(0xFFFFD700);
      default:
        return const Color(0xFF6B1FB3);
    }
  }
}

class AdminTab {
  final String id;
  final String label;
  final IconData icon;

  AdminTab({
    required this.id,
    required this.label,
    required this.icon,
  });
}

class AdminStats {
  final int totalUsers;
  final int activeUsers;
  final int newUsersToday;
  final int totalMemories;
  final int totalTrails;
  final int totalMessages;
  final int premiumUsers;
  final double revenue;
  final int moderationQueue;
  final int reportedContent;

  AdminStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.newUsersToday,
    required this.totalMemories,
    required this.totalTrails,
    required this.totalMessages,
    required this.premiumUsers,
    required this.revenue,
    required this.moderationQueue,
    required this.reportedContent,
  });
}

class ModerationItem {
  final String id;
  final String type;
  final String content;
  final String reporter;
  final String timestamp;

  ModerationItem({
    required this.id,
    required this.type,
    required this.content,
    required this.reporter,
    required this.timestamp,
  });
}