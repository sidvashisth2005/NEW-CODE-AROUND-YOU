import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Camera, Settings, Bell, Search, MapPin, Heart, MessageCircle, Share, Sparkles, RotateCcw, RefreshCw } from 'lucide-react';
import { ScrollArea } from './ui/scroll-area';
import { useTheme } from './ThemeContext';

interface HomeScreenProps {
  onNavigate: (screen: string, isSubScreen?: boolean, data?: any) => void;
}

const HomeScreen: React.FC<HomeScreenProps> = ({ onNavigate }) => {
  const { colors, isDarkMode, hapticFeedback, playSound } = useTheme();
  const [isScanning, setIsScanning] = useState(false);
  const [detectedMemories, setDetectedMemories] = useState<any[]>([]);
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [pullDistance, setPullDistance] = useState(0);
  const [startY, setStartY] = useState(0);
  const [isPulling, setIsPulling] = useState(false);

  // Generate memory position that avoids the center crosshair area (40-60% of screen)
  const generateSafePosition = () => {
    const centerX = 50;
    const centerY = 50;
    const exclusionRadius = 15; // 15% radius around center
    
    let x, y;
    do {
      x = Math.random() * 80 + 10; // 10% to 90%
      y = Math.random() * 80 + 10; // 10% to 90%
    } while (
      // Avoid center area (crosshair zone)
      Math.abs(x - centerX) < exclusionRadius && Math.abs(y - centerY) < exclusionRadius
    );
    
    return { x, y };
  };

  // Simulate AR scanning with safe positioning
  useEffect(() => {
    const interval = setInterval(() => {
      if (Math.random() > 0.7) {
        const position = generateSafePosition();
        const newMemory = {
          id: Date.now(),
          type: ['text', 'photo', 'video', 'audio'][Math.floor(Math.random() * 4)],
          title: ['Amazing sunset', 'Coffee break', 'Street art', 'Good vibes'][Math.floor(Math.random() * 4)],
          author: ['Sarah', 'Mike', 'Alex', 'Emma'][Math.floor(Math.random() * 4)],
          distance: Math.floor(Math.random() * 50) + 10,
          x: position.x,
          y: position.y,
          likes: Math.floor(Math.random() * 100) + 5,
        };
        setDetectedMemories(prev => [...prev, newMemory].slice(-5));
      }
    }, 3000);

    return () => clearInterval(interval);
  }, []);

  const handleRefresh = async () => {
    setIsRefreshing(true);
    hapticFeedback && hapticFeedback('medium');
    playSound && playSound('tap');
    
    // Simulate refresh
    await new Promise(resolve => setTimeout(resolve, 1500));
    // Clear and regenerate memories
    setDetectedMemories([]);
    setTimeout(() => {
      const newMemories = Array.from({ length: 3 }, (_, i) => {
        const position = generateSafePosition();
        return {
          id: Date.now() + i,
          type: ['text', 'photo', 'video', 'audio'][Math.floor(Math.random() * 4)],
          title: ['New discovery', 'Fresh memory', 'Recent find', 'Latest share'][Math.floor(Math.random() * 4)],
          author: ['Sarah', 'Mike', 'Alex', 'Emma'][Math.floor(Math.random() * 4)],
          distance: Math.floor(Math.random() * 50) + 10,
          x: position.x,
          y: position.y,
          likes: Math.floor(Math.random() * 100) + 5,
        };
      });
      setDetectedMemories(newMemories);
    }, 500);
    setIsRefreshing(false);
    playSound && playSound('success');
  };

  // Pull to refresh handlers
  const handleTouchStart = (e: React.TouchEvent) => {
    if (window.scrollY === 0) {
      setStartY(e.touches[0].clientY);
      setIsPulling(true);
    }
  };

  const handleTouchMove = (e: React.TouchEvent) => {
    if (!isPulling || window.scrollY > 0) return;
    
    const currentY = e.touches[0].clientY;
    const distance = Math.max(0, currentY - startY);
    
    if (distance > 0) {
      e.preventDefault();
      setPullDistance(Math.min(distance, 100));
    }
  };

  const handleTouchEnd = () => {
    if (pullDistance > 60 && !isRefreshing) {
      handleRefresh();
    }
    setIsPulling(false);
    setPullDistance(0);
    setStartY(0);
  };

  const handleMemoryTap = (memory: any) => {
    hapticFeedback && hapticFeedback('light');
    playSound && playSound('tap');
    onNavigate('memory-detail', true, memory);
  };

  const handleScanToggle = () => {
    setIsScanning(!isScanning);
    hapticFeedback && hapticFeedback('light');
    playSound && playSound('tap');
  };

  return (
    <div 
      className={`h-full w-full flex flex-col relative overflow-hidden bg-gradient-to-br ${colors.background}`}
      onTouchStart={handleTouchStart}
      onTouchMove={handleTouchMove}
      onTouchEnd={handleTouchEnd}
    >
      {/* Pull to Refresh Indicator */}
      <AnimatePresence>
        {(isPulling && pullDistance > 20) || isRefreshing ? (
          <motion.div
            initial={{ opacity: 0, y: -50 }}
            animate={{ 
              opacity: 1, 
              y: isPulling ? Math.max(-30, -50 + pullDistance) : -10
            }}
            exit={{ opacity: 0, y: -50 }}
            className="absolute top-16 left-1/2 transform -translate-x-1/2 z-40"
          >
            <div 
              className={`glass-card rounded-full p-3 backdrop-blur-xl border ${colors.borderMedium}`}
              style={{ 
                background: colors.glassBackground,
                boxShadow: colors.shadowPurple
              }}
            >
              <motion.div
                animate={isRefreshing ? { rotate: 360 } : {}}
                transition={isRefreshing ? { duration: 1, repeat: Infinity, ease: "linear" } : {}}
              >
                <RefreshCw size={20} className={colors.textPrimary} />
              </motion.div>
            </div>
          </motion.div>
        ) : null}
      </AnimatePresence>

      {/* Simulated Camera Background */}
      <div className="absolute inset-0 bg-gradient-to-br from-gray-900 to-black">
        <div className="absolute inset-0 opacity-20">
          <div className="w-full h-full bg-gradient-radial from-transparent via-transparent to-gray-900"></div>
        </div>
        
        {/* Enhanced Scanning lines effect */}
        <AnimatePresence>
          {isScanning && (
            <motion.div
              initial={{ y: '-100%' }}
              animate={{ y: '100vh' }}
              exit={{ y: '100vh' }}
              transition={{ duration: 2, repeat: Infinity, ease: "linear" }}
              className="absolute left-0 w-full h-0.5 bg-gradient-to-r from-transparent via-purple-500 to-transparent opacity-60"
            />
          )}
        </AnimatePresence>
      </div>

      {/* Top Bar - Enhanced with proper theming */}
      <div className="relative z-30 pt-12 px-6 pb-4 bg-gradient-to-b from-black/60 via-black/20 to-transparent">
        <motion.div
          initial={{ opacity: 0, y: -30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, type: "spring", bounce: 0.3 }}
          className="flex items-center justify-between"
        >
          {/* User Avatar */}
          <motion.div
            whileTap={{ scale: 0.9 }}
            whileHover={{ scale: 1.05 }}
            onClick={() => {
              hapticFeedback && hapticFeedback('light');
              playSound && playSound('tap');
              onNavigate('profile');
            }}
            className={`w-10 h-10 rounded-full bg-gradient-to-r from-purple-500 to-blue-500 flex items-center justify-center glass-card border ${colors.borderMedium}`}
            style={{ 
              background: colors.glassBackground,
              boxShadow: colors.shadowPurple
            }}
          >
            <span className={`font-semibold ${colors.textPrimary}`}>A</span>
          </motion.div>

          {/* Location Info */}
          <motion.div
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ delay: 0.1, duration: 0.5, type: "spring" }}
            className={`glass-card px-4 py-2 rounded-full flex items-center space-x-2 border ${colors.borderMedium}`}
            style={{ 
              background: colors.glassBackground,
              boxShadow: colors.shadowMd
            }}
          >
            <MapPin size={16} className={colors.accent} />
            <span className={`text-sm font-medium ${colors.textPrimary}`}>Downtown SF</span>
          </motion.div>

          {/* Action Buttons */}
          <div className="flex items-center space-x-3">
            {/* Refresh Button */}
            <motion.button
              whileTap={{ scale: 0.9 }}
              whileHover={{ scale: 1.05 }}
              onClick={handleRefresh}
              disabled={isRefreshing}
              className={`w-10 h-10 rounded-full glass-card flex items-center justify-center border ${colors.borderMedium} transition-all duration-200`}
              style={{ 
                background: colors.glassBackground,
                boxShadow: colors.shadowSm
              }}
            >
              <motion.div
                animate={isRefreshing ? { rotate: 360 } : {}}
                transition={isRefreshing ? { duration: 1, repeat: Infinity, ease: "linear" } : {}}
              >
                <RefreshCw size={18} className={colors.textPrimary} />
              </motion.div>
            </motion.button>

            {/* Search/Scanner Button */}
            <motion.button
              whileTap={{ scale: 0.9 }}
              whileHover={{ scale: 1.05 }}
              onClick={handleScanToggle}
              className={`w-10 h-10 rounded-full glass-card flex items-center justify-center border transition-all duration-300 ${
                isScanning 
                  ? `${colors.borderMedium} bg-gradient-to-r from-purple-600 to-purple-500`
                  : colors.borderMedium
              }`}
              style={{ 
                background: isScanning ? undefined : colors.glassBackground,
                boxShadow: isScanning ? colors.shadowPurple : colors.shadowSm
              }}
            >
              <Search size={18} className={isScanning ? 'text-white' : colors.textPrimary} />
            </motion.button>
            
            {/* Notification Button */}
            <motion.button
              whileTap={{ scale: 0.9 }}
              whileHover={{ scale: 1.05 }}
              onClick={() => {
                hapticFeedback && hapticFeedback('light');
                playSound && playSound('tap');
                onNavigate('notifications', true);
              }}
              className={`w-10 h-10 rounded-full glass-card flex items-center justify-center relative border ${colors.borderMedium} transition-all duration-200`}
              style={{ 
                background: colors.glassBackground,
                boxShadow: colors.shadowSm
              }}
            >
              <Bell size={18} className={colors.textPrimary} />
              <motion.div
                animate={{
                  scale: [1, 1.2, 1],
                }}
                transition={{
                  duration: 2,
                  repeat: Infinity,
                  ease: "easeInOut",
                }}
                className="absolute -top-1 -right-1 w-3 h-3 bg-red-500 rounded-full"
                style={{ boxShadow: colors.shadowSm }}
              />
            </motion.button>
          </div>
        </motion.div>
      </div>

      {/* Memory Counter */}
      <AnimatePresence>
        {detectedMemories.length > 0 && (
          <motion.div
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 0.8 }}
            transition={{ type: "spring", bounce: 0.3 }}
            className="absolute top-28 right-6 z-30"
          >
            <div 
              className={`glass-card px-3 py-2 rounded-full flex items-center space-x-2 border ${colors.borderMedium}`}
              style={{ 
                background: colors.glassBackground,
                boxShadow: colors.shadowPurple
              }}
            >
              <div className="w-2 h-2 bg-green-400 rounded-full animate-pulse"></div>
              <span className={`font-medium text-sm ${colors.textPrimary}`}>{detectedMemories.length}</span>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Main AR Content Area */}
      <div className="flex-1 relative">
        {/* Enhanced AR Memory Markers - Positioned outside crosshair area */}
        <AnimatePresence>
          {detectedMemories.map((memory, index) => (
            <motion.button
              key={memory.id}
              initial={{ scale: 0, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0, opacity: 0 }}
              transition={{ duration: 0.5, delay: index * 0.1, type: "spring", bounce: 0.4 }}
              whileTap={{ scale: 0.9 }}
              whileHover={{ scale: 1.05 }}
              onClick={() => handleMemoryTap(memory)}
              className="absolute z-20"
              style={{
                left: `${memory.x}%`,
                top: `${memory.y}%`,
                transform: 'translate(-50%, -50%)'
              }}
            >
              {/* Memory Pin */}
              <div className="relative">
                {/* Enhanced Pulse Animation */}
                <motion.div
                  className="absolute inset-0 bg-purple-500 rounded-full"
                  animate={{
                    scale: [1, 2.5, 1],
                    opacity: [0.6, 0, 0.6],
                  }}
                  transition={{
                    duration: 3,
                    repeat: Infinity,
                    ease: "easeInOut",
                  }}
                />
                
                {/* Main Pin with proper theming */}
                <div 
                  className={`relative w-12 h-12 glass-card rounded-full flex items-center justify-center border ${colors.borderMedium} bg-gradient-to-r from-purple-600 to-purple-500`}
                  style={{ 
                    boxShadow: colors.shadowPurple
                  }}
                >
                  <Sparkles size={20} className="text-white" />
                </div>

                {/* Enhanced Memory Preview Card */}
                <motion.div
                  initial={{ opacity: 0, y: 10, scale: 0.8 }}
                  animate={{ opacity: 1, y: 0, scale: 1 }}
                  transition={{ delay: 0.3, duration: 0.4, type: "spring" }}
                  className={`absolute ${memory.y < 50 ? 'top-14' : 'bottom-14'} left-1/2 transform -translate-x-1/2 w-48 glass-card rounded-[16px] p-3 backdrop-blur-xl border ${colors.borderMedium}`}
                  style={{ 
                    background: colors.glassBackground,
                    boxShadow: colors.shadowLg
                  }}
                >
                  <div className={`text-sm font-medium mb-1 ${colors.textPrimary}`}>{memory.title}</div>
                  <div className={`text-xs mb-2 ${colors.accent}`}>by {memory.author} • {memory.distance}m away</div>
                  <div className={`flex items-center justify-between text-xs ${colors.textSecondary}`}>
                    <div className="flex items-center space-x-1">
                      <Heart size={12} />
                      <span>{memory.likes}</span>
                    </div>
                    <div className="capitalize">{memory.type}</div>
                  </div>
                </motion.div>
              </div>
            </motion.button>
          ))}
        </AnimatePresence>

        {/* AR Interface Overlay - Original crosshair only */}
        <div className="absolute inset-0 pointer-events-none">
          {/* Corner Guides */}
          <div className="absolute top-1/4 left-6 w-8 h-8 border-l-2 border-t-2 border-white/30 rounded-tl-lg"></div>
          <div className="absolute top-1/4 right-6 w-8 h-8 border-r-2 border-t-2 border-white/30 rounded-tr-lg"></div>
          <div className="absolute bottom-1/4 left-6 w-8 h-8 border-l-2 border-b-2 border-white/30 rounded-bl-lg"></div>
          <div className="absolute bottom-1/4 right-6 w-8 h-8 border-r-2 border-b-2 border-white/30 rounded-br-lg"></div>

          {/* Center Crosshair */}
          <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-6 h-6">
            <div className="absolute top-1/2 left-0 right-0 h-px bg-white/40"></div>
            <div className="absolute left-1/2 top-0 bottom-0 w-px bg-white/40"></div>
            <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-2 h-2 border border-white/60 rounded-full bg-white/20"></div>
          </div>
        </div>
      </div>

      {/* Bottom Instructions - Enhanced with proper theming */}
      <div className="relative z-20 p-6 pb-8 bg-gradient-to-t from-black/40 via-black/20 to-transparent">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.8, duration: 0.5, type: "spring" }}
        >
          <div 
            className={`glass-card rounded-[18px] p-4 backdrop-blur-xl text-center border ${colors.borderMedium}`}
            style={{ 
              background: colors.glassBackground,
              boxShadow: colors.shadowLg
            }}
          >
            <div className="flex items-center justify-center space-x-2 mb-2">
              <motion.div
                animate={{
                  rotate: [0, 360],
                }}
                transition={{
                  duration: 3,
                  repeat: Infinity,
                  ease: "linear"
                }}
              >
                <Sparkles size={16} className={colors.accent} />
              </motion.div>
              <span className={`font-medium ${colors.textPrimary}`}>AR Mode Active</span>
            </div>
            <p className={`text-sm leading-relaxed ${colors.textSecondary}`}>
              {isRefreshing 
                ? "Refreshing memories..." 
                : isScanning 
                ? "Scanning for memories around you..." 
                : "Point your camera to discover memories"
              }
            </p>
            <p className={`text-xs mt-2 ${colors.textSecondary}`}>
              Pull down to refresh
            </p>
          </div>
        </motion.div>
      </div>
    </div>
  );
};

export default HomeScreen;