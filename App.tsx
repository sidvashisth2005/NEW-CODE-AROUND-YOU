import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Camera, Map, MessageCircle, Route, User, Plus } from 'lucide-react';
import { ThemeProvider, useTheme } from './components/ThemeContext';

// Import screens
import SplashScreen from './components/SplashScreen';
import OnboardingScreen from './components/OnboardingScreen';
import LoginScreen from './components/LoginScreen';
import HomeScreen from './components/HomeScreen';
import AroundScreen from './components/AroundScreen';
import ChatScreen from './components/ChatScreen';
import TrailsScreen from './components/TrailsScreen';
import ProfileScreen from './components/ProfileScreen';
import CreateMemoryScreen from './components/CreateMemoryScreen';
import CreateTrailScreen from './components/CreateTrailScreen';
import TrailDetailScreen from './components/TrailDetailScreen';
import SettingsScreen from './components/SettingsScreen';
import MemoryDetailScreen from './components/MemoryDetailScreen';
import NotificationsScreen from './components/NotificationsScreen';
import ChatSettingsScreen from './components/ChatSettingsScreen';
import ChatInterface from './components/ChatInterface';
import AdminDashboardScreen from './components/AdminDashboardScreen';

// Streak context for managing user streaks
export const StreakContext = React.createContext({
  streaks: {},
  updateStreak: (userId: string) => {},
  getTotalStreaks: () => 0
});

export default function App() {
  const [currentScreen, setCurrentScreen] = useState('splash');
  const [activeTab, setActiveTab] = useState('home');
  const [isOnboarded, setIsOnboarded] = useState(false);
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [isInSubScreen, setIsInSubScreen] = useState(false);
  const [selectedMemory, setSelectedMemory] = useState(null);
  const [selectedChat, setSelectedChat] = useState(null);
  const [selectedTrail, setSelectedTrail] = useState(null);
  
  // Streak management
  const [streaks, setStreaks] = useState({
    'sarah-chen': 5,
    'mike-johnson': 12,
    'alex-rivera': 3,
    'emma-watson': 8
  });

  const updateStreak = (userId: string) => {
    setStreaks(prev => ({
      ...prev,
      [userId]: (prev[userId] || 0) + 1
    }));
  };

  const getTotalStreaks = () => {
    return Object.values(streaks).reduce((total, count) => total + count, 0);
  };

  const handleSplashComplete = () => {
    setCurrentScreen('onboarding');
  };

  const handleOnboardingComplete = () => {
    setIsOnboarded(true);
    setCurrentScreen('login');
  };

  const handleLoginComplete = () => {
    setIsLoggedIn(true);
    setCurrentScreen('home');
    setActiveTab('home');
    setIsInSubScreen(false);
  };

  const handleLogout = () => {
    setIsLoggedIn(false);
    setIsOnboarded(false);
    setCurrentScreen('splash');
    setActiveTab('home');
    setIsInSubScreen(false);
  };

  const navigateToScreen = (screen: string, isSubScreen = false, data = null) => {
    setCurrentScreen(screen);
    setIsInSubScreen(isSubScreen);
    
    if (data) {
      if (screen === 'memory-detail') {
        setSelectedMemory(data);
      } else if (screen === 'chat-settings') {
        setSelectedChat(data);
      } else if (screen === 'chat-interface') {
        setSelectedChat(data);
      } else if (screen === 'trail-detail') {
        setSelectedTrail(data);
      }
    }
    
    if (['home', 'around', 'chat', 'trails', 'profile'].includes(screen)) {
      setActiveTab(screen);
    }
  };

  const renderScreen = () => {
    switch (currentScreen) {
      case 'splash':
        return <SplashScreen onComplete={handleSplashComplete} />;
      case 'onboarding':
        return <OnboardingScreen onComplete={handleOnboardingComplete} />;
      case 'login':
        return <LoginScreen onComplete={handleLoginComplete} />;
      case 'home':
        return <HomeScreen onNavigate={navigateToScreen} />;
      case 'around':
        return <AroundScreen onNavigate={navigateToScreen} />;
      case 'chat':
        return <ChatScreen onNavigate={navigateToScreen} />;
      case 'chat-interface':
        return (
          <ChatInterface 
            chat={selectedChat} 
            onBack={() => navigateToScreen('chat')}
            onNavigate={navigateToScreen}
          />
        );
      case 'trails':
        return <TrailsScreen onNavigate={navigateToScreen} />;
      case 'trail-detail':
        return <TrailDetailScreen onNavigate={navigateToScreen} trail={selectedTrail} />;
      case 'profile':
        return <ProfileScreen onNavigate={navigateToScreen} streaks={streaks} totalStreaks={getTotalStreaks()} />;
      case 'create':
        return <CreateMemoryScreen onNavigate={navigateToScreen} />;
      case 'create-trail':
        return <CreateTrailScreen onNavigate={navigateToScreen} />;
      case 'settings':
        return <SettingsScreen onNavigate={navigateToScreen} onLogout={handleLogout} />;
      case 'memory-detail':
        return <MemoryDetailScreen onNavigate={navigateToScreen} memory={selectedMemory} updateStreak={updateStreak} />;
      case 'notifications':
        return <NotificationsScreen onNavigate={navigateToScreen} />;
      case 'chat-settings':
        return <ChatSettingsScreen onNavigate={navigateToScreen} chat={selectedChat} />;
      case 'admin-dashboard':
        return <AdminDashboardScreen onNavigate={navigateToScreen} />;
      default:
        return <HomeScreen onNavigate={navigateToScreen} />;
    }
  };

  const tabItems = [
    { id: 'home', icon: Camera, label: 'Home' },
    { id: 'around', icon: Map, label: 'Around' },
    { id: 'chat', icon: MessageCircle, label: 'Chat' },
    { id: 'trails', icon: Route, label: 'Trails' },
    { id: 'profile', icon: User, label: 'Profile' },
  ];

  // Hide navigation in special screens and sub-screens
  const showNavigation = isLoggedIn && 
    !['splash', 'onboarding', 'login', 'create', 'create-trail', 'trail-detail', 'settings', 'memory-detail', 'notifications', 'chat-settings', 'chat-interface', 'admin-dashboard'].includes(currentScreen) && 
    !isInSubScreen;

  const showCreateButton = isLoggedIn && 
    currentScreen === 'home' && 
    !isInSubScreen;

  const showCreateTrailButton = isLoggedIn && 
    currentScreen === 'trails' && 
    !isInSubScreen;

  return (
    <ThemeProvider>
      <StreakContext.Provider value={{ streaks, updateStreak, getTotalStreaks }}>
        <AppContent 
          currentScreen={currentScreen}
          renderScreen={renderScreen}
          tabItems={tabItems}
          showNavigation={showNavigation}
          showCreateButton={showCreateButton}
          showCreateTrailButton={showCreateTrailButton}
          navigateToScreen={navigateToScreen}
        />
      </StreakContext.Provider>
    </ThemeProvider>
  );
}

interface AppContentProps {
  currentScreen: string;
  renderScreen: () => React.ReactNode;
  tabItems: any[];
  showNavigation: boolean;
  showCreateButton: boolean;
  showCreateTrailButton: boolean;
  navigateToScreen: (screen: string, isSubScreen?: boolean, data?: any) => void;
}

const AppContent: React.FC<AppContentProps> = ({
  currentScreen,
  renderScreen,
  tabItems,
  showNavigation,
  showCreateButton,
  showCreateTrailButton,
  navigateToScreen
}) => {
  const { colors, isDarkMode, hapticFeedback, playSound } = useTheme();
  const [activeTab, setActiveTab] = useState('home');

  const handleTabClick = (tabId: string) => {
    setActiveTab(tabId);
    navigateToScreen(tabId);
    hapticFeedback('light');
    playSound('tap');
  };

  const handleCreateClick = (type: 'memory' | 'trail') => {
    hapticFeedback('medium');
    playSound('tap');
    navigateToScreen(type === 'memory' ? 'create' : 'create-trail');
  };

  return (
    <div className={`h-screen w-full bg-gradient-to-br ${colors.background} relative flex flex-col`}>
      {/* Main Content Area */}
      <div className="flex-1 relative min-h-0">
        <AnimatePresence mode="wait">
          <motion.div
            key={currentScreen}
            initial={{ opacity: 0, scale: 0.98 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 1.02 }}
            transition={{ 
              duration: currentScreen === 'splash' ? 0.8 : 0.3, 
              ease: [0.4, 0.0, 0.2, 1],
              type: "tween"
            }}
            className="h-full w-full"
          >
            {renderScreen()}
          </motion.div>
        </AnimatePresence>
      </div>

      {/* Enhanced Bottom Navigation */}
      <AnimatePresence>
        {showNavigation && (
          <motion.div
            initial={{ y: 100, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            exit={{ y: 100, opacity: 0 }}
            transition={{ 
              duration: 0.4, 
              ease: [0.4, 0.0, 0.2, 1],
              type: "spring",
              bounce: 0.2
            }}
            className="fixed bottom-0 left-0 right-0 z-50 p-4 pointer-events-none"
          >
            <div 
              className={`glass-nav rounded-[24px] px-2 py-2 mx-auto max-w-md backdrop-blur-xl border ${colors.borderMedium} pointer-events-auto`}
              style={{ 
                background: colors.navBackground,
                boxShadow: colors.shadowXl
              }}
            >
              <div className="flex items-center justify-between">
                {tabItems.map((item) => {
                  const Icon = item.icon;
                  const isActive = activeTab === item.id;
                  
                  return (
                    <motion.button
                      key={item.id}
                      whileTap={{ scale: 0.9 }}
                      whileHover={{ scale: 1.05 }}
                      onClick={() => handleTabClick(item.id)}
                      className={`relative flex flex-col items-center px-3 py-2 rounded-xl transition-all duration-300 ${
                        isActive ? 'text-white' : colors.textSecondary
                      }`}
                    >
                      {isActive && (
                        <motion.div
                          layoutId="activeTab"
                          className="absolute inset-0 bg-gradient-to-r from-purple-600 to-purple-500 rounded-xl"
                          style={{ 
                            boxShadow: colors.shadowPurple
                          }}
                          transition={{ 
                            type: "spring", 
                            bounce: 0.2, 
                            duration: 0.5 
                          }}
                        />
                      )}
                      <motion.div
                        animate={{ scale: isActive ? 1.1 : 1 }}
                        transition={{ type: "spring", bounce: 0.3 }}
                      >
                        <Icon 
                          size={20} 
                          className="relative z-10 transition-all duration-200"
                        />
                      </motion.div>
                      <span className="relative z-10 text-xs mt-1 font-medium">
                        {item.label}
                      </span>
                    </motion.button>
                  );
                })}
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Enhanced Floating Create Button */}
      <AnimatePresence>
        {showCreateButton && (
          <motion.button
            initial={{ scale: 0, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0, opacity: 0 }}
            transition={{ 
              delay: 0.1, 
              duration: 0.4, 
              type: "spring",
              bounce: 0.4
            }}
            whileTap={{ scale: 0.85 }}
            whileHover={{ scale: 1.05 }}
            onClick={() => handleCreateClick('memory')}
            className={`fixed right-6 z-40 w-14 h-14 bg-gradient-to-r from-yellow-400 to-yellow-300 rounded-full flex items-center justify-center ${
              showNavigation ? 'bottom-24' : 'bottom-8'
            }`}
            style={{ 
              boxShadow: colors.shadowGold
            }}
          >
            <Plus size={26} className="text-black" />
            <motion.div
              className="absolute inset-0 rounded-full bg-gradient-to-r from-yellow-400 to-yellow-300"
              animate={{
                scale: [1, 1.3, 1],
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
      </AnimatePresence>

      {/* Enhanced Floating Create Trail Button */}
      <AnimatePresence>
        {showCreateTrailButton && (
          <motion.button
            initial={{ scale: 0, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0, opacity: 0 }}
            transition={{ 
              delay: 0.1, 
              duration: 0.4, 
              type: "spring",
              bounce: 0.4
            }}
            whileTap={{ scale: 0.85 }}
            whileHover={{ scale: 1.05 }}
            onClick={() => handleCreateClick('trail')}
            className={`fixed right-6 z-40 w-14 h-14 bg-gradient-to-r from-purple-600 to-purple-500 rounded-full flex items-center justify-center ${
              showNavigation ? 'bottom-24' : 'bottom-8'
            }`}
            style={{ 
              boxShadow: colors.shadowPurple
            }}
          >
            <Route size={26} className="text-white" />
            <motion.div
              className="absolute inset-0 rounded-full bg-gradient-to-r from-purple-600 to-purple-500"
              animate={{
                scale: [1, 1.3, 1],
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
      </AnimatePresence>

      {/* Navigation Spacer */}
      {showNavigation && <div className="h-20 flex-shrink-0" />}
    </div>
  );
};