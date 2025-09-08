import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { 
  ArrowLeft, Users, Camera, Route, MessageCircle, TrendingUp, 
  Shield, Settings, BarChart3, Globe, Clock, Star, AlertTriangle,
  DollarSign, MapPin, Activity, UserCheck, Eye, Ban,
  RefreshCw, Download, Filter, Search, Calendar
} from 'lucide-react';
import { useTheme } from './ThemeContext';

interface AdminDashboardScreenProps {
  onNavigate: (screen: string, isSubScreen?: boolean, data?: any) => void;
}

const AdminDashboardScreen: React.FC<AdminDashboardScreenProps> = ({ onNavigate }) => {
  const { colors, isDarkMode, hapticFeedback, playSound } = useTheme();
  const [activeTab, setActiveTab] = useState('overview');

  // Mock admin data - in real app this would come from backend
  const adminStats = {
    totalUsers: 15847,
    activeUsers: 8934,
    newUsersToday: 234,
    totalMemories: 84562,
    totalTrails: 1247,
    totalMessages: 156789,
    premiumUsers: 2847,
    revenue: 94583.50,
    moderationQueue: 23,
    reportedContent: 8
  };

  // Growth data for charts
  const userGrowthData = [
    { name: 'Jan', users: 1200, active: 800 },
    { name: 'Feb', users: 1890, active: 1200 },
    { name: 'Mar', users: 2800, active: 1800 },
    { name: 'Apr', users: 3900, active: 2400 },
    { name: 'May', users: 5200, active: 3200 },
    { name: 'Jun', users: 7100, active: 4500 },
    { name: 'Jul', users: 9800, active: 6200 },
    { name: 'Aug', users: 12500, active: 7800 },
    { name: 'Sep', users: 15847, active: 8934 }
  ];

  const memoryTypeData = [
    { name: 'Photos', value: 45682, color: '#6B1FB3' },
    { name: 'Videos', value: 23847, color: '#C6B6E2' },
    { name: 'Text', value: 10234, color: '#FFD700' },
    { name: 'Audio', value: 4799, color: '#FF6B6B' }
  ];

  const revenueData = [
    { name: 'Jan', premium: 12000, ads: 3000 },
    { name: 'Feb', premium: 15000, ads: 3500 },
    { name: 'Mar', premium: 18000, ads: 4000 },
    { name: 'Apr', premium: 22000, ads: 4200 },
    { name: 'May', premium: 28000, ads: 4800 },
    { name: 'Jun', premium: 35000, ads: 5200 },
    { name: 'Jul', premium: 42000, ads: 5800 },
    { name: 'Aug', premium: 48000, ads: 6200 },
    { name: 'Sep', premium: 52000, ads: 6800 }
  ];

  const topLocations = [
    { city: 'San Francisco', memories: 8234, users: 1247 },
    { city: 'New York', memories: 7456, users: 1089 },
    { city: 'Los Angeles', memories: 6789, users: 998 },
    { city: 'London', memories: 5234, users: 834 },
    { city: 'Tokyo', memories: 4567, users: 723 },
    { city: 'Paris', memories: 3892, users: 645 },
    { city: 'Berlin', memories: 3245, users: 567 },
    { city: 'Sydney', memories: 2789, users: 445 }
  ];

  const recentActivities = [
    { id: 1, type: 'user_signup', user: 'Emma Wilson', time: '2 minutes ago', severity: 'info' },
    { id: 2, type: 'content_report', user: 'Report #1247', time: '5 minutes ago', severity: 'warning' },
    { id: 3, type: 'premium_signup', user: 'Alex Chen', time: '8 minutes ago', severity: 'success' },
    { id: 4, type: 'memory_viral', user: 'Sarah Park', time: '12 minutes ago', severity: 'info' },
    { id: 5, type: 'user_banned', user: 'Spam Account', time: '15 minutes ago', severity: 'error' }
  ];

  const moderationQueue = [
    { id: 1, type: 'memory', content: 'Inappropriate photo content', reporter: 'User #4523', time: '2h ago' },
    { id: 2, type: 'comment', content: 'Spam comment detected', reporter: 'System', time: '3h ago' },
    { id: 3, type: 'trail', content: 'Copyright violation claim', reporter: 'User #7834', time: '5h ago' },
    { id: 4, type: 'profile', content: 'Fake profile suspected', reporter: 'User #2901', time: '6h ago' }
  ];

  const tabs = [
    { id: 'overview', label: 'Overview', icon: BarChart3 },
    { id: 'users', label: 'Users', icon: Users },
    { id: 'content', label: 'Content', icon: Camera },
    { id: 'revenue', label: 'Revenue', icon: DollarSign },
    { id: 'moderation', label: 'Moderation', icon: Shield },
    { id: 'analytics', label: 'Analytics', icon: TrendingUp }
  ];

  const handleTabClick = (tabId: string) => {
    setActiveTab(tabId);
    hapticFeedback('light');
    playSound('tap');
  };

  const StatCard = ({ title, value, change, icon: Icon, color = 'purple' }: any) => (
    <motion.div
      initial={{ opacity: 0, scale: 0.9 }}
      animate={{ opacity: 1, scale: 1 }}
      transition={{ duration: 0.4 }}
      className={`glass-card rounded-[20px] p-6 backdrop-blur-xl border ${colors.glassBorder}`}
      style={{ 
        boxShadow: '0 8px 32px rgba(107, 31, 179, 0.15)',
        background: isDarkMode 
          ? 'rgba(0, 0, 0, 0.4)' 
          : 'rgba(255, 255, 255, 0.8)'
      }}
    >
      <div className="flex items-center justify-between mb-3">
        <div className={`p-2 rounded-xl ${
          color === 'purple' 
            ? 'bg-purple-500/20 text-purple-400' 
            : color === 'gold' 
            ? 'bg-yellow-500/20 text-yellow-400' 
            : 'bg-green-500/20 text-green-400'
        }`}>
          <Icon size={20} />
        </div>
        {change && (
          <span className={`text-xs px-3 py-1 rounded-full font-medium ${
            change > 0 ? 'bg-green-500/20 text-green-400' : 'bg-red-500/20 text-red-400'
          }`}>
            {change > 0 ? '+' : ''}{change}%
          </span>
        )}
      </div>
      <p className={`text-3xl font-bold mb-1 ${isDarkMode ? 'text-white' : 'text-gray-900'}`}>{value}</p>
      <p className={`text-sm font-medium ${isDarkMode ? 'text-gray-300' : 'text-gray-600'}`}>{title}</p>
    </motion.div>
  );

  const renderTabContent = () => {
    switch (activeTab) {
      case 'overview':
        return (
          <div className="space-y-6">
            {/* Key Metrics */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              <StatCard title="Total Users" value={adminStats.totalUsers.toLocaleString()} change={12.5} icon={Users} />
              <StatCard title="Active Users" value={adminStats.activeUsers.toLocaleString()} change={8.3} icon={Activity} />
              <StatCard title="Total Memories" value={adminStats.totalMemories.toLocaleString()} change={15.2} icon={Camera} />
              <StatCard title="Premium Users" value={adminStats.premiumUsers.toLocaleString()} change={22.1} icon={Star} color="gold" />
            </div>

            {/* User Growth Visualization */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2, duration: 0.6 }}
              className={`rounded-[24px] p-6 backdrop-blur-xl border`}
              style={{ 
                boxShadow: '0 8px 32px rgba(107, 31, 179, 0.15)',
                background: isDarkMode 
                  ? 'rgba(0, 0, 0, 0.4)' 
                  : 'rgba(255, 255, 255, 0.8)',
                borderColor: isDarkMode 
                  ? 'rgba(255, 255, 255, 0.1)' 
                  : 'rgba(0, 0, 0, 0.1)'
              }}
            >
              <h3 className={`text-lg font-semibold mb-4 flex items-center ${isDarkMode ? 'text-white' : 'text-gray-900'}`}>
                <div className="p-2 rounded-xl bg-purple-500/20 text-purple-400 mr-3">
                  <TrendingUp size={20} />
                </div>
                User Growth Trend
              </h3>
              <div className="h-64 flex items-end justify-between space-x-2">
                {userGrowthData.map((data, index) => (
                  <div key={data.name} className="flex-1 flex flex-col items-center">
                    <div className="w-full flex flex-col justify-end h-48 space-y-1">
                      <motion.div
                        initial={{ height: 0 }}
                        animate={{ height: `${(data.users / 20000) * 100}%` }}
                        transition={{ delay: 0.3 + index * 0.1, duration: 0.6 }}
                        className="w-full bg-gradient-to-t from-purple-600 to-purple-400 rounded-t-md opacity-80"
                      />
                      <motion.div
                        initial={{ height: 0 }}
                        animate={{ height: `${(data.active / 20000) * 100}%` }}
                        transition={{ delay: 0.4 + index * 0.1, duration: 0.6 }}
                        className="w-full bg-gradient-to-t from-purple-400 to-purple-200 rounded-t-md"
                      />
                    </div>
                    <p className={`text-xs mt-2 font-medium ${isDarkMode ? 'text-gray-300' : 'text-gray-600'}`}>{data.name}</p>
                  </div>
                ))}
              </div>
              <div className="flex justify-center space-x-6 mt-4">
                <div className="flex items-center space-x-2">
                  <div className="w-3 h-3 bg-purple-600 rounded-full"></div>
                  <span className={`text-sm font-medium ${isDarkMode ? 'text-gray-300' : 'text-gray-600'}`}>Total Users</span>
                </div>
                <div className="flex items-center space-x-2">
                  <div className="w-3 h-3 bg-purple-400 rounded-full"></div>
                  <span className={`text-sm font-medium ${isDarkMode ? 'text-gray-300' : 'text-gray-600'}`}>Active Users</span>
                </div>
              </div>
            </motion.div>

            {/* Recent Activity */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.4, duration: 0.6 }}
              className={`rounded-[24px] p-6 backdrop-blur-xl border`}
              style={{ 
                boxShadow: '0 8px 32px rgba(107, 31, 179, 0.15)',
                background: isDarkMode 
                  ? 'rgba(0, 0, 0, 0.4)' 
                  : 'rgba(255, 255, 255, 0.8)',
                borderColor: isDarkMode 
                  ? 'rgba(255, 255, 255, 0.1)' 
                  : 'rgba(0, 0, 0, 0.1)'
              }}
            >
              <h3 className={`text-lg font-semibold mb-4 flex items-center ${isDarkMode ? 'text-white' : 'text-gray-900'}`}>
                <div className="p-2 rounded-xl bg-purple-500/20 text-purple-400 mr-3">
                  <Clock size={20} />
                </div>
                Recent Activity
              </h3>
              <div className="space-y-3">
                {recentActivities.map((activity, index) => (
                  <motion.div
                    key={activity.id}
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: 0.5 + index * 0.1, duration: 0.4 }}
                    className={`flex items-center justify-between p-4 rounded-[16px] backdrop-blur-md border transition-all duration-200`}
                    style={{ 
                      background: isDarkMode 
                        ? 'rgba(255, 255, 255, 0.05)' 
                        : 'rgba(255, 255, 255, 0.6)',
                      borderColor: isDarkMode 
                        ? 'rgba(255, 255, 255, 0.1)' 
                        : 'rgba(0, 0, 0, 0.1)'
                    }}
                  >
                    <div className="flex items-center space-x-3">
                      <div className={`w-3 h-3 rounded-full ${
                        activity.severity === 'error' ? 'bg-red-500' :
                        activity.severity === 'warning' ? 'bg-yellow-500' :
                        activity.severity === 'success' ? 'bg-green-500' : 'bg-blue-500'
                      }`} />
                      <div>
                        <p className={`font-medium ${isDarkMode ? 'text-white' : 'text-gray-900'}`}>{activity.user}</p>
                        <p className={`text-sm capitalize font-medium ${isDarkMode ? 'text-gray-300' : 'text-gray-600'}`}>
                          {activity.type.replace('_', ' ')}
                        </p>
                      </div>
                    </div>
                    <span className={`text-sm font-medium ${isDarkMode ? 'text-gray-400' : 'text-gray-500'}`}>{activity.time}</span>
                  </motion.div>
                ))}
              </div>
            </motion.div>
          </div>
        );

      case 'users':
        return (
          <div className="space-y-6">
            {/* User Stats */}
            <div className="grid grid-cols-2 gap-4">
              <StatCard title="New Today" value={adminStats.newUsersToday} change={18.2} icon={UserCheck} color="green" />
              <StatCard title="Premium Rate" value="18.5%" change={5.3} icon={Star} color="gold" />
            </div>

            {/* Top Locations */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2, duration: 0.6 }}
              className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.glassBorder}`}
              style={{ boxShadow: '0 8px 32px rgba(107, 31, 179, 0.2)' }}
            >
              <h3 className={`font-semibold mb-4 flex items-center ${colors.textPrimary}`}>
                <MapPin size={20} className="mr-2 text-purple-400" />
                Top Locations by Users
              </h3>
              <div className="space-y-3">
                {topLocations.slice(0, 6).map((location, index) => (
                  <motion.div
                    key={location.city}
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: 0.3 + index * 0.1, duration: 0.4 }}
                    className={`flex items-center justify-between p-3 glass-card rounded-[16px] backdrop-blur-md border ${colors.glassBorder}`}
                  >
                    <div>
                      <p className={`font-medium ${colors.textPrimary}`}>{location.city}</p>
                      <p className={`text-sm ${colors.textSecondary}`}>{location.memories.toLocaleString()} memories</p>
                    </div>
                    <span className={`font-semibold ${colors.accent}`}>{location.users.toLocaleString()}</span>
                  </motion.div>
                ))}
              </div>
            </motion.div>
          </div>
        );

      case 'content':
        return (
          <div className="space-y-6">
            {/* Content Stats */}
            <div className="grid grid-cols-2 gap-4">
              <StatCard title="Total Trails" value={adminStats.totalTrails.toLocaleString()} change={9.7} icon={Route} />
              <StatCard title="Avg. Memories/Day" value="2,847" change={12.1} icon={Camera} />
            </div>

            {/* Memory Types Distribution */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2, duration: 0.6 }}
              className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.glassBorder}`}
              style={{ boxShadow: '0 8px 32px rgba(107, 31, 179, 0.2)' }}
            >
              <h3 className={`font-semibold mb-4 flex items-center ${colors.textPrimary}`}>
                <Camera size={20} className="mr-2 text-purple-400" />
                Memory Types Distribution
              </h3>
              <div className="space-y-4">
                {memoryTypeData.map((type, index) => {
                  const percentage = (type.value / memoryTypeData.reduce((sum, item) => sum + item.value, 0)) * 100;
                  return (
                    <motion.div
                      key={type.name}
                      initial={{ opacity: 0, x: -20 }}
                      animate={{ opacity: 1, x: 0 }}
                      transition={{ delay: 0.3 + index * 0.1, duration: 0.4 }}
                      className="space-y-2"
                    >
                      <div className="flex justify-between items-center">
                        <div className="flex items-center space-x-2">
                          <div 
                            className="w-4 h-4 rounded-full"
                            style={{ backgroundColor: type.color }}
                          />
                          <span className={`font-medium ${colors.textPrimary}`}>{type.name}</span>
                        </div>
                        <span className={`text-sm ${colors.textSecondary}`}>
                          {type.value.toLocaleString()} ({percentage.toFixed(1)}%)
                        </span>
                      </div>
                      <div className="w-full bg-white/10 rounded-full h-2">
                        <motion.div
                          initial={{ width: 0 }}
                          animate={{ width: `${percentage}%` }}
                          transition={{ delay: 0.4 + index * 0.1, duration: 0.6 }}
                          className="h-2 rounded-full"
                          style={{ backgroundColor: type.color }}
                        />
                      </div>
                    </motion.div>
                  );
                })}
              </div>
            </motion.div>
          </div>
        );

      case 'revenue':
        return (
          <div className="space-y-6">
            {/* Revenue Stats */}
            <div className="grid grid-cols-2 gap-4">
              <StatCard title="Monthly Revenue" value={`$${(adminStats.revenue / 1000).toFixed(1)}K`} change={28.4} icon={DollarSign} color="gold" />
              <StatCard title="Conversion Rate" value="3.2%" change={15.7} icon={TrendingUp} color="green" />
            </div>

            {/* Revenue Breakdown */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2, duration: 0.6 }}
              className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.glassBorder}`}
              style={{ boxShadow: '0 8px 32px rgba(107, 31, 179, 0.2)' }}
            >
              <h3 className={`font-semibold mb-4 flex items-center ${colors.textPrimary}`}>
                <DollarSign size={20} className="mr-2 text-yellow-400" />
                Revenue Breakdown
              </h3>
              <div className="h-64 flex items-end justify-between space-x-2">
                {revenueData.map((data, index) => {
                  const maxRevenue = Math.max(...revenueData.map(d => d.premium + d.ads));
                  const totalHeight = ((data.premium + data.ads) / maxRevenue) * 100;
                  const premiumHeight = (data.premium / (data.premium + data.ads)) * totalHeight;
                  const adsHeight = (data.ads / (data.premium + data.ads)) * totalHeight;
                  
                  return (
                    <div key={data.name} className="flex-1 flex flex-col items-center">
                      <div className="w-full flex flex-col justify-end h-48">
                        <motion.div
                          initial={{ height: 0 }}
                          animate={{ height: `${adsHeight}%` }}
                          transition={{ delay: 0.3 + index * 0.1, duration: 0.6 }}
                          className="w-full bg-gradient-to-t from-purple-600 to-purple-400 rounded-t-md"
                        />
                        <motion.div
                          initial={{ height: 0 }}
                          animate={{ height: `${premiumHeight}%` }}
                          transition={{ delay: 0.4 + index * 0.1, duration: 0.6 }}
                          className="w-full bg-gradient-to-t from-yellow-500 to-yellow-300"
                        />
                      </div>
                      <p className={`text-xs mt-2 ${colors.textSecondary}`}>{data.name}</p>
                    </div>
                  );
                })}
              </div>
              <div className="flex justify-center space-x-4 mt-4">
                <div className="flex items-center space-x-2">
                  <div className="w-3 h-3 bg-yellow-400 rounded-full"></div>
                  <span className={`text-sm ${colors.textSecondary}`}>Premium</span>
                </div>
                <div className="flex items-center space-x-2">
                  <div className="w-3 h-3 bg-purple-600 rounded-full"></div>
                  <span className={`text-sm ${colors.textSecondary}`}>Ads</span>
                </div>
              </div>
            </motion.div>
          </div>
        );

      case 'moderation':
        return (
          <div className="space-y-6">
            {/* Moderation Stats */}
            <div className="grid grid-cols-2 gap-4">
              <StatCard title="Pending Reports" value={adminStats.moderationQueue} change={-12.3} icon={AlertTriangle} color="gold" />
              <StatCard title="Auto-Resolved" value="156" change={34.2} icon={Shield} color="green" />
            </div>

            {/* Moderation Queue */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2, duration: 0.6 }}
              className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.glassBorder}`}
              style={{ boxShadow: '0 8px 32px rgba(107, 31, 179, 0.2)' }}
            >
              <h3 className={`font-semibold mb-4 flex items-center ${colors.textPrimary}`}>
                <Shield size={20} className="mr-2 text-purple-400" />
                Moderation Queue
              </h3>
              <div className="space-y-3">
                {moderationQueue.map((item, index) => (
                  <motion.div
                    key={item.id}
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: 0.3 + index * 0.1, duration: 0.4 }}
                    className={`flex items-center justify-between p-4 glass-card rounded-[16px] backdrop-blur-md border ${colors.glassBorder}`}
                  >
                    <div className="flex-1">
                      <div className="flex items-center space-x-2 mb-2">
                        <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                          item.type === 'memory' ? 
                            isDarkMode ? 'bg-purple-600/30 text-purple-300 border border-purple-500/20' : 'bg-purple-600/20 text-purple-700 border border-purple-500/30' :
                          item.type === 'comment' ? 
                            isDarkMode ? 'bg-blue-600/30 text-blue-300 border border-blue-500/20' : 'bg-blue-600/20 text-blue-700 border border-blue-500/30' :
                          item.type === 'trail' ? 
                            isDarkMode ? 'bg-green-600/30 text-green-300 border border-green-500/20' : 'bg-green-600/20 text-green-700 border border-green-500/30' :
                            isDarkMode ? 'bg-yellow-600/30 text-yellow-300 border border-yellow-500/20' : 'bg-yellow-600/20 text-yellow-700 border border-yellow-500/30'
                        }`}>
                          {item.type}
                        </span>
                        <span className={`text-xs ${isDarkMode ? 'text-gray-300' : 'text-gray-600'}`}>{item.time}</span>
                      </div>
                      <p className={`font-medium ${isDarkMode ? 'text-white' : 'text-gray-900'}`}>{item.content}</p>
                      <p className={`text-sm ${isDarkMode ? 'text-gray-300' : 'text-gray-600'}`}>Reported by: {item.reporter}</p>
                    </div>
                    <div className="flex space-x-2 ml-4">
                      <motion.button
                        whileTap={{ scale: 0.95 }}
                        className={`px-3 py-1 rounded-lg text-sm font-medium transition-colors ${
                          isDarkMode 
                            ? 'bg-green-600/30 text-green-300 border border-green-500/20 hover:bg-green-600/40' 
                            : 'bg-green-600/20 text-green-700 border border-green-500/30 hover:bg-green-600/30'
                        }`}
                      >
                        Approve
                      </motion.button>
                      <motion.button
                        whileTap={{ scale: 0.95 }}
                        className={`px-3 py-1 rounded-lg text-sm font-medium transition-colors ${
                          isDarkMode 
                            ? 'bg-red-600/30 text-red-300 border border-red-500/20 hover:bg-red-600/40' 
                            : 'bg-red-600/20 text-red-700 border border-red-500/30 hover:bg-red-600/30'
                        }`}
                      >
                        Remove
                      </motion.button>
                    </div>
                  </motion.div>
                ))}
              </div>
            </motion.div>
          </div>
        );

      case 'analytics':
        return (
          <div className="space-y-6">
            {/* System Health */}
            <div className="grid grid-cols-2 gap-4">
              <StatCard title="Server Uptime" value="99.9%" change={0.1} icon={Activity} color="green" />
              <StatCard title="Avg Response Time" value="124ms" change={-8.5} icon={Clock} color="green" />
            </div>

            {/* Additional analytics components would go here */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2, duration: 0.6 }}
              className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.glassBorder} text-center`}
              style={{ boxShadow: '0 8px 32px rgba(107, 31, 179, 0.2)' }}
            >
              <BarChart3 size={48} className="mx-auto mb-4 text-purple-400" />
              <h3 className={`font-semibold mb-2 ${colors.textPrimary}`}>Advanced Analytics</h3>
              <p className={`${colors.textSecondary}`}>
                Detailed analytics dashboard with custom reports, A/B testing results, and predictive insights.
              </p>
            </motion.div>
          </div>
        );

      default:
        return null;
    }
  };

  return (
    <div className={`h-full w-full flex flex-col`}
         style={{ 
           background: isDarkMode 
             ? 'linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%)' 
             : 'linear-gradient(135deg, #f8fafc 0%, #e2e8f0 50%, #cbd5e1 100%)'
         }}>
      {/* Header */}
      <div className="flex-shrink-0 pt-12 px-6 pb-4">
        <motion.div
          initial={{ opacity: 0, y: -30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4 }}
        >
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center space-x-3">
              <motion.button
                whileTap={{ scale: 0.95 }}
                onClick={() => onNavigate('profile')}
                className={`w-12 h-12 rounded-full flex items-center justify-center backdrop-blur-md border transition-all duration-200`}
                style={{ 
                  background: isDarkMode 
                    ? 'rgba(255, 255, 255, 0.1)' 
                    : 'rgba(255, 255, 255, 0.8)',
                  borderColor: isDarkMode 
                    ? 'rgba(255, 255, 255, 0.2)' 
                    : 'rgba(0, 0, 0, 0.1)',
                  boxShadow: '0 4px 16px rgba(107, 31, 179, 0.2)'
                }}
              >
                <ArrowLeft size={20} className={isDarkMode ? 'text-white' : 'text-gray-900'} />
              </motion.button>
              <div>
                <h1 className={`text-3xl font-bold ${isDarkMode ? 'text-white' : 'text-gray-900'}`}>Admin Dashboard</h1>
                <p className={`text-sm font-medium ${isDarkMode ? 'text-gray-300' : 'text-gray-600'}`}>System overview and controls</p>
              </div>
            </div>
            
            <div className="flex items-center space-x-3">
              <motion.button
                whileTap={{ scale: 0.95 }}
                className={`w-12 h-12 rounded-full flex items-center justify-center backdrop-blur-md border transition-all duration-200`}
                style={{ 
                  background: isDarkMode 
                    ? 'rgba(255, 255, 255, 0.1)' 
                    : 'rgba(255, 255, 255, 0.8)',
                  borderColor: isDarkMode 
                    ? 'rgba(255, 255, 255, 0.2)' 
                    : 'rgba(0, 0, 0, 0.1)',
                  boxShadow: '0 4px 16px rgba(107, 31, 179, 0.2)'
                }}
              >
                <RefreshCw size={20} className={isDarkMode ? 'text-white' : 'text-gray-900'} />
              </motion.button>
              <motion.button
                whileTap={{ scale: 0.95 }}
                className={`w-12 h-12 rounded-full flex items-center justify-center backdrop-blur-md border transition-all duration-200`}
                style={{ 
                  background: isDarkMode 
                    ? 'rgba(255, 255, 255, 0.1)' 
                    : 'rgba(255, 255, 255, 0.8)',
                  borderColor: isDarkMode 
                    ? 'rgba(255, 255, 255, 0.2)' 
                    : 'rgba(0, 0, 0, 0.1)',
                  boxShadow: '0 4px 16px rgba(107, 31, 179, 0.2)'
                }}
              >
                <Download size={20} className={isDarkMode ? 'text-white' : 'text-gray-900'} />
              </motion.button>
            </div>
          </div>

          {/* Admin Badge */}
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ delay: 0.2, duration: 0.6 }}
            className="flex items-center justify-center mb-6"
          >
            <div className="flex items-center space-x-2 bg-gradient-to-r from-purple-600 to-purple-500 px-4 py-2 rounded-full">
              <Shield size={16} className="text-white" />
              <span className="text-white font-medium">Administrator Access</span>
            </div>
          </motion.div>

          {/* Tabs */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4, duration: 0.6 }}
            className={`rounded-[20px] p-1 relative border overflow-x-auto`}
            style={{ 
              background: isDarkMode 
                ? 'rgba(0, 0, 0, 0.4)' 
                : 'rgba(255, 255, 255, 0.8)',
              backdropFilter: 'blur(20px)',
              borderColor: isDarkMode 
                ? 'rgba(255, 255, 255, 0.1)' 
                : 'rgba(0, 0, 0, 0.1)'
            }}
          >
            <div className="flex relative min-w-full">
              <motion.div
                className="absolute inset-y-1 bg-gradient-to-r from-purple-600 to-purple-500 rounded-[16px] z-0"
                style={{ 
                  boxShadow: '0 4px 12px rgba(107, 31, 179, 0.4)',
                  width: `${100 / tabs.length}%`,
                  left: `${tabs.findIndex(tab => tab.id === activeTab) * (100 / tabs.length)}%`
                }}
                initial={false}
                animate={{
                  left: `${tabs.findIndex(tab => tab.id === activeTab) * (100 / tabs.length)}%`
                }}
                transition={{ type: "spring", bounce: 0.15, duration: 0.4 }}
              />
              {tabs.map((tab) => {
                const Icon = tab.icon;
                const isActive = activeTab === tab.id;
                
                return (
                  <button
                    key={tab.id}
                    onClick={() => handleTabClick(tab.id)}
                    className={`relative z-10 flex-1 flex items-center justify-center space-x-2 py-3 font-semibold transition-all duration-300 whitespace-nowrap px-3 rounded-[16px] ${
                      isActive 
                        ? 'text-white shadow-lg' 
                        : isDarkMode 
                        ? 'text-gray-300 hover:text-white' 
                        : 'text-gray-600 hover:text-gray-900'
                    }`}
                  >
                    <Icon size={16} />
                    <span className="text-sm font-medium">{tab.label}</span>
                  </button>
                );
              })}
            </div>
          </motion.div>
        </motion.div>
      </div>

      {/* Scrollable Content */}
      <div className="flex-1 min-h-0 px-6">
        <div className="h-full overflow-y-auto scrollbar-hide">
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

export default AdminDashboardScreen;