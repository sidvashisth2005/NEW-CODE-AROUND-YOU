import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { 
  ArrowLeft, 
  Bell, 
  BellOff, 
  Heart, 
  MessageCircle, 
  UserPlus, 
  Star, 
  MapPin, 
  Camera, 
  Award, 
  Route, 
  Users, 
  Shield, 
  CheckCircle, 
  X,
  Settings,
  Filter,
  Search,
  MoreVertical,
  Clock,
  Trash2,
  Archive,
  Eye,
  EyeOff
} from 'lucide-react';
import { useTheme } from './ThemeContext';
import { ImageWithFallback } from './figma/ImageWithFallback';

interface Notification {
  id: string;
  type: 'like' | 'comment' | 'follow' | 'mention' | 'memory' | 'trail' | 'achievement' | 'system' | 'security';
  title: string;
  message: string;
  timestamp: Date;
  isRead: boolean;
  isImportant: boolean;
  avatar?: string;
  imageUrl?: string;
  actionData?: {
    memoryId?: string;
    trailId?: string;
    userId?: string;
    achievementId?: string;
  };
  groupCount?: number; // For grouped notifications
}

interface NotificationGroup {
  type: string;
  title: string;
  notifications: Notification[];
  isExpanded: boolean;
}

interface NotificationsScreenProps {
  onNavigate: (screen: string, isSubScreen?: boolean, data?: any) => void;
}

const NotificationsScreen: React.FC<NotificationsScreenProps> = ({ 
  onNavigate 
}) => {
  const { colors, isDarkMode, hapticFeedback, playSound } = useTheme();
  
  // State management
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [filteredNotifications, setFilteredNotifications] = useState<Notification[]>([]);
  const [selectedFilter, setSelectedFilter] = useState<'all' | 'unread' | 'important'>('all');
  const [selectedType, setSelectedType] = useState<string>('all');
  const [isSelectionMode, setIsSelectionMode] = useState(false);
  const [selectedNotifications, setSelectedNotifications] = useState<Set<string>>(new Set());
  const [showFilterMenu, setShowFilterMenu] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [notificationGroups, setNotificationGroups] = useState<NotificationGroup[]>([]);

  // Responsive breakpoints
  const [screenSize, setScreenSize] = useState<'small' | 'medium' | 'large'>('medium');

  useEffect(() => {
    const updateScreenSize = () => {
      const width = window.innerWidth;
      if (width < 380) setScreenSize('small');
      else if (width < 414) setScreenSize('medium');
      else setScreenSize('large');
    };

    updateScreenSize();
    window.addEventListener('resize', updateScreenSize);
    return () => window.removeEventListener('resize', updateScreenSize);
  }, []);

  // Sample notifications
  useEffect(() => {
    const sampleNotifications: Notification[] = [
      {
        id: '1',
        type: 'like',
        title: 'Sarah Chen liked your memory',
        message: 'Coffee Date at Central Perk',
        timestamp: new Date(Date.now() - 300000),
        isRead: false,
        isImportant: false,
        avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b691?w=100',
        imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=400',
        actionData: { memoryId: 'mem1' }
      },
      {
        id: '2',
        type: 'comment',
        title: 'Alex Rivera commented',
        message: 'Amazing shot! The lighting is perfect 📸',
        timestamp: new Date(Date.now() - 900000),
        isRead: false,
        isImportant: false,
        avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
        actionData: { memoryId: 'mem2' }
      },
      {
        id: '3',
        type: 'follow',
        title: 'Emma Wilson started following you',
        message: 'Check out their amazing trail adventures',
        timestamp: new Date(Date.now() - 1800000),
        isRead: false,
        isImportant: false,
        avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
        actionData: { userId: 'emma' }
      },
      {
        id: '4',
        type: 'achievement',
        title: 'Achievement Unlocked!',
        message: 'Memory Master - Created 50 memories',
        timestamp: new Date(Date.now() - 3600000),
        isRead: true,
        isImportant: true,
        actionData: { achievementId: 'memory-master' }
      },
      {
        id: '5',
        type: 'trail',
        title: 'New trail available',
        message: 'Urban Art Discovery Trail - Perfect for weekend exploration',
        timestamp: new Date(Date.now() - 7200000),
        isRead: true,
        isImportant: false,
        imageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=400',
        actionData: { trailId: 'trail1' }
      },
      {
        id: '6',
        type: 'mention',
        title: 'Mike Johnson mentioned you',
        message: 'In Trail Blazers group: "Check out @you\'s amazing photos!"',
        timestamp: new Date(Date.now() - 14400000),
        isRead: true,
        isImportant: false,
        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100'
      },
      {
        id: '7',
        type: 'system',
        title: 'App Update Available',
        message: 'Version 2.1.0 includes new AR features and performance improvements',
        timestamp: new Date(Date.now() - 86400000),
        isRead: true,
        isImportant: true
      },
      {
        id: '8',
        type: 'security',
        title: 'Security Alert',
        message: 'New device signed in from iPhone 15 Pro',
        timestamp: new Date(Date.now() - 172800000),
        isRead: true,
        isImportant: true
      }
    ];
    
    setNotifications(sampleNotifications);
  }, []);

  // Filter notifications
  useEffect(() => {
    let filtered = notifications;
    
    // Apply main filter
    switch (selectedFilter) {
      case 'unread':
        filtered = filtered.filter(n => !n.isRead);
        break;
      case 'important':
        filtered = filtered.filter(n => n.isImportant);
        break;
    }
    
    // Apply type filter
    if (selectedType !== 'all') {
      filtered = filtered.filter(n => n.type === selectedType);
    }
    
    // Apply search
    if (searchQuery) {
      filtered = filtered.filter(n => 
        n.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
        n.message.toLowerCase().includes(searchQuery.toLowerCase())
      );
    }
    
    setFilteredNotifications(filtered);
  }, [notifications, selectedFilter, selectedType, searchQuery]);

  // Responsive sizing
  const getResponsiveValues = () => {
    const base = {
      padding: screenSize === 'small' ? 16 : screenSize === 'medium' ? 20 : 24,
      titleSize: screenSize === 'small' ? 18 : screenSize === 'medium' ? 20 : 22,
      bodySize: screenSize === 'small' ? 14 : screenSize === 'medium' ? 15 : 16,
      metaSize: screenSize === 'small' ? 12 : screenSize === 'medium' ? 13 : 14,
      iconSize: screenSize === 'small' ? 18 : screenSize === 'medium' ? 20 : 22,
      avatarSize: screenSize === 'small' ? 44 : screenSize === 'medium' ? 48 : 52,
      headerHeight: screenSize === 'small' ? 60 : screenSize === 'medium' ? 64 : 68,
    };
    return base;
  };

  const responsive = getResponsiveValues();

  // Event handlers
  const handleBack = () => {
    hapticFeedback?.('light');
    playSound?.('tap');
    onNavigate('profile');
  };

  const handleNotificationPress = (notification: Notification) => {
    // Mark as read
    setNotifications(prev => prev.map(n => 
      n.id === notification.id ? { ...n, isRead: true } : n
    ));
    
    hapticFeedback?.('light');
    playSound?.('tap');
    
    // Navigate based on notification type
    switch (notification.type) {
      case 'like':
      case 'comment':
        if (notification.actionData?.memoryId) {
          onNavigate('memory-detail', true, { id: notification.actionData.memoryId });
        }
        break;
      case 'follow':
        if (notification.actionData?.userId) {
          onNavigate('profile', true, { userId: notification.actionData.userId });
        }
        break;
      case 'trail':
        if (notification.actionData?.trailId) {
          onNavigate('trail-detail', true, { id: notification.actionData.trailId });
        }
        break;
    }
  };

  const handleMarkAllRead = () => {
    setNotifications(prev => prev.map(n => ({ ...n, isRead: true })));
    hapticFeedback?.('success');
    playSound?.('success');
  };

  const handleDeleteSelected = () => {
    setNotifications(prev => prev.filter(n => !selectedNotifications.has(n.id)));
    setSelectedNotifications(new Set());
    setIsSelectionMode(false);
    hapticFeedback?.('success');
  };

  const handleSelectNotification = (id: string) => {
    const newSelected = new Set(selectedNotifications);
    if (newSelected.has(id)) {
      newSelected.delete(id);
    } else {
      newSelected.add(id);
    }
    setSelectedNotifications(newSelected);
    
    if (newSelected.size === 0) {
      setIsSelectionMode(false);
    }
  };

  const getNotificationIcon = (type: string) => {
    const iconMap: { [key: string]: React.ReactNode } = {
      'like': <Heart size={responsive.iconSize - 4} className="text-red-500" />,
      'comment': <MessageCircle size={responsive.iconSize - 4} className="text-blue-500" />,
      'follow': <UserPlus size={responsive.iconSize - 4} className="text-green-500" />,
      'mention': <MessageCircle size={responsive.iconSize - 4} className="text-purple-500" />,
      'memory': <Camera size={responsive.iconSize - 4} className="text-indigo-500" />,
      'trail': <Route size={responsive.iconSize - 4} className="text-orange-500" />,
      'achievement': <Award size={responsive.iconSize - 4} className="text-yellow-500" />,
      'system': <Settings size={responsive.iconSize - 4} className="text-gray-500" />,
      'security': <Shield size={responsive.iconSize - 4} className="text-red-600" />
    };
    
    return iconMap[type] || <Bell size={responsive.iconSize - 4} style={{ color: colors.textSecondary }} />;
  };

  const formatTimestamp = (date: Date) => {
    const now = new Date();
    const diff = now.getTime() - date.getTime();
    const minutes = Math.floor(diff / 60000);
    
    if (minutes < 1) return 'now';
    if (minutes < 60) return `${minutes}m`;
    
    const hours = Math.floor(minutes / 60);
    if (hours < 24) return `${hours}h`;
    
    const days = Math.floor(hours / 24);
    if (days < 7) return `${days}d`;
    
    return date.toLocaleDateString();
  };

  const unreadCount = notifications.filter(n => !n.isRead).length;

  const FilterChip: React.FC<{ 
    id: string; 
    label: string; 
    count?: number; 
    isActive: boolean; 
    onPress: () => void 
  }> = ({ id, label, count, isActive, onPress }) => (
    <motion.button
      whileTap={{ scale: 0.95 }}
      onClick={onPress}
      className={`px-4 py-2 rounded-xl font-semibold transition-all duration-200 ${
        isActive 
          ? 'bg-gradient-to-r from-purple-600 to-purple-500 text-white' 
          : 'border'
      }`}
      style={{ 
        background: isActive ? undefined : colors.glassBackground,
        borderColor: isActive ? undefined : colors.borderMedium,
        color: isActive ? undefined : colors.textSecondary,
        fontSize: responsive.metaSize,
        boxShadow: isActive ? colors.shadowPurple : 'none'
      }}
    >
      {label}
      {count !== undefined && count > 0 && (
        <span className={`ml-2 px-2 py-0.5 rounded-full text-xs ${
          isActive ? 'bg-white/20' : 'bg-purple-100 text-purple-600'
        }`}>
          {count}
        </span>
      )}
    </motion.button>
  );

  const NotificationItem: React.FC<{ notification: Notification; index: number }> = ({ 
    notification, 
    index 
  }) => (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.05 }}
      className={`transition-all duration-200 ${
        isSelectionMode ? 'cursor-pointer' : ''
      } ${
        selectedNotifications.has(notification.id) ? 'ring-2 ring-purple-500' : ''
      }`}
    >
      <div 
        className={`p-4 rounded-2xl border transition-all duration-200 ${
          !notification.isRead ? 'border-purple-500/30' : ''
        }`}
        style={{ 
          background: !notification.isRead 
            ? `${colors.accent}10` 
            : colors.glassBackground,
          borderColor: !notification.isRead 
            ? `${colors.accent}30` 
            : colors.borderMedium,
          boxShadow: !notification.isRead ? colors.shadowPurple : colors.shadowSm
        }}
        onClick={() => {
          if (isSelectionMode) {
            handleSelectNotification(notification.id);
          } else {
            handleNotificationPress(notification);
          }
        }}
      >
        <div className="flex space-x-3">
          {/* Icon or Avatar */}
          <div className="flex-shrink-0">
            {notification.avatar ? (
              <div className="relative">
                <img
                  src={notification.avatar}
                  alt="User"
                  className="rounded-full object-cover"
                  style={{ 
                    width: responsive.avatarSize - 4, 
                    height: responsive.avatarSize - 4 
                  }}
                />
                <div 
                  className="absolute -bottom-1 -right-1 w-6 h-6 rounded-full flex items-center justify-center"
                  style={{ background: colors.glassBackground }}
                >
                  {getNotificationIcon(notification.type)}
                </div>
              </div>
            ) : (
              <div 
                className="w-12 h-12 rounded-full flex items-center justify-center"
                style={{ 
                  background: notification.isImportant 
                    ? `${colors.accent}20` 
                    : colors.inputBackground
                }}
              >
                {getNotificationIcon(notification.type)}
              </div>
            )}
          </div>

          {/* Content */}
          <div className="flex-1 min-w-0">
            <div className="flex items-start justify-between mb-1">
              <h3 
                style={{ 
                  color: colors.textPrimary, 
                  fontSize: responsive.bodySize 
                }}
                className={`font-semibold ${!notification.isRead ? 'text-purple-600' : ''}`}
              >
                {notification.title}
              </h3>
              
              <div className="flex items-center space-x-2 ml-2">
                {notification.isImportant && (
                  <Star size={12} className="text-yellow-500 fill-current" />
                )}
                
                <span 
                  style={{ 
                    color: colors.textSecondary, 
                    fontSize: responsive.metaSize 
                  }}
                  className="font-medium"
                >
                  {formatTimestamp(notification.timestamp)}
                </span>
                
                {!notification.isRead && (
                  <div 
                    className="w-2 h-2 rounded-full"
                    style={{ background: colors.accent }}
                  />
                )}
              </div>
            </div>
            
            <p 
              style={{ 
                color: colors.textSecondary, 
                fontSize: responsive.bodySize 
              }}
              className="leading-relaxed mb-2"
            >
              {notification.message}
            </p>

            {/* Attachment Preview */}
            {notification.imageUrl && (
              <div className="mt-3">
                <ImageWithFallback
                  src={notification.imageUrl}
                  alt="Notification preview"
                  className="w-20 h-20 rounded-xl object-cover"
                />
              </div>
            )}

            {/* Group count */}
            {notification.groupCount && (
              <div className="mt-2">
                <span 
                  style={{ 
                    color: colors.accent, 
                    fontSize: responsive.metaSize 
                  }}
                  className="font-semibold"
                >
                  +{notification.groupCount} more
                </span>
              </div>
            )}
          </div>

          {/* Selection checkbox */}
          {isSelectionMode && (
            <div className="flex-shrink-0">
              <div 
                className={`w-6 h-6 rounded-full border-2 flex items-center justify-center ${
                  selectedNotifications.has(notification.id) 
                    ? 'bg-purple-600 border-purple-600' 
                    : 'border-gray-300'
                }`}
              >
                {selectedNotifications.has(notification.id) && (
                  <CheckCircle size={16} className="text-white" />
                )}
              </div>
            </div>
          )}
        </div>
      </div>
    </motion.div>
  );

  return (
    <div className={`h-screen w-full overflow-hidden bg-gradient-to-br ${colors.background}`}>
      {/* Header */}
      <div 
        className="flex-shrink-0 pt-12 pb-4 border-b backdrop-blur-md"
        style={{ 
          background: `${colors.glassBackground}99`,
          borderColor: colors.borderLight,
          padding: `48px ${responsive.padding}px 16px`
        }}
      >
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <motion.button
              whileTap={{ scale: 0.95 }}
              whileHover={{ scale: 1.05 }}
              onClick={handleBack}
              className="w-10 h-10 rounded-full flex items-center justify-center border"
              style={{ 
                background: colors.glassBackground,
                borderColor: colors.borderMedium
              }}
            >
              <ArrowLeft size={responsive.iconSize} style={{ color: colors.textPrimary }} />
            </motion.button>

            <div>
              <h1 
                style={{ 
                  color: colors.textPrimary, 
                  fontSize: responsive.titleSize 
                }}
                className="font-bold"
              >
                Notifications
              </h1>
              {unreadCount > 0 && (
                <p 
                  style={{ 
                    color: colors.textSecondary, 
                    fontSize: responsive.metaSize 
                  }}
                >
                  {unreadCount} unread
                </p>
              )}
            </div>
          </div>

          <div className="flex items-center space-x-2">
            {isSelectionMode ? (
              <>
                <motion.button
                  whileTap={{ scale: 0.95 }}
                  onClick={handleDeleteSelected}
                  disabled={selectedNotifications.size === 0}
                  className="w-10 h-10 rounded-full flex items-center justify-center border"
                  style={{ 
                    background: colors.glassBackground,
                    borderColor: colors.borderMedium,
                    opacity: selectedNotifications.size === 0 ? 0.5 : 1
                  }}
                >
                  <Trash2 size={responsive.iconSize} className="text-red-500" />
                </motion.button>
                
                <motion.button
                  whileTap={{ scale: 0.95 }}
                  onClick={() => {
                    setIsSelectionMode(false);
                    setSelectedNotifications(new Set());
                  }}
                  className="w-10 h-10 rounded-full flex items-center justify-center border"
                  style={{ 
                    background: colors.glassBackground,
                    borderColor: colors.borderMedium
                  }}
                >
                  <X size={responsive.iconSize} style={{ color: colors.textPrimary }} />
                </motion.button>
              </>
            ) : (
              <>
                <motion.button
                  whileTap={{ scale: 0.95 }}
                  onClick={() => setIsSelectionMode(true)}
                  className="w-10 h-10 rounded-full flex items-center justify-center border"
                  style={{ 
                    background: colors.glassBackground,
                    borderColor: colors.borderMedium
                  }}
                >
                  <Archive size={responsive.iconSize} style={{ color: colors.textPrimary }} />
                </motion.button>

                <motion.button
                  whileTap={{ scale: 0.95 }}
                  onClick={handleMarkAllRead}
                  disabled={unreadCount === 0}
                  className="w-10 h-10 rounded-full flex items-center justify-center border"
                  style={{ 
                    background: colors.glassBackground,
                    borderColor: colors.borderMedium,
                    opacity: unreadCount === 0 ? 0.5 : 1
                  }}
                >
                  <CheckCircle size={responsive.iconSize} style={{ color: colors.textPrimary }} />
                </motion.button>

                <motion.button
                  whileTap={{ scale: 0.95 }}
                  onClick={() => setShowFilterMenu(!showFilterMenu)}
                  className="w-10 h-10 rounded-full flex items-center justify-center border"
                  style={{ 
                    background: showFilterMenu ? colors.accent : colors.glassBackground,
                    borderColor: showFilterMenu ? colors.accent : colors.borderMedium
                  }}
                >
                  <Filter 
                    size={responsive.iconSize} 
                    style={{ color: showFilterMenu ? 'white' : colors.textPrimary }}
                  />
                </motion.button>
              </>
            )}
          </div>
        </div>

        {/* Search Bar */}
        <motion.div
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="mt-4"
        >
          <div 
            className="relative rounded-xl border"
            style={{ 
              background: colors.inputBackground,
              borderColor: colors.borderMedium
            }}
          >
            <Search 
              size={18} 
              className="absolute left-3 top-1/2 transform -translate-y-1/2"
              style={{ color: colors.textSecondary }}
            />
            <input
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Search notifications..."
              className="w-full pl-10 pr-4 py-3 rounded-xl outline-none"
              style={{ 
                background: 'transparent',
                color: colors.textPrimary,
                fontSize: responsive.bodySize
              }}
            />
          </div>
        </motion.div>
      </div>

      {/* Filter Menu */}
      <AnimatePresence>
        {showFilterMenu && (
          <motion.div
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
            className="border-b"
            style={{ 
              background: colors.glassBackground,
              borderColor: colors.borderLight,
              padding: responsive.padding
            }}
          >
            <div className="space-y-4">
              {/* Main Filters */}
              <div className="flex space-x-3 overflow-x-auto scrollbar-hide">
                <FilterChip
                  id="all"
                  label="All"
                  count={notifications.length}
                  isActive={selectedFilter === 'all'}
                  onPress={() => setSelectedFilter('all')}
                />
                <FilterChip
                  id="unread"
                  label="Unread"
                  count={unreadCount}
                  isActive={selectedFilter === 'unread'}
                  onPress={() => setSelectedFilter('unread')}
                />
                <FilterChip
                  id="important"
                  label="Important"
                  count={notifications.filter(n => n.isImportant).length}
                  isActive={selectedFilter === 'important'}
                  onPress={() => setSelectedFilter('important')}
                />
              </div>

              {/* Type Filters */}
              <div className="flex space-x-3 overflow-x-auto scrollbar-hide">
                {['all', 'like', 'comment', 'follow', 'achievement', 'system'].map((type) => (
                  <FilterChip
                    key={type}
                    id={type}
                    label={type.charAt(0).toUpperCase() + type.slice(1)}
                    isActive={selectedType === type}
                    onPress={() => setSelectedType(type)}
                  />
                ))}
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Content */}
      <div className="flex-1 overflow-y-auto scrollbar-hide">
        <div style={{ padding: responsive.padding }}>
          {filteredNotifications.length === 0 ? (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              className="text-center py-20"
            >
              <div 
                className="w-20 h-20 rounded-full mx-auto mb-6 flex items-center justify-center"
                style={{ background: colors.inputBackground }}
              >
                <Bell size={32} style={{ color: colors.textSecondary }} />
              </div>
              
              <h3 
                style={{ 
                  color: colors.textPrimary, 
                  fontSize: responsive.titleSize 
                }}
                className="font-bold mb-2"
              >
                No notifications
              </h3>
              
              <p 
                style={{ 
                  color: colors.textSecondary, 
                  fontSize: responsive.bodySize 
                }}
              >
                {searchQuery 
                  ? 'No notifications match your search'
                  : selectedFilter === 'unread' 
                    ? 'All caught up! No unread notifications'
                    : 'When you get notifications, they\'ll appear here'
                }
              </p>
            </motion.div>
          ) : (
            <div className="space-y-4 pb-20">
              {filteredNotifications.map((notification, index) => (
                <NotificationItem
                  key={notification.id}
                  notification={notification}
                  index={index}
                />
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default NotificationsScreen;