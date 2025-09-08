import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { 
  ArrowLeft, 
  Play, 
  Pause, 
  MapPin, 
  Clock, 
  Users, 
  Star, 
  Bookmark, 
  Share, 
  Download,
  Route,
  Compass,
  Camera,
  Flag,
  AlertCircle,
  CheckCircle,
  Award,
  Heart,
  MessageCircle
} from 'lucide-react';
import { useTheme } from './ThemeContext';
import { ImageWithFallback } from './figma/ImageWithFallback';

interface TrailWaypoint {
  id: string;
  title: string;
  description: string;
  latitude: number;
  longitude: number;
  imageUrl?: string;
  memoryCount: number;
  isCompleted: boolean;
  estimatedTime: number; // minutes
}

interface Trail {
  id: string;
  title: string;
  description: string;
  creator: string;
  creatorAvatar: string;
  difficulty: 'Easy' | 'Medium' | 'Hard';
  duration: string;
  distance: number;
  rating: number;
  reviewCount: number;
  completionCount: number;
  imageUrl: string;
  category: string;
  waypoints: TrailWaypoint[];
  isBookmarked: boolean;
  isStarted: boolean;
  completionPercentage: number;
  tags: string[];
  safety: {
    level: 'Low' | 'Medium' | 'High';
    tips: string[];
  };
}

interface TrailDetailScreenProps {
  onNavigate: (screen: string, isSubScreen?: boolean, data?: any) => void;
  trail: Trail | null;
}

const TrailDetailScreen: React.FC<TrailDetailScreenProps> = ({ 
  onNavigate, 
  trail 
}) => {
  const { colors, isDarkMode, hapticFeedback, playSound } = useTheme();
  
  // State management
  const [isBookmarked, setIsBookmarked] = useState(false);
  const [isStarted, setIsStarted] = useState(false);
  const [isPaused, setIsPaused] = useState(false);
  const [completedWaypoints, setCompletedWaypoints] = useState<Set<string>>(new Set());
  const [currentWaypointIndex, setCurrentWaypointIndex] = useState(0);
  const [showFullDescription, setShowFullDescription] = useState(false);
  const [activeTab, setActiveTab] = useState<'overview' | 'waypoints' | 'reviews'>('overview');

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

  // Default trail data
  const defaultTrail: Trail = {
    id: '1',
    title: 'Urban Art Discovery Trail',
    description: 'Embark on a fascinating journey through the city\'s most vibrant street art scene. This carefully curated trail takes you through hidden alleyways, famous murals, and underground galleries that showcase the best of urban creativity. Perfect for art enthusiasts and photographers looking to capture the soul of the city.',
    creator: 'Alex Rivera',
    creatorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
    difficulty: 'Medium',
    duration: '3-4 hours',
    distance: 5.2,
    rating: 4.8,
    reviewCount: 124,
    completionCount: 892,
    imageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=600',
    category: 'Art & Culture',
    isBookmarked: false,
    isStarted: false,
    completionPercentage: 0,
    tags: ['street-art', 'photography', 'culture', 'walking', 'city'],
    safety: {
      level: 'Low',
      tips: [
        'Stay aware of your surroundings',
        'Respect private property',
        'Best visited during daylight hours'
      ]
    },
    waypoints: [
      {
        id: '1',
        title: 'The Alley Gallery',
        description: 'Start your journey at this iconic alley featuring rotating street art installations.',
        latitude: 40.7128,
        longitude: -74.0060,
        imageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=400',
        memoryCount: 45,
        isCompleted: false,
        estimatedTime: 30
      },
      {
        id: '2',
        title: 'Mural District',
        description: 'Explore the largest collection of murals in the city.',
        latitude: 40.7589,
        longitude: -73.9851,
        imageUrl: 'https://images.unsplash.com/photo-1499781350541-7783f6c6a0c8?w=400',
        memoryCount: 67,
        isCompleted: false,
        estimatedTime: 45
      },
      {
        id: '3',
        title: 'Underground Art Space',
        description: 'Discover hidden gems in this underground creative hub.',
        latitude: 40.7505,
        longitude: -73.9934,
        imageUrl: 'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?w=400',
        memoryCount: 32,
        isCompleted: false,
        estimatedTime: 60
      },
      {
        id: '4',
        title: 'Street Art Market',
        description: 'End your trail at this vibrant market showcasing local artists.',
        latitude: 40.7282,
        longitude: -73.9942,
        imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
        memoryCount: 28,
        isCompleted: false,
        estimatedTime: 40
      }
    ]
  };

  const displayTrail = trail || defaultTrail;

  // Initialize state from trail data
  useEffect(() => {
    if (displayTrail) {
      setIsBookmarked(displayTrail.isBookmarked);
      setIsStarted(displayTrail.isStarted);
    }
  }, [displayTrail]);

  // Responsive sizing
  const getResponsiveValues = () => {
    const base = {
      padding: screenSize === 'small' ? 16 : screenSize === 'medium' ? 20 : 24,
      titleSize: screenSize === 'small' ? 22 : screenSize === 'medium' ? 26 : 30,
      bodySize: screenSize === 'small' ? 14 : screenSize === 'medium' ? 15 : 16,
      metaSize: screenSize === 'small' ? 12 : screenSize === 'medium' ? 13 : 14,
      iconSize: screenSize === 'small' ? 18 : screenSize === 'medium' ? 20 : 22,
      avatarSize: screenSize === 'small' ? 44 : screenSize === 'medium' ? 48 : 52,
      headerHeight: screenSize === 'small' ? 280 : screenSize === 'medium' ? 320 : 360,
      buttonHeight: screenSize === 'small' ? 48 : screenSize === 'medium' ? 52 : 56,
    };
    return base;
  };

  const responsive = getResponsiveValues();

  // Event handlers
  const handleBack = () => {
    hapticFeedback?.('light');
    playSound?.('tap');
    onNavigate('trails');
  };

  const handleBookmark = () => {
    setIsBookmarked(!isBookmarked);
    hapticFeedback?.('medium');
    playSound?.('bookmark');
  };

  const handleShare = () => {
    hapticFeedback?.('light');
    playSound?.('tap');
  };

  const handleStartTrail = () => {
    setIsStarted(true);
    setIsPaused(false);
    hapticFeedback?.('success');
    playSound?.('success');
  };

  const handlePauseTrail = () => {
    setIsPaused(!isPaused);
    hapticFeedback?.('medium');
    playSound?.('tap');
  };

  const handleCompleteWaypoint = (waypointId: string) => {
    const newCompleted = new Set(completedWaypoints);
    if (newCompleted.has(waypointId)) {
      newCompleted.delete(waypointId);
    } else {
      newCompleted.add(waypointId);
    }
    setCompletedWaypoints(newCompleted);
    hapticFeedback?.('success');
    playSound?.('achievement');
  };

  const getDifficultyColor = (difficulty: string) => {
    switch (difficulty) {
      case 'Easy': return 'from-green-500 to-emerald-500';
      case 'Medium': return 'from-yellow-500 to-orange-500';
      case 'Hard': return 'from-red-500 to-pink-500';
      default: return 'from-gray-500 to-gray-600';
    }
  };

  const getSafetyColor = (level: string) => {
    switch (level) {
      case 'Low': return 'text-green-500';
      case 'Medium': return 'text-yellow-500';
      case 'High': return 'text-red-500';
      default: return 'text-gray-500';
    }
  };

  const completionPercentage = (completedWaypoints.size / displayTrail.waypoints.length) * 100;

  const TabButton: React.FC<{ 
    id: 'overview' | 'waypoints' | 'reviews'; 
    label: string; 
    icon: React.ReactNode 
  }> = ({ id, label, icon }) => (
    <motion.button
      whileTap={{ scale: 0.95 }}
      onClick={() => {
        setActiveTab(id);
        hapticFeedback?.('light');
      }}
      className={`flex-1 flex items-center justify-center space-x-2 py-3 px-4 rounded-xl font-semibold transition-all duration-200 ${
        activeTab === id 
          ? 'bg-gradient-to-r from-purple-600 to-purple-500 text-white' 
          : 'text-gray-500'
      }`}
      style={{ 
        fontSize: responsive.metaSize,
        boxShadow: activeTab === id ? colors.shadowPurple : 'none'
      }}
    >
      {icon}
      <span>{label}</span>
    </motion.button>
  );

  return (
    <div className={`h-screen w-full overflow-hidden bg-gradient-to-br ${colors.background} relative`}>
      {/* Hero Header with Image */}
      <div 
        className="relative overflow-hidden"
        style={{ height: responsive.headerHeight }}
      >
        <ImageWithFallback
          src={displayTrail.imageUrl}
          alt={displayTrail.title}
          className="w-full h-full object-cover"
        />
        
        {/* Gradient Overlay */}
        <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/40 to-black/20" />
        
        {/* Header Controls */}
        <div 
          className="absolute top-0 left-0 right-0 pt-12 pb-4 z-20"
          style={{ padding: `48px ${responsive.padding}px 16px` }}
        >
          <div className="flex items-center justify-between">
            <motion.button
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              whileTap={{ scale: 0.95 }}
              whileHover={{ scale: 1.05 }}
              onClick={handleBack}
              className="w-10 h-10 rounded-full flex items-center justify-center backdrop-blur-md border border-white/20 bg-black/20"
            >
              <ArrowLeft size={responsive.iconSize} className="text-white" />
            </motion.button>

            <div className="flex items-center space-x-3">
              <motion.button
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.1 }}
                whileTap={{ scale: 0.95 }}
                whileHover={{ scale: 1.05 }}
                onClick={handleBookmark}
                className={`w-10 h-10 rounded-full flex items-center justify-center backdrop-blur-md border transition-all duration-200 ${
                  isBookmarked 
                    ? 'border-yellow-500/50 bg-yellow-500/20' 
                    : 'border-white/20 bg-black/20'
                }`}
              >
                <Bookmark 
                  size={responsive.iconSize} 
                  className={`${isBookmarked ? 'text-yellow-400 fill-current' : 'text-white'}`} 
                />
              </motion.button>
              
              <motion.button
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.2 }}
                whileTap={{ scale: 0.95 }}
                whileHover={{ scale: 1.05 }}
                onClick={handleShare}
                className="w-10 h-10 rounded-full flex items-center justify-center backdrop-blur-md border border-white/20 bg-black/20"
              >
                <Share size={responsive.iconSize} className="text-white" />
              </motion.button>
            </div>
          </div>
        </div>

        {/* Trail Info Overlay */}
        <div 
          className="absolute bottom-0 left-0 right-0 p-6 z-10"
          style={{ padding: responsive.padding }}
        >
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.3 }}
          >
            {/* Difficulty Badge */}
            <div className="mb-4">
              <span 
                className={`inline-flex items-center px-3 py-1.5 rounded-full text-white font-semibold bg-gradient-to-r ${getDifficultyColor(displayTrail.difficulty)}`}
                style={{ fontSize: responsive.metaSize }}
              >
                <AlertCircle size={14} className="mr-1" />
                {displayTrail.difficulty}
              </span>
            </div>

            <h1 
              className="font-bold text-white mb-3 leading-tight"
              style={{ fontSize: responsive.titleSize }}
            >
              {displayTrail.title}
            </h1>

            <div className="flex items-center space-x-4 mb-4">
              <div className="flex items-center space-x-1 text-white">
                <Clock size={16} />
                <span style={{ fontSize: responsive.metaSize }}>{displayTrail.duration}</span>
              </div>
              
              <div className="flex items-center space-x-1 text-white">
                <Route size={16} />
                <span style={{ fontSize: responsive.metaSize }}>{displayTrail.distance}km</span>
              </div>
              
              <div className="flex items-center space-x-1 text-white">
                <Star size={16} className="fill-current text-yellow-400" />
                <span style={{ fontSize: responsive.metaSize }}>
                  {displayTrail.rating} ({displayTrail.reviewCount})
                </span>
              </div>
            </div>

            {/* Creator Info */}
            <div className="flex items-center space-x-3">
              <img
                src={displayTrail.creatorAvatar}
                alt={displayTrail.creator}
                className="rounded-full object-cover"
                style={{ 
                  width: responsive.avatarSize - 8, 
                  height: responsive.avatarSize - 8 
                }}
              />
              <div>
                <p className="text-white font-semibold" style={{ fontSize: responsive.bodySize }}>
                  Created by {displayTrail.creator}
                </p>
                <p className="text-white/70" style={{ fontSize: responsive.metaSize }}>
                  {displayTrail.completionCount} completions
                </p>
              </div>
            </div>
          </motion.div>
        </div>
      </div>

      {/* Content Area */}
      <div className="flex-1 overflow-y-auto scrollbar-hide">
        <div style={{ padding: responsive.padding }}>
          
          {/* Action Buttons */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4 }}
            className="flex space-x-3 mb-6 -mt-6 relative z-20"
          >
            {!isStarted ? (
              <motion.button
                whileTap={{ scale: 0.95 }}
                whileHover={{ scale: 1.02 }}
                onClick={handleStartTrail}
                className="flex-1 bg-gradient-to-r from-purple-600 to-purple-500 text-white font-bold rounded-2xl flex items-center justify-center space-x-2"
                style={{ 
                  height: responsive.buttonHeight,
                  fontSize: responsive.bodySize,
                  boxShadow: colors.shadowPurple
                }}
              >
                <Play size={responsive.iconSize} className="fill-current" />
                <span>Start Trail</span>
              </motion.button>
            ) : (
              <motion.button
                whileTap={{ scale: 0.95 }}
                whileHover={{ scale: 1.02 }}
                onClick={handlePauseTrail}
                className="flex-1 bg-gradient-to-r from-orange-500 to-red-500 text-white font-bold rounded-2xl flex items-center justify-center space-x-2"
                style={{ 
                  height: responsive.buttonHeight,
                  fontSize: responsive.bodySize,
                  boxShadow: colors.shadowLg
                }}
              >
                {isPaused ? (
                  <>
                    <Play size={responsive.iconSize} className="fill-current" />
                    <span>Resume</span>
                  </>
                ) : (
                  <>
                    <Pause size={responsive.iconSize} className="fill-current" />
                    <span>Pause</span>
                  </>
                )}
              </motion.button>
            )}
            
            <motion.button
              whileTap={{ scale: 0.95 }}
              whileHover={{ scale: 1.02 }}
              className="px-6 border rounded-2xl flex items-center justify-center"
              style={{ 
                height: responsive.buttonHeight,
                background: colors.glassBackground,
                borderColor: colors.borderMedium,
                boxShadow: colors.shadowSm
              }}
            >
              <Download size={responsive.iconSize} style={{ color: colors.textPrimary }} />
            </motion.button>
          </motion.div>

          {/* Progress Bar (when started) */}
          {isStarted && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              className="rounded-2xl p-4 mb-6 border"
              style={{ 
                background: colors.glassBackground,
                borderColor: colors.borderMedium,
                boxShadow: colors.shadowMd
              }}
            >
              <div className="flex items-center justify-between mb-3">
                <span 
                  style={{ 
                    color: colors.textPrimary, 
                    fontSize: responsive.bodySize 
                  }}
                  className="font-semibold"
                >
                  Trail Progress
                </span>
                
                <span 
                  style={{ 
                    color: colors.accent, 
                    fontSize: responsive.bodySize 
                  }}
                  className="font-bold"
                >
                  {Math.round(completionPercentage)}%
                </span>
              </div>
              
              <div 
                className="h-3 rounded-full overflow-hidden"
                style={{ background: colors.borderMedium }}
              >
                <motion.div
                  initial={{ width: 0 }}
                  animate={{ width: `${completionPercentage}%` }}
                  transition={{ duration: 0.8, ease: "easeOut" }}
                  className="h-full bg-gradient-to-r from-purple-600 to-purple-500 rounded-full"
                />
              </div>
              
              <p 
                style={{ 
                  color: colors.textSecondary, 
                  fontSize: responsive.metaSize 
                }}
                className="mt-2"
              >
                {completedWaypoints.size} of {displayTrail.waypoints.length} waypoints completed
              </p>
            </motion.div>
          )}

          {/* Tab Navigation */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.5 }}
            className="rounded-2xl p-2 mb-6 border"
            style={{ 
              background: colors.glassBackground,
              borderColor: colors.borderMedium,
              boxShadow: colors.shadowSm
            }}
          >
            <div className="flex space-x-2">
              <TabButton 
                id="overview" 
                label="Overview" 
                icon={<Flag size={16} />} 
              />
              <TabButton 
                id="waypoints" 
                label="Waypoints" 
                icon={<MapPin size={16} />} 
              />
              <TabButton 
                id="reviews" 
                label="Reviews" 
                icon={<Star size={16} />} 
              />
            </div>
          </motion.div>

          {/* Tab Content */}
          <AnimatePresence mode="wait">
            <motion.div
              key={activeTab}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -20 }}
              transition={{ duration: 0.3 }}
            >
              {activeTab === 'overview' && (
                <div className="space-y-6">
                  {/* Description */}
                  <div 
                    className="rounded-2xl p-5 border"
                    style={{ 
                      background: colors.glassBackground,
                      borderColor: colors.borderMedium,
                      boxShadow: colors.shadowMd
                    }}
                  >
                    <h3 
                      style={{ 
                        color: colors.textPrimary, 
                        fontSize: responsive.bodySize + 2 
                      }}
                      className="font-bold mb-3"
                    >
                      About This Trail
                    </h3>
                    
                    <p 
                      style={{ 
                        color: colors.textSecondary, 
                        fontSize: responsive.bodySize 
                      }}
                      className={`leading-relaxed ${!showFullDescription && displayTrail.description.length > 200 ? 'line-clamp-4' : ''}`}
                    >
                      {displayTrail.description}
                    </p>
                    
                    {displayTrail.description.length > 200 && (
                      <motion.button
                        whileTap={{ scale: 0.95 }}
                        onClick={() => setShowFullDescription(!showFullDescription)}
                        className="mt-3 font-semibold"
                        style={{ 
                          color: colors.accent,
                          fontSize: responsive.metaSize
                        }}
                      >
                        {showFullDescription ? 'Show less' : 'Read more'}
                      </motion.button>
                    )}

                    {/* Tags */}
                    <div className="flex flex-wrap gap-2 mt-4">
                      {displayTrail.tags.map((tag, index) => (
                        <span
                          key={index}
                          className="px-3 py-1 rounded-full border"
                          style={{ 
                            background: `${colors.accent}20`,
                            borderColor: `${colors.accent}40`,
                            color: colors.accent,
                            fontSize: responsive.metaSize
                          }}
                        >
                          #{tag}
                        </span>
                      ))}
                    </div>
                  </div>

                  {/* Safety Information */}
                  <div 
                    className="rounded-2xl p-5 border"
                    style={{ 
                      background: colors.glassBackground,
                      borderColor: colors.borderMedium,
                      boxShadow: colors.shadowMd
                    }}
                  >
                    <div className="flex items-center space-x-2 mb-3">
                      <AlertCircle size={20} style={{ color: colors.textPrimary }} />
                      <h3 
                        style={{ 
                          color: colors.textPrimary, 
                          fontSize: responsive.bodySize + 2 
                        }}
                        className="font-bold"
                      >
                        Safety Information
                      </h3>
                    </div>
                    
                    <div className="flex items-center space-x-2 mb-3">
                      <span 
                        style={{ 
                          color: colors.textSecondary, 
                          fontSize: responsive.bodySize 
                        }}
                      >
                        Risk Level:
                      </span>
                      <span 
                        className={`font-semibold ${getSafetyColor(displayTrail.safety.level)}`}
                        style={{ fontSize: responsive.bodySize }}
                      >
                        {displayTrail.safety.level}
                      </span>
                    </div>

                    <div className="space-y-2">
                      {displayTrail.safety.tips.map((tip, index) => (
                        <div key={index} className="flex items-start space-x-2">
                          <CheckCircle size={16} className="text-green-500 mt-0.5 flex-shrink-0" />
                          <span 
                            style={{ 
                              color: colors.textSecondary, 
                              fontSize: responsive.bodySize 
                            }}
                          >
                            {tip}
                          </span>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              )}

              {activeTab === 'waypoints' && (
                <div className="space-y-4">
                  {displayTrail.waypoints.map((waypoint, index) => (
                    <motion.div
                      key={waypoint.id}
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: index * 0.1 }}
                      className={`rounded-2xl p-4 border transition-all duration-300 ${
                        completedWaypoints.has(waypoint.id) 
                          ? 'border-green-500/50 bg-green-500/10' 
                          : ''
                      }`}
                      style={{ 
                        background: completedWaypoints.has(waypoint.id) 
                          ? undefined 
                          : colors.glassBackground,
                        borderColor: completedWaypoints.has(waypoint.id) 
                          ? 'rgba(34, 197, 94, 0.5)' 
                          : colors.borderMedium,
                        boxShadow: colors.shadowMd
                      }}
                    >
                      <div className="flex space-x-4">
                        <div className="relative">
                          <ImageWithFallback
                            src={waypoint.imageUrl || ''}
                            alt={waypoint.title}
                            className="w-20 h-20 rounded-xl object-cover"
                          />
                          
                          {completedWaypoints.has(waypoint.id) && (
                            <div className="absolute -top-2 -right-2 w-6 h-6 bg-green-500 rounded-full flex items-center justify-center">
                              <CheckCircle size={16} className="text-white" />
                            </div>
                          )}
                        </div>
                        
                        <div className="flex-1">
                          <div className="flex items-start justify-between mb-2">
                            <h4 
                              style={{ 
                                color: colors.textPrimary, 
                                fontSize: responsive.bodySize 
                              }}
                              className="font-semibold"
                            >
                              {index + 1}. {waypoint.title}
                            </h4>
                            
                            <motion.button
                              whileTap={{ scale: 0.95 }}
                              onClick={() => handleCompleteWaypoint(waypoint.id)}
                              className={`px-3 py-1 rounded-lg font-medium transition-all duration-200 ${
                                completedWaypoints.has(waypoint.id)
                                  ? 'bg-green-500 text-white'
                                  : 'border'
                              }`}
                              style={{ 
                                background: completedWaypoints.has(waypoint.id) 
                                  ? undefined 
                                  : colors.glassBackground,
                                borderColor: completedWaypoints.has(waypoint.id) 
                                  ? undefined 
                                  : colors.borderMedium,
                                color: completedWaypoints.has(waypoint.id) 
                                  ? undefined 
                                  : colors.textSecondary,
                                fontSize: responsive.metaSize
                              }}
                            >
                              {completedWaypoints.has(waypoint.id) ? 'Completed' : 'Mark Complete'}
                            </motion.button>
                          </div>
                          
                          <p 
                            style={{ 
                              color: colors.textSecondary, 
                              fontSize: responsive.metaSize 
                            }}
                            className="mb-3"
                          >
                            {waypoint.description}
                          </p>
                          
                          <div className="flex items-center space-x-4 text-sm">
                            <div className="flex items-center space-x-1">
                              <Clock size={14} style={{ color: colors.textSecondary }} />
                              <span style={{ color: colors.textSecondary }}>
                                {waypoint.estimatedTime} min
                              </span>
                            </div>
                            
                            <div className="flex items-center space-x-1">
                              <Camera size={14} style={{ color: colors.textSecondary }} />
                              <span style={{ color: colors.textSecondary }}>
                                {waypoint.memoryCount} memories
                              </span>
                            </div>
                          </div>
                        </div>
                      </div>
                    </motion.div>
                  ))}
                </div>
              )}

              {activeTab === 'reviews' && (
                <div className="space-y-4">
                  {/* Reviews Summary */}
                  <div 
                    className="rounded-2xl p-5 border"
                    style={{ 
                      background: colors.glassBackground,
                      borderColor: colors.borderMedium,
                      boxShadow: colors.shadowMd
                    }}
                  >
                    <div className="flex items-center space-x-4 mb-4">
                      <div className="text-center">
                        <div 
                          style={{ 
                            color: colors.textPrimary, 
                            fontSize: responsive.titleSize 
                          }}
                          className="font-bold"
                        >
                          {displayTrail.rating}
                        </div>
                        <div className="flex items-center justify-center space-x-1 my-1">
                          {[1, 2, 3, 4, 5].map((star) => (
                            <Star 
                              key={star} 
                              size={16} 
                              className={`${
                                star <= Math.floor(displayTrail.rating) 
                                  ? 'text-yellow-400 fill-current' 
                                  : 'text-gray-300'
                              }`} 
                            />
                          ))}
                        </div>
                        <span 
                          style={{ 
                            color: colors.textSecondary, 
                            fontSize: responsive.metaSize 
                          }}
                        >
                          {displayTrail.reviewCount} reviews
                        </span>
                      </div>
                      
                      <div className="flex-1 space-y-2">
                        {[5, 4, 3, 2, 1].map((rating) => (
                          <div key={rating} className="flex items-center space-x-3">
                            <span 
                              style={{ 
                                color: colors.textSecondary, 
                                fontSize: responsive.metaSize 
                              }}
                              className="w-8"
                            >
                              {rating}★
                            </span>
                            <div 
                              className="flex-1 h-2 rounded-full overflow-hidden"
                              style={{ background: colors.borderMedium }}
                            >
                              <div 
                                className="h-full bg-yellow-400"
                                style={{ 
                                  width: `${rating === 5 ? 70 : rating === 4 ? 20 : rating === 3 ? 7 : rating === 2 ? 2 : 1}%` 
                                }}
                              />
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>

                  {/* Individual Reviews */}
                  {[
                    {
                      id: '1',
                      author: 'Emma Watson',
                      avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
                      rating: 5,
                      date: '2 days ago',
                      review: 'Absolutely loved this trail! The street art was incredible and the route was well-planned. Perfect for a weekend adventure.',
                      helpful: 24
                    },
                    {
                      id: '2',
                      author: 'Mike Johnson',
                      avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
                      rating: 4,
                      date: '1 week ago',
                      review: 'Great trail with amazing art pieces. Some areas were a bit crowded, but overall a fantastic experience.',
                      helpful: 18
                    }
                  ].map((review, index) => (
                    <motion.div
                      key={review.id}
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: index * 0.1 }}
                      className="rounded-2xl p-4 border"
                      style={{ 
                        background: colors.glassBackground,
                        borderColor: colors.borderMedium,
                        boxShadow: colors.shadowSm
                      }}
                    >
                      <div className="flex items-start space-x-3">
                        <img
                          src={review.avatar}
                          alt={review.author}
                          className="rounded-full object-cover"
                          style={{ 
                            width: responsive.avatarSize - 8, 
                            height: responsive.avatarSize - 8 
                          }}
                        />
                        
                        <div className="flex-1">
                          <div className="flex items-center justify-between mb-2">
                            <div>
                              <h4 
                                style={{ 
                                  color: colors.textPrimary, 
                                  fontSize: responsive.bodySize 
                                }}
                                className="font-semibold"
                              >
                                {review.author}
                              </h4>
                              
                              <div className="flex items-center space-x-2 mt-1">
                                <div className="flex space-x-1">
                                  {[1, 2, 3, 4, 5].map((star) => (
                                    <Star 
                                      key={star} 
                                      size={12} 
                                      className={`${
                                        star <= review.rating 
                                          ? 'text-yellow-400 fill-current' 
                                          : 'text-gray-300'
                                      }`} 
                                    />
                                  ))}
                                </div>
                                
                                <span 
                                  style={{ 
                                    color: colors.textSecondary, 
                                    fontSize: responsive.metaSize 
                                  }}
                                >
                                  {review.date}
                                </span>
                              </div>
                            </div>
                          </div>
                          
                          <p 
                            style={{ 
                              color: colors.textSecondary, 
                              fontSize: responsive.bodySize 
                            }}
                            className="mb-3 leading-relaxed"
                          >
                            {review.review}
                          </p>
                          
                          <div className="flex items-center space-x-4">
                            <button className="flex items-center space-x-1 transition-colors duration-200">
                              <Heart size={14} style={{ color: colors.textSecondary }} />
                              <span 
                                style={{ 
                                  color: colors.textSecondary, 
                                  fontSize: responsive.metaSize 
                                }}
                              >
                                {review.helpful}
                              </span>
                            </button>
                            
                            <button 
                              style={{ 
                                color: colors.textSecondary, 
                                fontSize: responsive.metaSize 
                              }}
                              className="font-medium"
                            >
                              Reply
                            </button>
                          </div>
                        </div>
                      </div>
                    </motion.div>
                  ))}
                </div>
              )}
            </motion.div>
          </AnimatePresence>

          {/* Bottom spacing */}
          <div className="h-20" />
        </div>
      </div>
    </div>
  );
};

export default TrailDetailScreen;