import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Search, Filter, Route, Clock, TrendingUp, Sparkles, MapPin, Users, Star, Play } from 'lucide-react';
import { useTheme } from './ThemeContext';

interface TrailsScreenProps {
  onNavigate: (screen: string, isSubScreen?: boolean, data?: any) => void;
}

const TrailsScreen: React.FC<TrailsScreenProps> = ({ onNavigate }) => {
  const { colors, isDarkMode, hapticFeedback, playSound } = useTheme();
  const [searchQuery, setSearchQuery] = useState('');
  const [activeFilter, setActiveFilter] = useState('all');

  const filters = [
    { id: 'all', label: 'All', icon: Filter },
    { id: 'recent', label: 'Recent', icon: Clock },
    { id: 'popular', label: 'Popular', icon: TrendingUp },
    { id: 'featured', label: 'Featured', icon: Sparkles }
  ];

  const trails = [
    {
      id: 1,
      title: "Golden Gate Discovery",
      description: "Explore the iconic bridge and hidden spots around it",
      creator: "Sarah Chen",
      difficulty: "Easy",
      duration: "45-60 min",
      memoryCount: 8,
      participants: 234,
      rating: 4.8,
      category: "Sightseeing",
      isPopular: true,
      distance: "2.3km",
      image: "🌉"
    },
    {
      id: 2,
      title: "Street Art Adventure",
      description: "Discover incredible murals and graffiti across the Mission",
      creator: "Mike Johnson",
      difficulty: "Medium",
      duration: "60-90 min",
      memoryCount: 12,
      participants: 156,
      rating: 4.6,
      category: "Art & Culture",
      isPopular: true,
      distance: "3.1km",
      image: "🎨"
    },
    {
      id: 3,
      title: "Hidden Coffee Spots",
      description: "Find the best local coffee shops off the beaten path",
      creator: "Alex Rivera",
      difficulty: "Easy",
      duration: "30-45 min",
      memoryCount: 6,
      participants: 89,
      rating: 4.7,
      category: "Food & Drink",
      isPopular: false,
      distance: "1.8km",
      image: "☕"
    },
    {
      id: 4,
      title: "Sunset Photography Trail",
      description: "Capture the perfect golden hour shots across the city",
      creator: "Emma Watson",
      difficulty: "Hard",
      duration: "90-120 min",
      memoryCount: 15,
      participants: 67,
      rating: 4.9,
      category: "Photography",
      isPopular: false,
      distance: "4.2km",
      image: "📸"
    },
    {
      id: 5,
      title: "Historic Chinatown Walk",
      description: "Uncover the rich history and culture of Chinatown",
      creator: "David Kim",
      difficulty: "Easy",
      duration: "45-60 min",
      memoryCount: 10,
      participants: 198,
      rating: 4.5,
      category: "History",
      isPopular: true,
      distance: "2.7km",
      image: "🏮"
    }
  ];

  const getDifficultyColor = (difficulty: string) => {
    switch (difficulty) {
      case 'Easy': return 'text-green-400';
      case 'Medium': return 'text-yellow-400';
      case 'Hard': return 'text-red-400';
      default: return colors.textSecondary;
    }
  };

  const handleFilterChange = (filterId: string) => {
    setActiveFilter(filterId);
    hapticFeedback && hapticFeedback('light');
    playSound && playSound('tap');
  };

  const handleTrailClick = (trail: any) => {
    hapticFeedback && hapticFeedback('medium');
    playSound && playSound('tap');
    onNavigate('trail-detail', true, trail);
  };

  const filteredTrails = trails.filter(trail => {
    const matchesSearch = trail.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         trail.description.toLowerCase().includes(searchQuery.toLowerCase());
    
    switch (activeFilter) {
      case 'recent':
        return matchesSearch; // In real app, filter by creation date
      case 'popular':
        return matchesSearch && trail.isPopular;
      case 'featured':
        return matchesSearch && trail.rating >= 4.7;
      default:
        return matchesSearch;
    }
  });

  return (
    <div className={`h-full w-full flex flex-col bg-gradient-to-br ${colors.background}`}>
      {/* Enhanced Header with proper theming */}
      <div className="flex-shrink-0 pt-12 px-6 pb-4">
        <motion.div
          initial={{ opacity: 0, y: -30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, type: "spring", bounce: 0.3 }}
        >
          <div className="flex items-center justify-between mb-6">
            <div>
              <h1 className={`text-2xl font-bold ${colors.textPrimary}`}>Trails</h1>
              <p className={`text-sm ${colors.textSecondary}`}>Discover curated memory journeys</p>
            </div>
            
            <motion.button
              whileTap={{ scale: 0.9 }}
              whileHover={{ scale: 1.05 }}
              onClick={() => {
                hapticFeedback && hapticFeedback('medium');
                playSound && playSound('tap');
                onNavigate('create-trail');
              }}
              className={`w-10 h-10 rounded-full bg-gradient-to-r from-purple-600 to-purple-500 flex items-center justify-center`}
              style={{ 
                boxShadow: colors.shadowPurple
              }}
            >
              <Route size={18} className="text-white" />
            </motion.button>
          </div>

          {/* Enhanced Search Bar with proper theming */}
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
                placeholder="Search trails..."
                className={`flex-1 bg-transparent ${colors.textPrimary} placeholder-gray-500 focus:outline-none`}
              />
            </div>
          </motion.div>

          {/* Enhanced Filter Buttons with Purple Selection and proper theming */}
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
                  <span className={`font-medium text-sm ${isActive ? 'text-white' : 'inherit'}`}>
                    {filter.label}
                  </span>
                </motion.button>
              );
            })}
          </motion.div>
        </motion.div>
      </div>

      {/* Enhanced Trails List with Fixed Layout and proper theming */}
      <div className="flex-1 px-6 pb-6 overflow-y-auto">
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.3, duration: 0.5 }}
          className="space-y-6"
        >
          {filteredTrails.map((trail, index) => (
            <motion.button
              key={trail.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.1, duration: 0.5, type: "spring" }}
              whileTap={{ scale: 0.98 }}
              whileHover={{ scale: 1.02 }}
              onClick={() => handleTrailClick(trail)}
              className={`w-full glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.borderMedium} text-left transition-all duration-300`}
              style={{ 
                background: colors.glassBackground,
                boxShadow: colors.shadowLg
              }}
            >
              {/* Fixed layout structure to prevent overlapping */}
              <div className="flex flex-col space-y-4">
                {/* Top Row: Icon, Title/Description, Popular Badge */}
                <div className="flex items-start space-x-4">
                  {/* Trail Icon */}
                  <div 
                    className={`w-16 h-16 rounded-[20px] flex items-center justify-center bg-gradient-to-r from-purple-600 to-purple-500 flex-shrink-0`}
                    style={{ 
                      boxShadow: colors.shadowMd
                    }}
                  >
                    <span className="text-2xl">{trail.image}</span>
                  </div>

                  {/* Title and Description */}
                  <div className="flex-1 min-w-0">
                    <div className="flex items-start justify-between mb-3">
                      <div className="flex-1 pr-3">
                        <h3 className={`font-bold text-lg ${colors.textPrimary} mb-2 leading-tight`}>
                          {trail.title}
                        </h3>
                        <p className={`text-sm ${colors.textSecondary} leading-relaxed line-clamp-2`}>
                          {trail.description}
                        </p>
                      </div>
                      
                      {/* Popular Badge - Fixed positioning */}
                      {trail.isPopular && (
                        <div 
                          className={`px-3 py-1 rounded-full bg-gradient-to-r from-yellow-400 to-yellow-300 flex-shrink-0`}
                          style={{ 
                            boxShadow: colors.shadowSm
                          }}
                        >
                          <span className="text-xs font-medium text-black whitespace-nowrap">Popular</span>
                        </div>
                      )}
                    </div>
                  </div>

                  {/* Play Button */}
                  <motion.div
                    whileTap={{ scale: 0.9 }}
                    className={`w-12 h-12 rounded-full bg-gradient-to-r from-purple-600 to-purple-500 flex items-center justify-center flex-shrink-0`}
                    style={{ 
                      boxShadow: colors.shadowMd
                    }}
                  >
                    <Play size={16} className="text-white ml-0.5" />
                  </motion.div>
                </div>

                {/* Creator & Rating Row */}
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <div className="flex items-center space-x-2">
                      <div 
                        className="w-6 h-6 bg-gradient-to-r from-purple-500 to-blue-500 rounded-full flex items-center justify-center"
                        style={{ boxShadow: colors.shadowSm }}
                      >
                        <span className="text-xs text-white font-semibold">{trail.creator[0]}</span>
                      </div>
                      <span className={`text-sm ${colors.textSecondary} font-medium`}>{trail.creator}</span>
                    </div>
                  </div>
                  
                  <div className="flex items-center space-x-1">
                    <Star size={14} className="text-yellow-400" />
                    <span className={`text-sm ${colors.textPrimary} font-medium`}>{trail.rating}</span>
                  </div>
                </div>

                {/* Trail Metrics Grid - Fixed spacing with proper theming */}
                <div 
                  className={`grid grid-cols-4 gap-6 pt-4 border-t ${isDarkMode ? 'border-white/10' : 'border-purple-200/60'}`}
                >
                  <div className="text-center">
                    <div className={`text-lg font-bold ${colors.textPrimary} mb-1`}>{trail.memoryCount}</div>
                    <div className={`text-xs ${colors.textSecondary}`}>Memories</div>
                  </div>
                  <div className="text-center">
                    <div className={`text-lg font-bold ${getDifficultyColor(trail.difficulty)} mb-1`}>{trail.difficulty}</div>
                    <div className={`text-xs ${colors.textSecondary}`}>Difficulty</div>
                  </div>
                  <div className="text-center">
                    <div className={`text-lg font-bold ${colors.textPrimary} mb-1`}>{trail.duration}</div>
                    <div className={`text-xs ${colors.textSecondary}`}>Duration</div>
                  </div>
                  <div className="text-center">
                    <div className={`text-lg font-bold ${colors.accent} mb-1`}>{trail.participants}</div>
                    <div className={`text-xs ${colors.textSecondary}`}>Joined</div>
                  </div>
                </div>
              </div>
            </motion.button>
          ))}
        </motion.div>

        {/* Enhanced Empty State with proper theming */}
        {filteredTrails.length === 0 && (
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
              <Route size={24} className="text-white" />
            </div>
            <h3 className={`font-bold text-lg ${colors.textPrimary} mb-2`}>No trails found</h3>
            <p className={`${colors.textSecondary}`}>Try adjusting your search or filters</p>
          </motion.div>
        )}
      </div>
    </div>
  );
};

export default TrailsScreen;