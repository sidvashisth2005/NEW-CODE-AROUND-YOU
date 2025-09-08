import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { ArrowLeft, Bell, Shield, Globe, MapPin, Camera, Mic, User, Moon, Sun, Volume2, VolumeX, Smartphone, Eye, Lock, HelpCircle, Mail, Star, LogOut, Settings as SettingsIcon, X, Palette } from 'lucide-react';
import { ScrollArea } from './ui/scroll-area';
import { Switch } from './ui/switch';
import { useTheme } from './ThemeContext';

interface SettingsScreenProps {
  onNavigate: (screen: string, isSubScreen?: boolean) => void;
  onLogout: () => void;
}

const SettingsScreen: React.FC<SettingsScreenProps> = ({ onNavigate, onLogout }) => {
  const { isDarkMode, toggleTheme, colors } = useTheme();
  const [showAdvancedSettings, setShowAdvancedSettings] = useState(false);
  const [showLogoutConfirm, setShowLogoutConfirm] = useState(false);
  
  // Settings states
  const [notifications, setNotifications] = useState(true);
  const [locationSharing, setLocationSharing] = useState(true);
  const [arMode, setArMode] = useState(true);
  const [soundEnabled, setSoundEnabled] = useState(true);
  const [publicProfile, setPublicProfile] = useState(true);
  const [memoryBackup, setMemoryBackup] = useState(true);
  const [analyticsSharing, setAnalyticsSharing] = useState(false);

  const settingsCategories = [
    {
      title: 'Appearance',
      icon: Palette,
      settings: [
        {
          id: 'dark-mode',
          title: 'Dark Mode',
          description: 'Switch between light and dark theme',
          value: isDarkMode,
          onChange: toggleTheme,
          type: 'switch'
        }
      ]
    },
    {
      title: 'Account & Privacy',
      icon: User,
      settings: [
        {
          id: 'profile-public',
          title: 'Public Profile',
          description: 'Make your profile visible to other users',
          value: publicProfile,
          onChange: setPublicProfile,
          type: 'switch'
        },
        {
          id: 'location-sharing',
          title: 'Location Sharing',
          description: 'Share your location for nearby memories',
          value: locationSharing,
          onChange: setLocationSharing,
          type: 'switch'
        }
      ]
    },
    {
      title: 'Notifications',
      icon: Bell,
      settings: [
        {
          id: 'notifications',
          title: 'Push Notifications',
          description: 'Receive notifications for new memories and interactions',
          value: notifications,
          onChange: setNotifications,
          type: 'switch'
        },
        {
          id: 'sound',
          title: 'Notification Sounds',
          description: 'Play sounds for notifications',
          value: soundEnabled,
          onChange: setSoundEnabled,
          type: 'switch'
        }
      ]
    },
    {
      title: 'AR & Camera',
      icon: Camera,
      settings: [
        {
          id: 'ar-mode',
          title: 'AR Mode',
          description: 'Enable augmented reality features',
          value: arMode,
          onChange: setArMode,
          type: 'switch'
        }
      ]
    },
    {
      title: 'Data & Storage',
      icon: Shield,
      settings: [
        {
          id: 'memory-backup',
          title: 'Memory Backup',
          description: 'Automatically backup your memories to cloud',
          value: memoryBackup,
          onChange: setMemoryBackup,
          type: 'switch'
        }
      ]
    }
  ];

  const advancedSettings = [
    {
      id: 'analytics',
      title: 'Analytics Sharing',
      description: 'Share anonymous usage data to help improve the app',
      value: analyticsSharing,
      onChange: setAnalyticsSharing,
      type: 'switch'
    }
  ];

  const handleLogout = () => {
    setShowLogoutConfirm(false);
    onLogout();
  };

  return (
    <div className={`h-full w-full flex flex-col bg-gradient-to-br ${colors.background}`}>
      {/* Header - Fixed */}
      <div className="flex-shrink-0 pt-12 px-6 pb-4 bg-gradient-to-b from-black/30 via-black/10 to-transparent">
        <motion.div
          initial={{ opacity: 0, y: -30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4 }}
        >
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center space-x-4">
              <motion.button
                whileTap={{ scale: 0.95 }}
                onClick={() => onNavigate('profile')}
                className={`w-10 h-10 glass-card rounded-full flex items-center justify-center backdrop-blur-md border ${colors.glassBorder} hover:border-white/40 transition-all duration-200`}
              >
                <ArrowLeft size={20} className={colors.textPrimary} />
              </motion.button>
              <h1 className={`text-2xl font-bold ${colors.textPrimary}`}>Settings</h1>
            </div>

            <motion.button
              whileTap={{ scale: 0.95 }}
              onClick={() => setShowAdvancedSettings(true)}
              className={`w-10 h-10 glass-card rounded-full flex items-center justify-center backdrop-blur-md border ${colors.glassBorder} hover:border-white/40 transition-all duration-200`}
            >
              <SettingsIcon size={20} className={colors.textPrimary} />
            </motion.button>
          </div>

          {/* User Info */}
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ delay: 0.1, duration: 0.4 }}
            className={`glass-card rounded-[24px] p-6 backdrop-blur-xl mb-6 border ${colors.glassBorder}`}
            style={{ 
              boxShadow: '0 8px 32px rgba(107, 31, 179, 0.2)' 
            }}
          >
            <div className="flex items-center space-x-4">
              <div className="w-16 h-16 bg-gradient-to-r from-purple-500 to-blue-500 rounded-full flex items-center justify-center">
                <span className="text-white text-xl font-bold">A</span>
              </div>
              <div>
                <h2 className={`font-bold text-lg ${colors.textPrimary}`}>Alex Rivera</h2>
                <p className={colors.accent}>alex.rivera@example.com</p>
                <p className={`text-sm ${colors.textSecondary}`}>Premium Member</p>
              </div>
            </div>
          </motion.div>
        </motion.div>
      </div>

      {/* Settings Content - Scrollable */}
      <div className="flex-1 min-h-0 overflow-y-auto px-6">
        <div className="space-y-6 py-4 pb-32">
          {settingsCategories.map((category, categoryIndex) => {
            const CategoryIcon = category.icon;
            return (
              <motion.div
                key={category.title}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.2 + categoryIndex * 0.1, duration: 0.4 }}
                className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.glassBorder}`}
                style={{ 
                  boxShadow: '0 8px 32px rgba(107, 31, 179, 0.1)' 
                }}
              >
                <div className="flex items-center space-x-3 mb-6">
                  <div className="w-10 h-10 bg-gradient-to-r from-purple-500 to-blue-500 rounded-full flex items-center justify-center">
                    <CategoryIcon size={20} className="text-white" />
                  </div>
                  <h3 className={`font-semibold text-lg ${colors.textPrimary}`}>{category.title}</h3>
                </div>

                <div className="space-y-4">
                  {category.settings.map((setting, settingIndex) => (
                    <motion.div
                      key={setting.id}
                      initial={{ opacity: 0, x: -20 }}
                      animate={{ opacity: 1, x: 0 }}
                      transition={{ delay: 0.3 + categoryIndex * 0.1 + settingIndex * 0.05, duration: 0.3 }}
                      className={`flex items-center justify-between p-4 glass-card rounded-[16px] backdrop-blur-md border ${colors.glassBorder} hover:border-white/30 transition-all duration-200`}
                    >
                      <div className="flex-1">
                        <div className="flex items-center space-x-3">
                          <h4 className={`font-medium mb-1 ${colors.textPrimary}`}>{setting.title}</h4>
                          {setting.id === 'dark-mode' && (
                            <div className="flex items-center space-x-1">
                              {isDarkMode ? (
                                <Moon size={16} className={colors.accent} />
                              ) : (
                                <Sun size={16} className="text-orange-400" />
                              )}
                            </div>
                          )}
                        </div>
                        <p className={`text-sm ${colors.textSecondary}`}>{setting.description}</p>
                      </div>
                      {setting.type === 'switch' && (
                        <Switch
                          checked={setting.value}
                          onCheckedChange={setting.onChange}
                          className="data-[state=checked]:bg-purple-500"
                        />
                      )}
                    </motion.div>
                  ))}
                </div>
              </motion.div>
            );
          })}

          {/* Support & Info */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.6, duration: 0.4 }}
            className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.glassBorder}`}
            style={{ 
              boxShadow: '0 8px 32px rgba(107, 31, 179, 0.1)' 
            }}
          >
            <div className="flex items-center space-x-3 mb-6">
              <div className="w-10 h-10 bg-gradient-to-r from-purple-500 to-blue-500 rounded-full flex items-center justify-center">
                <HelpCircle size={20} className="text-white" />
              </div>
              <h3 className={`font-semibold text-lg ${colors.textPrimary}`}>Support & Info</h3>
            </div>

            <div className="space-y-3">
              {[
                { title: 'Help Center', icon: HelpCircle },
                { title: 'Contact Support', icon: Mail },
                { title: 'Rate App', icon: Star },
              ].map((item, index) => {
                const ItemIcon = item.icon;
                return (
                  <motion.button
                    key={item.title}
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: 0.7 + index * 0.05, duration: 0.3 }}
                    whileTap={{ scale: 0.98 }}
                    className={`w-full flex items-center space-x-3 p-4 glass-card rounded-[16px] backdrop-blur-md border ${colors.glassBorder} hover:border-white/30 transition-all duration-200`}
                  >
                    <ItemIcon size={18} className={colors.accent} />
                    <span className={`font-medium ${colors.textPrimary}`}>{item.title}</span>
                  </motion.button>
                );
              })}
            </div>
          </motion.div>

          {/* Logout Button */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.8, duration: 0.4 }}
          >
            <motion.button
              whileTap={{ scale: 0.98 }}
              onClick={() => setShowLogoutConfirm(true)}
              className="w-full bg-gradient-to-r from-red-600 to-red-500 py-4 rounded-[20px] text-white font-semibold flex items-center justify-center space-x-2 border border-red-500/30"
              style={{ 
                boxShadow: '0 8px 32px rgba(239, 68, 68, 0.3)' 
              }}
            >
              <LogOut size={20} />
              <span>Logout</span>
            </motion.button>
          </motion.div>
        </div>
      </div>

      {/* Advanced Settings Modal */}
      <AnimatePresence>
        {showAdvancedSettings && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-6"
            onClick={() => setShowAdvancedSettings(false)}
          >
            <motion.div
              initial={{ opacity: 0, scale: 0.9, y: 20 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.9, y: 20 }}
              transition={{ type: "spring", bounce: 0.2, duration: 0.5 }}
              onClick={(e) => e.stopPropagation()}
              className={`w-full max-w-md glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.glassBorder}`}
              style={{ 
                boxShadow: '0 16px 48px rgba(107, 31, 179, 0.3)' 
              }}
            >
              <div className="flex items-center justify-between mb-6">
                <h2 className={`font-bold text-xl ${colors.textPrimary}`}>Advanced Settings</h2>
                <motion.button
                  whileTap={{ scale: 0.9 }}
                  onClick={() => setShowAdvancedSettings(false)}
                  className={`w-8 h-8 glass-card rounded-full flex items-center justify-center backdrop-blur-md border ${colors.glassBorder} hover:border-white/40 transition-all duration-200`}
                >
                  <X size={16} className={colors.textPrimary} />
                </motion.button>
              </div>

              <div className="space-y-4">
                {advancedSettings.map((setting, index) => (
                  <motion.div
                    key={setting.id}
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: index * 0.1, duration: 0.3 }}
                    className={`flex items-center justify-between p-4 glass-card rounded-[16px] backdrop-blur-md border ${colors.glassBorder}`}
                  >
                    <div className="flex-1">
                      <h4 className={`font-medium mb-1 ${colors.textPrimary}`}>{setting.title}</h4>
                      <p className={`text-sm ${colors.textSecondary}`}>{setting.description}</p>
                    </div>
                    <Switch
                      checked={setting.value}
                      onCheckedChange={setting.onChange}
                      className="data-[state=checked]:bg-purple-500"
                    />
                  </motion.div>
                ))}
              </div>

              <div className={`mt-6 pt-4 border-t ${isDarkMode ? 'border-white/20' : 'border-purple-200/50'}`}>
                <p className={`text-xs text-center ${colors.textSecondary}`}>
                  Advanced settings may affect app performance and stability
                </p>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Logout Confirmation Modal */}
      <AnimatePresence>
        {showLogoutConfirm && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-6"
            onClick={() => setShowLogoutConfirm(false)}
          >
            <motion.div
              initial={{ opacity: 0, scale: 0.9, y: 20 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.9, y: 20 }}
              transition={{ type: "spring", bounce: 0.2, duration: 0.5 }}
              onClick={(e) => e.stopPropagation()}
              className={`w-full max-w-sm glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.glassBorder}`}
              style={{ 
                boxShadow: '0 16px 48px rgba(239, 68, 68, 0.3)' 
              }}
            >
              <div className="text-center">
                <div className="w-16 h-16 bg-gradient-to-r from-red-500 to-red-400 rounded-full flex items-center justify-center mx-auto mb-4">
                  <LogOut size={24} className="text-white" />
                </div>
                
                <h2 className={`font-bold text-xl mb-2 ${colors.textPrimary}`}>Logout</h2>
                <p className={`mb-6 ${colors.textSecondary}`}>
                  Are you sure you want to logout? You'll need to sign in again to access your memories.
                </p>

                <div className="flex space-x-3">
                  <motion.button
                    whileTap={{ scale: 0.98 }}
                    onClick={() => setShowLogoutConfirm(false)}
                    className={`flex-1 glass-card py-3 rounded-[16px] font-medium backdrop-blur-xl border ${colors.glassBorder} hover:border-white/40 transition-all duration-200 ${colors.textPrimary}`}
                  >
                    Cancel
                  </motion.button>
                  <motion.button
                    whileTap={{ scale: 0.98 }}
                    onClick={handleLogout}
                    className="flex-1 bg-gradient-to-r from-red-600 to-red-500 py-3 rounded-[16px] text-white font-semibold"
                    style={{ 
                      boxShadow: '0 4px 16px rgba(239, 68, 68, 0.4)' 
                    }}
                  >
                    Logout
                  </motion.button>
                </div>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};

export default SettingsScreen;