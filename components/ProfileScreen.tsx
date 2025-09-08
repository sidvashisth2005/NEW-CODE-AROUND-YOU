import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Settings, Edit, MapPin, Calendar, Star, Trophy, Users, Heart, MessageCircle, Camera, Share, Crown, Zap, Target, Shield } from 'lucide-react';
import { ScrollArea } from './ui/scroll-area';
import { useTheme } from './ThemeContext';

interface ProfileScreenProps {
  onNavigate: (screen: string, isSubScreen?: boolean, data?: any) => void;
}

const ProfileScreen: React.FC<ProfileScreenProps> = ({ onNavigate }) => {
  const { colors, hapticFeedback, playSound } = useTheme();
  const [activeTab, setActiveTab] = useState('overview');

  // Mock admin check - in real app this would come from user authentication/backend
  // You can replace this with your actual admin user check logic
  const isAdminUser = () => {
    // Example: Check if current user is admin based on your backend logic
    // For demo purposes, we'll say user 'Alex Rivera' is an admin
    const currentUser = 'Alex Rivera'; // This would come from your auth context
    const adminUsers = ['Alex Rivera', 'admin@aroundyou.app', 'superadmin']; // List from your backend
    return adminUsers.includes(currentUser);
  };

  const userStats = {
    memoriesCreated: 42,
    memoriesDiscovered: 128,
    likes: 894,
    followers: 156,
    following: 89,
    joinDate: 'March 2024'
  };

  const achievements = [
    {
      id: 1,
      title: 'First Memory',
      description: 'Created your first AR memory',
      icon: Star,
      earned: true,
      progress: 100,
      rarity: 'common',
      color: 'from-blue-500 to-blue-600'
    },
    {
      id: 2,
      title: 'Explorer',
      description: 'Discovered 50+ memories',
      icon: MapPin,
      earned: true,
      progress: 100,
      rarity: 'rare',
      color: 'from-green-500 to-green-600'
    },
    {
      id: 3,
      title: 'Social Butterfly',
      description: 'Connected with 100+ users',
      icon: Users,
      earned: true,
      progress: 100,
      rarity: 'epic',
      color: 'from-purple-500 to-purple-600'
    },
    {
      id: 4,
      title: 'Memory Master',
      description: 'Create 100 memories',
      icon: Crown,
      earned: false,
      progress: 42,
      rarity: 'legendary',
      color: 'from-yellow-500 to-yellow-600'
    },
    {
      id: 5,
      title: 'Viral Creator',
      description: 'Get 1000+ likes on a memory',
      icon: Zap,
      earned: false,
      progress: 89,
      rarity: 'legendary',
      color: 'from-red-500 to-red-600'
    },
    {
      id: 6,
      title: 'Area Expert',
      description: 'Most memories in a location',
      icon: Target,
      earned: true,
      progress: 100,
      rarity: 'epic',
      color: 'from-indigo-500 to-indigo-600'
    }
  ];

  const recentMemories = [
    {
      id: 1,
      title: 'Golden Gate Sunset',
      description: 'Captured this magical moment during golden hour',
      type: 'photo',
      likes: 24,
      comments: 8,
      time: '2h ago',
      location: 'Golden Gate Bridge'
    },
    {
      id: 2,
      title: 'Street Art Discovery',
      description: 'Found this incredible mural in the Mission',
      type: 'video',
      likes: 18,
      comments: 5,
      time: '1d ago',
      location: 'Mission District'
    },
    {
      id: 3,
      title: 'Coffee Shop Vibes',
      description: 'Perfect morning coffee spot',
      type: 'text',
      likes: 12,
      comments: 3,
      time: '2d ago',
      location: 'SOMA'
    }
  ];

  const tabs = [
    { id: 'overview', label: 'Overview', icon: Star },
    { id: 'achievements', label: 'Achievements', icon: Trophy },
    { id: 'memories', label: 'Memories', icon: Camera }
  ];

  const CircularProgress = ({ progress, size = 60, strokeWidth = 4, children }: {
    progress: number;
    size?: number;
    strokeWidth?: number;
    children: React.ReactNode;
  }) => {
    const radius = (size - strokeWidth) / 2;
    const circumference = radius * 2 * Math.PI;
    const offset = circumference - (progress / 100) * circumference;

    return (
      <div className="relative inline-flex items-center justify-center">
        <svg
          width={size}
          height={size}
          className="transform -rotate-90"
        >
          {/* Background circle */}
          <circle
            cx={size / 2}
            cy={size / 2}
            r={radius}
            stroke="rgba(255, 255, 255, 0.1)"
            strokeWidth={strokeWidth}
            fill="transparent"
          />
          {/* Progress circle */}
          <motion.circle
            cx={size / 2}
            cy={size / 2}
            r={radius}
            stroke={progress === 100 ? "#FFD700" : "#6B1FB3"}
            strokeWidth={strokeWidth}
            fill="transparent"
            strokeDasharray={circumference}
            strokeDashoffset={offset}
            strokeLinecap="round"
            initial={{ strokeDashoffset: circumference }}
            animate={{ strokeDashoffset: offset }}
            transition={{ duration: 1, delay: 0.5 }}
          />
        </svg>
        <div className="absolute inset-0 flex items-center justify-center">
          {children}
        </div>
        {progress === 100 && (
          <motion.div
            initial={{ scale: 0, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ delay: 1.5, duration: 0.3 }}
            className="absolute -top-1 -right-1 w-5 h-5 bg-gradient-to-r from-yellow-400 to-yellow-300 rounded-full flex items-center justify-center"
          >
            <Star size={12} className="text-black" />
          </motion.div>
        )}
      </div>
    );
  };

  const handleMemoryClick = (memory: any) => {
    onNavigate('memory-detail', true, memory);
  };

  const renderTabContent = () => {
    switch (activeTab) {
      case 'overview':
        return (
          <div className="space-y-6">
            {/* Stats Grid */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2, duration: 0.6 }}
              className="grid grid-cols-2 gap-4"
            >
              {[
                { label: 'Memories', value: userStats.memoriesCreated, icon: Camera },
                { label: 'Discovered', value: userStats.memoriesDiscovered, icon: MapPin },
                { label: 'Likes', value: userStats.likes, icon: Heart },
                { label: 'Followers', value: userStats.followers, icon: Users }
              ].map((stat, index) => {
                const Icon = stat.icon;
                return (
                  <motion.div
                    key={stat.label}
                    initial={{ opacity: 0, scale: 0.9 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ delay: 0.3 + index * 0.1, duration: 0.4 }}
                    className={`glass-card rounded-[20px] p-4 backdrop-blur-xl text-center border ${colors.glassBorder}`}
                    style={{ 
                      boxShadow: '0 8px 32px rgba(107, 31, 179, 0.2)' 
                    }}
                  >
                    <Icon size={24} className={`mx-auto mb-2 ${colors.accent}`} />
                    <p className={`text-2xl font-bold ${colors.textPrimary}`}>{stat.value}</p>
                    <p className={`text-sm ${colors.textSecondary}`}>{stat.label}</p>
                  </motion.div>
                );
              })}
            </motion.div>

            {/* Recent Activity */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.6, duration: 0.6 }}
              className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.glassBorder}`}
              style={{ 
                boxShadow: '0 8px 32px rgba(107, 31, 179, 0.2)' 
              }}
            >
              <h3 className={`font-semibold mb-4 flex items-center ${colors.textPrimary}`}>
                <Star size={20} className={`mr-2 ${colors.accent}`} />
                Recent Memories
              </h3>
              <div className="space-y-3">
                {recentMemories.map((memory, index) => (
                  <motion.button
                    key={memory.id}
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: 0.7 + index * 0.1, duration: 0.4 }}
                    whileTap={{ scale: 0.98 }}
                    onClick={() => handleMemoryClick(memory)}
                    className={`w-full flex items-center justify-between p-3 glass-card rounded-[16px] backdrop-blur-md border ${colors.glassBorder} hover:border-white/40 transition-all duration-200`}
                  >
                    <div className="text-left">
                      <p className={`font-medium ${colors.textPrimary}`}>{memory.title}</p>
                      <p className={`text-sm capitalize ${colors.textSecondary}`}>{memory.type} • {memory.time}</p>
                    </div>
                    <div className={`flex items-center space-x-3 text-sm ${colors.textSecondary}`}>
                      <div className="flex items-center space-x-1">
                        <Heart size={14} />
                        <span>{memory.likes}</span>
                      </div>
                      <div className="flex items-center space-x-1">
                        <MessageCircle size={14} />
                        <span>{memory.comments}</span>
                      </div>
                    </div>
                  </motion.button>
                ))}
              </div>
            </motion.div>
          </div>
        );

      case 'achievements':
        return (
          <div className="space-y-4">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2, duration: 0.6 }}
              className={`glass-card rounded-[20px] p-4 backdrop-blur-xl text-center border ${colors.glassBorder}`}
              style={{ 
                boxShadow: '0 8px 32px rgba(107, 31, 179, 0.2)' 
              }}
            >
              <Trophy size={32} className="text-yellow-400 mx-auto mb-2" />
              <p className={`font-semibold ${colors.textPrimary}`}>Achievement Progress</p>
              <p className={`text-sm ${colors.textSecondary}`}>
                {achievements.filter(a => a.earned).length} of {achievements.length} unlocked
              </p>
            </motion.div>

            <div className="grid grid-cols-2 gap-4">
              {achievements.map((achievement, index) => {
                const Icon = achievement.icon;
                return (
                  <motion.div
                    key={achievement.id}
                    initial={{ opacity: 0, scale: 0.9 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ delay: 0.3 + index * 0.1, duration: 0.4 }}
                    className={`glass-card rounded-[20px] p-4 backdrop-blur-xl text-center transition-all duration-300 relative border ${colors.glassBorder} ${
                      achievement.earned ? '' : ''
                    }`}
                    style={{ 
                      boxShadow: achievement.earned ? '0 8px 32px rgba(107, 31, 179, 0.2)' : '0 4px 16px rgba(107, 31, 179, 0.1)'
                    }}
                  >
                    {/* Circular Progress around achievement */}
                    <div className="flex justify-center mb-3">
                      <CircularProgress progress={achievement.progress} size={56}>
                        <div className={`w-10 h-10 bg-gradient-to-r ${achievement.color} rounded-full flex items-center justify-center ${
                          !achievement.earned ? 'grayscale' : ''
                        }`}>
                          <Icon size={20} className="text-white" />
                        </div>
                      </CircularProgress>
                    </div>
                    
                    <h4 className={`font-semibold text-sm mb-1 ${colors.textPrimary}`}>{achievement.title}</h4>
                    <p className={`text-xs mb-2 ${colors.textSecondary}`}>{achievement.description}</p>
                    
                    <div className="flex items-center justify-between">
                      <div className={`px-2 py-1 rounded-full text-xs font-medium ${
                        achievement.rarity === 'common' ? 'bg-gray-600 text-gray-200' :
                        achievement.rarity === 'rare' ? 'bg-green-600 text-green-200' :
                        achievement.rarity === 'epic' ? 'bg-purple-600 text-purple-200' :
                        'bg-yellow-600 text-yellow-200'
                      }`}>
                        {achievement.rarity}
                      </div>
                      <span className={`text-xs ${colors.textSecondary}`}>{achievement.progress}%</span>
                    </div>
                  </motion.div>
                );
              })}
            </div>
          </div>
        );

      case 'memories':
        return (
          <div className="space-y-4">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2, duration: 0.6 }}
            >
              <ScrollArea orientation="horizontal" className="w-full">
                <div className="flex space-x-3 pb-2">
                  {['All', 'Photos', 'Videos', 'Audio', 'Text'].map((filter, index) => (
                    <motion.button
                      key={filter}
                      whileTap={{ scale: 0.95 }}
                      className={`flex-shrink-0 glass-card px-4 py-2 rounded-full backdrop-blur-md transition-all duration-300 border ${
                        index === 0 
                          ? 'bg-purple-600/50 border-purple-500/30' 
                          : `${colors.glassBorder} hover:border-white/40`
                      }`}
                      style={index === 0 ? { 
                        boxShadow: '0 4px 12px rgba(107, 31, 179, 0.3)' 
                      } : {}}
                    >
                      <span className={`font-medium text-sm ${index === 0 ? colors.textPrimary : colors.textSecondary}`}>
                        {filter}
                      </span>
                    </motion.button>
                  ))}
                </div>
              </ScrollArea>
            </motion.div>

            <div className="grid grid-cols-2 gap-4">
              {recentMemories.concat(Array.from({ length: 3 }, (_, i) => ({
                id: i + 10,
                title: `Memory ${i + 4}`,
                description: 'Another great memory',
                type: 'photo',
                likes: Math.floor(Math.random() * 50),
                comments: Math.floor(Math.random() * 10),
                time: `${i + 3}d ago`,
                location: 'San Francisco'
              }))).map((memory, index) => (
                <motion.button
                  key={memory.id}
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: 0.3 + index * 0.05, duration: 0.4 }}
                  whileTap={{ scale: 0.95 }}
                  onClick={() => handleMemoryClick(memory)}
                  className={`glass-card rounded-[20px] aspect-square backdrop-blur-xl overflow-hidden relative group cursor-pointer border ${colors.glassBorder} hover:border-white/40 transition-all duration-200`}
                  style={{ 
                    boxShadow: '0 8px 32px rgba(107, 31, 179, 0.1)' 
                  }}
                >
                  <div className="absolute inset-0 bg-gradient-to-br from-purple-600/50 to-blue-600/50"></div>
                  <div className="absolute inset-0 flex items-center justify-center">
                    <Camera size={32} className="text-white/60" />
                  </div>
                  <div className="absolute bottom-0 left-0 right-0 p-3 bg-gradient-to-t from-black/60 to-transparent">
                    <p className={`text-sm font-medium ${colors.textPrimary}`}>{memory.title}</p>
                    <p className={`text-xs ${colors.textSecondary}`}>{memory.time}</p>
                  </div>
                </motion.button>
              ))}
            </div>
          </div>
        );

      default:
        return null;
    }
  };

  return (
    <div className={`h-full w-full bg-gradient-to-br ${colors.background} flex flex-col`}>
      {/* Header - Fixed at top */}
      <div className="flex-shrink-0 pt-12 px-6 pb-4 bg-gradient-to-b from-black/30 via-black/10 to-transparent">
        <motion.div
          initial={{ opacity: 0, y: -30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4 }}
        >
          <div className="flex items-center justify-between mb-6">
            <h1 className={`text-2xl font-bold ${colors.textPrimary}`}>Profile</h1>
            
            <div className="flex items-center space-x-3">
              {/* Admin Dashboard Button - Only visible to admin users */}
              {isAdminUser() && (
                <motion.button
                  initial={{ opacity: 0, scale: 0.8 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ duration: 0.3 }}
                  whileTap={{ scale: 0.95 }}
                  whileHover={{ scale: 1.05 }}
                  onClick={() => {
                    hapticFeedback('medium');
                    playSound('tap');
                    onNavigate('admin-dashboard', true);
                  }}
                  className={`w-10 h-10 bg-gradient-to-r from-purple-600 to-purple-500 rounded-full flex items-center justify-center border border-purple-400/30 transition-all duration-200 relative`}
                  style={{ 
                    boxShadow: '0 4px 16px rgba(107, 31, 179, 0.4)' 
                  }}
                >
                  <Shield size={20} className="text-white" />
                  {/* Admin indicator glow */}
                  <motion.div
                    className="absolute inset-0 rounded-full bg-gradient-to-r from-purple-600 to-purple-500"
                    animate={{
                      scale: [1, 1.2, 1],
                      opacity: [0.6, 0, 0.6],
                    }}
                    transition={{
                      duration: 2,
                      repeat: Infinity,
                      ease: "easeInOut",
                    }}
                  />
                </motion.button>
              )}
              
              <motion.button
                whileTap={{ scale: 0.95 }}
                className={`w-10 h-10 glass-card rounded-full flex items-center justify-center backdrop-blur-md border ${colors.glassBorder} hover:border-white/40 transition-all duration-200`}
              >
                <Share size={20} className={colors.textPrimary} />
              </motion.button>
              <motion.button
                whileTap={{ scale: 0.95 }}
                onClick={() => onNavigate('settings', true)}
                className={`w-10 h-10 glass-card rounded-full flex items-center justify-center backdrop-blur-md border ${colors.glassBorder} hover:border-white/40 transition-all duration-200`}
              >
                <Settings size={20} className={colors.textPrimary} />
              </motion.button>
            </div>
          </div>

          {/* Profile Info */}
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ delay: 0.2, duration: 0.6 }}
            className={`glass-card rounded-[30px] p-6 backdrop-blur-xl mb-6 border ${colors.glassBorder}`}
            style={{ 
              boxShadow: '0 12px 40px rgba(107, 31, 179, 0.3)' 
            }}
          >
            <div className="flex items-center space-x-4 mb-4">
              <div className="relative">
                <motion.div
                  animate={{
                    rotate: [0, 5, -5, 0],
                    scale: [1, 1.05, 1],
                  }}
                  transition={{
                    duration: 6,
                    repeat: Infinity,
                    ease: "easeInOut"
                  }}
                  className="w-20 h-20 bg-gradient-to-r from-purple-500 to-blue-500 rounded-full flex items-center justify-center"
                  style={{ 
                    boxShadow: '0 8px 32px rgba(107, 31, 179, 0.4)' 
                  }}
                >
                  <span className={`text-2xl font-bold ${colors.textPrimary}`}>A</span>
                </motion.div>
                <motion.button
                  whileTap={{ scale: 0.95 }}
                  className="absolute -bottom-1 -right-1 w-6 h-6 bg-gradient-to-r from-yellow-400 to-yellow-300 rounded-full flex items-center justify-center"
                >
                  <Edit size={12} className="text-black" />
                </motion.button>
              </div>
              
              <div className="flex-1">
                <h2 className={`text-xl font-bold ${colors.textPrimary}`}>Alex Rivera</h2>
                <p className={`mb-2 ${colors.accent}`}>Memory Explorer & Creator</p>
                <div className={`flex items-center space-x-4 text-sm ${colors.textSecondary}`}>
                  <div className="flex items-center space-x-1">
                    <MapPin size={14} />
                    <span>San Francisco, CA</span>
                  </div>
                  <div className="flex items-center space-x-1">
                    <Calendar size={14} />
                    <span>Joined {userStats.joinDate}</span>
                  </div>
                </div>
              </div>
            </div>

            <p className={`text-sm mb-4 leading-relaxed ${colors.textSecondary}`}>
              Passionate about discovering hidden gems and sharing magical moments through AR. 
              Always exploring new places and creating memories! ✨
            </p>

            <div className="flex items-center space-x-6 text-sm">
              <div className="text-center">
                <p className={`font-semibold ${colors.textPrimary}`}>{userStats.followers}</p>
                <p className={colors.textSecondary}>Followers</p>
              </div>
              <div className="text-center">
                <p className={`font-semibold ${colors.textPrimary}`}>{userStats.following}</p>
                <p className={colors.textSecondary}>Following</p>
              </div>
              <div className="text-center">
                <p className={`font-semibold ${colors.textPrimary}`}>{userStats.likes}</p>
                <p className={colors.textSecondary}>Total Likes</p>
              </div>
            </div>
          </motion.div>

          {/* Tabs */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4, duration: 0.6 }}
            className={`glass-nav rounded-[20px] p-1 relative border ${colors.glassBorder}`}
          >
            <div className="flex relative">
              <motion.div
                className="absolute inset-y-1 bg-gradient-to-r from-purple-600 to-purple-500 rounded-[16px]"
                style={{ 
                  boxShadow: '0 4px 12px rgba(107, 31, 179, 0.4)' 
                }}
                animate={{
                  x: `${tabs.findIndex(tab => tab.id === activeTab) * 100}%`,
                }}
                transition={{ type: "spring", bounce: 0.15, duration: 0.4 }}
                style={{ width: `${100 / tabs.length}%` }}
              />
              {tabs.map((tab) => {
                const Icon = tab.icon;
                const isActive = activeTab === tab.id;
                
                return (
                  <button
                    key={tab.id}
                    onClick={() => setActiveTab(tab.id)}
                    className={`relative z-10 flex-1 flex items-center justify-center space-x-2 py-3 font-semibold transition-colors duration-200 ${
                      isActive ? colors.textPrimary : colors.textSecondary
                    }`}
                  >
                    <Icon size={16} />
                    <span className="text-sm">{tab.label}</span>
                  </button>
                );
              })}
            </div>
          </motion.div>
        </motion.div>
      </div>

      {/* Scrollable Content Area */}
      <div className="flex-1 min-h-0 px-6">
        <div className="h-full overflow-y-auto">
          <div className="pb-6">
            <AnimatePresence mode="wait">
              <motion.div
                key={activeTab}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -20 }}
                transition={{ duration: 0.3 }}
              >
                {renderTabContent()}
              </motion.div>
            </AnimatePresence>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProfileScreen;