import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Search, Filter, MapPin, Heart, MessageCircle, Share, Clock, Zap, TrendingUp, RotateCcw } from 'lucide-react';
import { Slider } from './ui/slider';
import { useTheme } from './ThemeContext';
import ParticleSystem from './ParticleSystem';

interface AroundScreenProps {
  onNavigate: (screen: string, isSubScreen?: boolean, data?: any) => void;
}

const AroundScreen: React.FC<AroundScreenProps> = ({ onNavigate }) => {
  const { colors, isDarkMode, hapticFeedback, playSound } = useTheme();
  const [activeFilter, setActiveFilter] = useState('all');
  const [mapRadius, setMapRadius] = useState([500]);
  const [isReloading, setIsReloading] = useState(false);
  const [particleState, setParticleState] = useState({ trigger: false, x: 0, y: 0 });
  const [memories, setMemories] = useState([
    {
      id: 1,
      title: "Hidden Coffee Gem",
      type: "photo",
      author: "Sarah Chen",
      distance: 120,
      likes: 34,
      comments: 12,
      time: "2h ago",
      isLiked: false,
      description: "Found this amazing hidden coffee spot with the best latte art!",
      location: { x: 60, y: 40 }
    },
    {
      id: 2,
      title: "Street Art Marvel",
      type: "video",
      author: "Mike Johnson",
      distance: 85,
      likes: 128,
      comments: 23,
      time: "4h ago",
      isLiked: true,
      description: "Incredible mural by a local artist, the details are mind-blowing",
      location: { x: 30, y: 60 }
    },
    {
      id: 3,
      title: "Golden Hour Magic",
      type: "photo",
      author: "Alex Rivera",
      distance: 200,
      likes: 89,
      comments: 18,
      time: "1d ago",
      isLiked: false,
      description: "Perfect sunset spot overlooking the city skyline",
      location: { x: 75, y: 25 }
    },
    {
      id: 4,
      title: "Secret Garden",
      type: "audio",
      author: "Emma Watson",
      distance: 150,
      likes: 67,
      comments: 8,
      time: "2d ago",
      isLiked: true,
      description: "Peaceful sounds from a hidden garden in the city center",
      location: { x: 45, y: 70 }
    }
  ]);

  const filters = [
    { id: 'all', label: 'All', icon: Filter },
    { id: 'recent', label: 'Recent', icon: Clock },
    { id: 'popular', label: 'Popular', icon: TrendingUp },
    { id: 'nearby', label: 'Nearby', icon: Zap }
  ];

  const handleReload = async () => {
    setIsReloading(true);
    hapticFeedback('medium');
    playSound('tap');
    
    await new Promise(resolve => setTimeout(resolve, 1500));
    
    // Simulate new data
    const newMemories = memories.map(memory => ({
      ...memory,
      location: {
        x: Math.random() * 80 + 10,
        y: Math.random() * 60 + 20
      }
    }));
    
    setMemories(newMemories);
    setIsReloading(false);
    playSound('success');
  };

  const handleMemoryTap = (memory: any, event: React.MouseEvent) => {
    const rect = event.currentTarget.getBoundingClientRect();
    const x = rect.left + rect.width / 2;
    const y = rect.top + rect.height / 2;
    
    setParticleState({ trigger: true, x, y });
    hapticFeedback('light');
    playSound('tap');
    
    setTimeout(() => {
      onNavigate('memory-detail', true, memory);
      setParticleState({ trigger: false, x: 0, y: 0 });
    }, 300);
  };

  const handleFilterChange = (filterId: string) => {
    setActiveFilter(filterId);
    hapticFeedback('light');
    playSound('tap');
  };

  const getMemoryIcon = (type: string) => {
    switch (type) {
      case 'photo': return '📸';
      case 'video': return '🎥';
      case 'audio': return '🎵';
      case 'text': return '📝';
      default: return '📄';
    }
  };

  const filteredMemories = memories.filter(memory => {
    switch (activeFilter) {
      case 'recent':
        return memory.time.includes('h') || memory.time.includes('1d');
      case 'popular':
        return memory.likes > 100;
      case 'nearby':
        return memory.distance < 150;
      default:
        return true;
    }
  });

  return (
    <div className={`h-full w-full flex flex-col bg-gradient-to-br ${colors.background} relative`}>
      {/* Particle System */}
      <ParticleSystem 
        trigger={particleState.trigger} 
        centerX={particleState.x} 
        centerY={particleState.y}
        onComplete={() => setParticleState({ trigger: false, x: 0, y: 0 })}
      />

      {/* Header with Enhanced Shadows */}
      <div className="flex-shrink-0 pt-12 px-6 pb-4">
        <motion.div
          initial={{ opacity: 0, y: -30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, type: "spring", bounce: 0.3 }}
        >
          <div className="flex items-center justify-between mb-6">
            <div>
              <h1 className={`text-2xl font-bold ${colors.textPrimary}`}>Around You</h1>
              <p className={`text-sm ${colors.textSecondary}`}>Discover nearby memories</p>
            </div>
            
            <motion.button
              whileTap={{ scale: 0.9 }}
              onClick={handleReload}
              disabled={isReloading}
              className={`w-10 h-10 rounded-full glass-card flex items-center justify-center border ${colors.borderMedium} transition-all duration-200`}
              style={{ 
                background: colors.glassBackground,
                boxShadow: colors.shadowMd
              }}
            >
              <motion.div
                animate={isReloading ? { rotate: 360 } : {}}
                transition={isReloading ? { duration: 1, repeat: Infinity, ease: "linear" } : {}}
              >
                <RotateCcw size={18} className={colors.textPrimary} />
              </motion.div>
            </motion.button>
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
                placeholder="Search memories around you..."
                className={`flex-1 bg-transparent ${colors.textPrimary} placeholder-gray-500 focus:outline-none`}
              />
            </div>
          </motion.div>

          {/* Enhanced Filter Buttons with Purple Selection */}
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.2, duration: 0.5, type: "spring" }}
            className="flex space-x-3 overflow-x-auto pb-2 scrollbar-hide"
          >
            {filters.map((filter, index) => {
              const Icon = filter.icon;
              const isActive = activeFilter === filter.id;
              
              return (
                <motion.button
                  key={filter.id}
                  initial={{ opacity: 0, scale: 0.8 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: index * 0.05, duration: 0.4, type: "spring" }}
                  whileTap={{ scale: 0.95 }}
                  whileHover={{ scale: 1.05 }}
                  onClick={() => handleFilterChange(filter.id)}
                  className={`flex-shrink-0 glass-card px-4 py-2 rounded-full flex items-center space-x-2 transition-all duration-300 border ${
                    isActive 
                      ? colors.filterActive
                      : colors.filterInactive
                  }`}
                  style={{ 
                    boxShadow: isActive ? colors.shadowPurple : colors.shadowSm
                  }}
                >
                  <Icon size={16} className={isActive ? 'text-white' : 'inherit'} />
                  <span className={`font-medium ${isActive ? 'text-white' : 'inherit'}`}>
                    {filter.label}
                  </span>
                </motion.button>
              );
            })}
          </motion.div>
        </motion.div>
      </div>

      {/* Map Area - Original Style */}
      <div className="flex-1 relative">
        {/* Background Pattern */}
        <div className="absolute inset-0">
          <div className="w-full h-full bg-gradient-to-br from-purple-900/20 to-blue-900/20" />
          <div className="absolute inset-0 opacity-30">
            <div className="grid grid-cols-8 grid-rows-12 h-full gap-1 p-4">
              {Array.from({ length: 96 }).map((_, i) => (
                <div key={i} className="bg-purple-500/10 rounded-sm" />
              ))}
            </div>
          </div>
        </div>

        {/* Enhanced Memory Markers */}
        <AnimatePresence>
          {filteredMemories.map((memory, index) => (
            <motion.button
              key={memory.id}
              initial={{ scale: 0, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0, opacity: 0 }}
              transition={{ 
                delay: index * 0.1, 
                duration: 0.6, 
                type: "spring", 
                bounce: 0.4 
              }}
              whileTap={{ scale: 0.9 }}
              whileHover={{ scale: 1.1 }}
              onClick={(e) => handleMemoryTap(memory, e)}
              className="absolute z-20"
              style={{
                left: `${memory.location.x}%`,
                top: `${memory.location.y}%`,
                transform: 'translate(-50%, -50%)'
              }}
            >
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
                
                {/* Memory Pin with Enhanced Shadow */}
                <div 
                  className={`relative w-12 h-12 glass-card rounded-full flex items-center justify-center border ${colors.borderMedium} bg-gradient-to-r from-purple-600 to-purple-500`}
                  style={{ 
                    boxShadow: colors.shadowPurple
                  }}
                >
                  <span className="text-lg">{getMemoryIcon(memory.type)}</span>
                </div>

                {/* Distance Badge with Shadow */}
                <motion.div 
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  transition={{ delay: 0.3, type: "spring" }}
                  className={`absolute -top-2 -right-2 glass-card rounded-full px-2 py-1 border ${colors.borderLight}`}
                  style={{ 
                    background: colors.glassBackground,
                    boxShadow: colors.shadowSm
                  }}
                >
                  <span className={`text-xs font-medium ${colors.textPrimary}`}>{memory.distance}m</span>
                </motion.div>
              </div>
            </motion.button>
          ))}
        </AnimatePresence>

        {/* Center Indicator */}
        <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 pointer-events-none">
          <motion.div
            animate={{
              scale: [1, 1.05, 1],
              opacity: [0.3, 0.1, 0.3],
            }}
            transition={{
              duration: 4,
              repeat: Infinity,
              ease: "easeInOut",
            }}
            className="w-32 h-32 border-2 border-purple-500/30 rounded-full"
          />
        </div>
      </div>

      {/* Bottom Stats Panel with Enhanced Shadows */}
      <div className="flex-shrink-0 p-6">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5, duration: 0.6, type: "spring" }}
          className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.borderMedium}`}
          style={{ 
            background: colors.glassBackground,
            boxShadow: colors.shadowLg
          }}
        >
          <div className="grid grid-cols-3 gap-6">
            {[
              { label: 'Memories', value: filteredMemories.length },
              { label: 'Radius', value: `${mapRadius[0]}m` },
              { label: 'Filter', value: filters.find(f => f.id === activeFilter)?.label }
            ].map((stat, index) => (
              <motion.div 
                key={stat.label}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.6 + index * 0.1 }}
                className="text-center"
              >
                <div className={`font-bold text-lg ${
                  stat.label === 'Filter' ? colors.accent : colors.textPrimary
                }`}>
                  {stat.value}
                </div>
                <div className={`text-xs ${colors.textSecondary}`}>{stat.label}</div>
              </motion.div>
            ))}
          </div>

          {/* Enhanced Radius Slider */}
          <div className="mt-6">
            <div className="flex items-center justify-between mb-3">
              <span className={`text-sm font-medium ${colors.textPrimary}`}>Search Radius</span>
              <span className={`text-sm ${colors.accent}`}>{mapRadius[0]}m</span>
            </div>
            <Slider
              value={mapRadius}
              onValueChange={(value) => {
                setMapRadius(value);
                hapticFeedback('light');
              }}
              max={1000}
              min={100}
              step={50}
              className="w-full"
            />
            <div className="flex justify-between mt-2">
              <span className={`text-xs ${colors.textSecondary}`}>100m</span>
              <span className={`text-xs ${colors.textSecondary}`}>1km</span>
            </div>
          </div>
        </motion.div>
      </div>
    </div>
  );
};

export default AroundScreen;