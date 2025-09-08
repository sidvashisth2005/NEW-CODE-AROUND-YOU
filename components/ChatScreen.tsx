import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Search, MessageCircle, Users, Video, Phone, Settings, Plus, Filter, Clock, Star } from 'lucide-react';
import { useTheme } from './ThemeContext';

interface ChatScreenProps {
  onNavigate: (screen: string, isSubScreen?: boolean, data?: any) => void;
}

const ChatScreen: React.FC<ChatScreenProps> = ({ onNavigate }) => {
  const { colors, isDarkMode, hapticFeedback, playSound } = useTheme();
  const [searchQuery, setSearchQuery] = useState('');
  const [activeFilter, setActiveFilter] = useState(0);

  const filters = [
    { name: 'All', icon: Filter },
    { name: 'Recent', icon: Clock },
    { name: 'Groups', icon: Users },
    { name: 'Favorites', icon: Star }
  ];

  const chats = [
    {
      id: 1,
      name: "Sarah Chen",
      lastMessage: "Just discovered an amazing coffee spot! You should check it out 😍",
      time: "2m ago",
      unread: 2,
      avatar: "S",
      isOnline: true,
      type: "individual",
      isFavorite: true,
      isRecent: true
    },
    {
      id: 2,
      name: "SF Explorers",
      lastMessage: "Mike: Who's up for the new trail this weekend?",
      time: "15m ago",
      unread: 5,
      avatar: "🌁",
      isOnline: false,
      type: "group",
      memberCount: 12,
      isFavorite: false,
      isRecent: true
    },
    {
      id: 3,
      name: "Alex Rivera",
      lastMessage: "That street art trail was incredible! Thanks for sharing",
      time: "1h ago",
      unread: 0,
      avatar: "A",
      isOnline: true,
      type: "individual",
      isFavorite: true,
      isRecent: true
    },
    {
      id: 4,
      name: "Photography Club",
      lastMessage: "Emma: Golden hour shots from yesterday's trail 📸",
      time: "3h ago",
      unread: 8,
      avatar: "📸",
      isOnline: false,
      type: "group",
      memberCount: 24,
      isFavorite: false,
      isRecent: false
    },
    {
      id: 5,
      name: "Mike Johnson",
      lastMessage: "The new memory I left at the bridge - did you see it?",
      time: "1d ago",
      unread: 0,
      avatar: "M",
      isOnline: false,
      type: "individual",
      isFavorite: false,
      isRecent: false
    },
    {
      id: 6,
      name: "Food Lovers SF",
      lastMessage: "David: Best tacos in Mission District! Trail updated 🌮",
      time: "2d ago",
      unread: 3,
      avatar: "🍽️",
      isOnline: false,
      type: "group",
      memberCount: 45,
      isFavorite: true,
      isRecent: false
    }
  ];

  const filteredChats = chats.filter(chat => {
    const matchesSearch = chat.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         chat.lastMessage.toLowerCase().includes(searchQuery.toLowerCase());
    
    switch (activeFilter) {
      case 1: // Recent
        return matchesSearch && chat.isRecent;
      case 2: // Groups
        return matchesSearch && chat.type === 'group';
      case 3: // Favorites
        return matchesSearch && chat.isFavorite;
      default: // All
        return matchesSearch;
    }
  });

  const handleChatSelect = (chat: any) => {
    hapticFeedback('light');
    playSound('tap');
    onNavigate('chat-interface', true, chat);
  };

  const handleFilterChange = (index: number) => {
    setActiveFilter(index);
    hapticFeedback('light');
    playSound('tap');
  };

  return (
    <div className={`h-full w-full flex flex-col bg-gradient-to-br ${colors.background}`}>
      {/* Enhanced Header */}
      <div className="flex-shrink-0 pt-12 px-6 pb-4">
        <motion.div
          initial={{ opacity: 0, y: -30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, type: "spring", bounce: 0.3 }}
        >
          <div className="flex items-center justify-between mb-6">
            <div>
              <h1 className={`text-2xl font-bold ${colors.textPrimary}`}>Chat</h1>
              <p className={`text-sm ${colors.textSecondary}`}>Connect with fellow explorers</p>
            </div>
            
            <div className="flex items-center space-x-3">
              <motion.button
                whileTap={{ scale: 0.9 }}
                whileHover={{ scale: 1.05 }}
                onClick={() => onNavigate('communities', true)}
                className={`w-10 h-10 rounded-full glass-card flex items-center justify-center border ${colors.borderMedium} transition-all duration-200`}
                style={{ 
                  background: colors.glassBackground,
                  boxShadow: colors.shadowMd
                }}
              >
                <Users size={18} className={colors.textPrimary} />
              </motion.button>
              
              <motion.button
                whileTap={{ scale: 0.9 }}
                whileHover={{ scale: 1.05 }}
                onClick={() => {
                  hapticFeedback('medium');
                  playSound('tap');
                }}
                className={`w-10 h-10 rounded-full bg-gradient-to-r from-purple-600 to-purple-500 flex items-center justify-center`}
                style={{ 
                  boxShadow: colors.shadowPurple
                }}
              >
                <Plus size={18} className="text-white" />
              </motion.button>
            </div>
          </div>

          {/* Enhanced Search Bar */}
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ delay: 0.1, duration: 0.5, type: "spring" }}
            className={`glass-card rounded-[20px] p-4 backdrop-blur-xl border ${colors.borderMedium} mb-4`}
            style={{ 
              background: colors.glassBackground,
              boxShadow: colors.shadowMd
            }}
          >
            <div className="flex items-center space-x-3">
              <Search size={20} className={colors.accent} />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search conversations..."
                className={`flex-1 bg-transparent ${colors.textPrimary} placeholder-gray-500 focus:outline-none`}
              />
            </div>
          </motion.div>

          {/* Enhanced Filter Buttons */}
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.2, duration: 0.5, type: "spring" }}
            className="flex space-x-3 overflow-x-auto pb-2 scrollbar-hide"
          >
            {filters.map((filter, index) => {
              const Icon = filter.icon;
              const isActive = activeFilter === index;
              
              return (
                <motion.button
                  key={index}
                  initial={{ opacity: 0, scale: 0.8 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: index * 0.05, duration: 0.4, type: "spring" }}
                  whileTap={{ scale: 0.95 }}
                  whileHover={{ scale: 1.05 }}
                  onClick={() => handleFilterChange(index)}
                  className={`flex-shrink-0 glass-card px-4 py-2 rounded-full backdrop-blur-md transition-all duration-300 border flex items-center space-x-2 ${
                    isActive 
                      ? colors.filterActive
                      : colors.filterInactive
                  }`}
                  style={{ 
                    boxShadow: isActive ? colors.shadowPurple : colors.shadowSm
                  }}
                >
                  {Icon && <Icon size={14} className={isActive ? 'text-white' : 'inherit'} />}
                  <span className={`font-medium text-sm ${isActive ? 'text-white' : 'inherit'}`}>
                    {filter.name}
                  </span>
                </motion.button>
              );
            })}
          </motion.div>
        </motion.div>
      </div>

      {/* Enhanced Chat List */}
      <div className="flex-1 px-6 pb-6 overflow-y-auto">
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.3, duration: 0.5 }}
          className="space-y-3"
        >
          {filteredChats.map((chat, index) => (
            <motion.div
              key={chat.id}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: index * 0.05, duration: 0.4, type: "spring" }}
              whileTap={{ scale: 0.98 }}
              whileHover={{ scale: 1.02 }}
              onClick={() => handleChatSelect(chat)}
              className={`w-full glass-card rounded-[20px] p-4 backdrop-blur-xl border ${colors.borderMedium} text-left transition-all duration-300 hover:scale-[1.02] cursor-pointer`}
              style={{ 
                background: colors.glassBackground,
                boxShadow: colors.shadowMd
              }}
            >
              <div className="flex items-center space-x-4">
                {/* Enhanced Avatar */}
                <div className="relative flex-shrink-0">
                  <div 
                    className={`w-12 h-12 rounded-full flex items-center justify-center ${
                      chat.type === 'group' 
                        ? 'bg-gradient-to-r from-purple-500 to-blue-500' 
                        : 'bg-gradient-to-r from-purple-500 to-pink-500'
                    }`}
                    style={{ 
                      boxShadow: colors.shadowSm
                    }}
                  >
                    <span className="text-white font-semibold">
                      {chat.type === 'group' ? chat.avatar : chat.avatar}
                    </span>
                  </div>
                  
                  {chat.isOnline && chat.type === 'individual' && (
                    <div className="absolute -bottom-1 -right-1 w-4 h-4 bg-green-400 rounded-full border-2 border-white"
                         style={{ boxShadow: colors.shadowSm }}></div>
                  )}
                  
                  {chat.unread > 0 && (
                    <motion.div
                      initial={{ scale: 0 }}
                      animate={{ scale: 1 }}
                      transition={{ type: "spring", bounce: 0.5 }}
                      className={`absolute -top-2 -right-2 min-w-5 h-5 bg-gradient-to-r from-red-500 to-red-400 rounded-full flex items-center justify-center px-1`}
                      style={{ 
                        boxShadow: colors.shadowSm
                      }}
                    >
                      <span className="text-white text-xs font-bold">
                        {chat.unread > 9 ? '9+' : chat.unread}
                      </span>
                    </motion.div>
                  )}
                </div>

                {/* Chat Info */}
                <div className="flex-1 min-w-0">
                  <div className="flex items-center justify-between mb-1">
                    <h3 className={`font-semibold ${colors.textPrimary} truncate`}>
                      {chat.name}
                      {chat.type === 'group' && (
                        <span className={`ml-2 text-xs ${colors.textSecondary}`}>
                          ({chat.memberCount} members)
                        </span>
                      )}
                    </h3>
                    <div className="flex items-center space-x-2 flex-shrink-0">
                      {chat.isFavorite && (
                        <Star size={12} className="text-yellow-400" />
                      )}
                      <span className={`text-xs ${colors.textSecondary}`}>{chat.time}</span>
                    </div>
                  </div>
                  
                  <p className={`text-sm ${chat.unread > 0 ? colors.textPrimary : colors.textSecondary} truncate`}>
                    {chat.lastMessage}
                  </p>
                </div>

                {/* Action Buttons */}
                <div className="flex items-center space-x-2 flex-shrink-0">
                  {chat.type === 'individual' && (
                    <>
                      <motion.button
                        whileTap={{ scale: 0.9 }}
                        onClick={(e) => {
                          e.stopPropagation();
                          hapticFeedback('light');
                          // Handle video call
                        }}
                        className={`w-8 h-8 rounded-full glass-card flex items-center justify-center border ${colors.borderLight}`}
                        style={{ 
                          background: colors.glassBackground,
                          boxShadow: colors.shadowSm
                        }}
                      >
                        <Video size={14} className={colors.textSecondary} />
                      </motion.button>
                      
                      <motion.button
                        whileTap={{ scale: 0.9 }}
                        onClick={(e) => {
                          e.stopPropagation();
                          hapticFeedback('light');
                          // Handle voice call
                        }}
                        className={`w-8 h-8 rounded-full glass-card flex items-center justify-center border ${colors.borderLight}`}
                        style={{ 
                          background: colors.glassBackground,
                          boxShadow: colors.shadowSm
                        }}
                      >
                        <Phone size={14} className={colors.textSecondary} />
                      </motion.button>
                    </>
                  )}
                  
                  <motion.button
                    whileTap={{ scale: 0.9 }}
                    onClick={(e) => {
                      e.stopPropagation();
                      hapticFeedback('light');
                      onNavigate('chat-settings', true, chat);
                    }}
                    className={`w-8 h-8 rounded-full glass-card flex items-center justify-center border ${colors.borderLight}`}
                    style={{ 
                      background: colors.glassBackground,
                      boxShadow: colors.shadowSm
                    }}
                  >
                    <Settings size={14} className={colors.textSecondary} />
                  </motion.button>
                </div>
              </div>
            </motion.div>
          ))}
        </motion.div>

        {/* Enhanced Empty State */}
        {filteredChats.length === 0 && (
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.5, type: "spring" }}
            className={`text-center py-12 glass-card rounded-[24px] backdrop-blur-xl border ${colors.borderMedium}`}
            style={{ 
              background: colors.glassBackground,
              boxShadow: colors.shadowMd
            }}
          >
            <div 
              className={`w-16 h-16 rounded-full bg-gradient-to-r from-purple-600 to-purple-500 flex items-center justify-center mx-auto mb-4`}
              style={{ 
                boxShadow: colors.shadowMd
              }}
            >
              <MessageCircle size={24} className="text-white" />
            </div>
            <h3 className={`font-bold text-lg ${colors.textPrimary} mb-2`}>No conversations found</h3>
            <p className={`${colors.textSecondary}`}>Try adjusting your search or start a new chat</p>
          </motion.div>
        )}
      </div>
    </div>
  );
};

export default ChatScreen;