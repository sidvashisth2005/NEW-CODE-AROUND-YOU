import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { 
  ArrowLeft, 
  Heart, 
  MessageCircle, 
  Share, 
  MoreVertical, 
  Bookmark, 
  MapPin, 
  Calendar,
  Eye,
  Star,
  Download,
  Flag,
  UserPlus
} from 'lucide-react';
import { useTheme } from './ThemeContext';
import { ImageWithFallback } from './figma/ImageWithFallback';

interface Memory {
  id: string;
  title: string;
  description: string;
  author: string;
  authorAvatar: string;
  location: string;
  timestamp: string;
  category: string;
  imageUrl?: string;
  likes: number;
  comments: number;
  views: number;
  isVerified?: boolean;
  tags?: string[];
}

interface Comment {
  id: string;
  author: string;
  authorAvatar: string;
  content: string;
  timestamp: string;
  likes: number;
  isLiked: boolean;
}

interface MemoryDetailScreenProps {
  onNavigate: (screen: string, isSubScreen?: boolean, data?: any) => void;
  memory: Memory | null;
  updateStreak?: (userId: string) => void;
}

const MemoryDetailScreen: React.FC<MemoryDetailScreenProps> = ({ 
  onNavigate, 
  memory, 
  updateStreak 
}) => {
  const { colors, isDarkMode, hapticFeedback, playSound } = useTheme();
  
  // State management
  const [isLiked, setIsLiked] = useState(false);
  const [isBookmarked, setIsBookmarked] = useState(false);
  const [isFollowing, setIsFollowing] = useState(false);
  const [likesCount, setLikesCount] = useState(0);
  const [commentsData, setCommentsData] = useState<Comment[]>([]);
  const [newComment, setNewComment] = useState('');
  const [showFullDescription, setShowFullDescription] = useState(false);
  const [currentImageIndex, setCurrentImageIndex] = useState(0);

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

  // Default memory data
  const defaultMemory: Memory = {
    id: '1',
    title: 'Morning Coffee Ritual',
    description: 'There\'s something magical about that first sip of coffee in the morning. The aroma fills the air, steam dances upward, and for a moment, everything feels perfect. This little café has become my sanctuary, a place where time slows down and inspiration flows. The barista knows my order by heart, and the locals have become familiar faces in my daily routine.',
    author: 'Sarah Chen',
    authorAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b691?w=100',
    location: 'Central Perk Café, Downtown',
    timestamp: '2 hours ago',
    category: 'lifestyle',
    imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=600',
    likes: 247,
    comments: 18,
    views: 1250,
    isVerified: true,
    tags: ['coffee', 'morning', 'café', 'peaceful', 'routine']
  };

  const displayMemory = memory || defaultMemory;

  // Initialize state from memory data
  useEffect(() => {
    if (displayMemory) {
      setLikesCount(displayMemory.likes);
      setCommentsData([
        {
          id: '1',
          author: 'Alex Rivera',
          authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
          content: 'This looks amazing! I love that café too ☕',
          timestamp: '1 hour ago',
          likes: 5,
          isLiked: false
        },
        {
          id: '2',
          author: 'Emma Wilson',
          authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
          content: 'Your photography keeps getting better! The composition here is perfect 📸',
          timestamp: '45 minutes ago',
          likes: 3,
          isLiked: true
        },
        {
          id: '3',
          author: 'Mike Johnson',
          authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
          content: 'Need to try this place! Where exactly is it located?',
          timestamp: '30 minutes ago',
          likes: 1,
          isLiked: false
        }
      ]);
    }
  }, [displayMemory]);

  // Responsive sizing
  const getResponsiveValues = () => {
    const base = {
      padding: screenSize === 'small' ? 16 : screenSize === 'medium' ? 20 : 24,
      titleSize: screenSize === 'small' ? 20 : screenSize === 'medium' ? 24 : 28,
      bodySize: screenSize === 'small' ? 14 : screenSize === 'medium' ? 15 : 16,
      metaSize: screenSize === 'small' ? 12 : screenSize === 'medium' ? 13 : 14,
      iconSize: screenSize === 'small' ? 18 : screenSize === 'medium' ? 20 : 22,
      avatarSize: screenSize === 'small' ? 40 : screenSize === 'medium' ? 44 : 48,
      imageHeight: screenSize === 'small' ? 250 : screenSize === 'medium' ? 300 : 350,
    };
    return base;
  };

  const responsive = getResponsiveValues();

  // Event handlers
  const handleLike = () => {
    const newLikedState = !isLiked;
    setIsLiked(newLikedState);
    setLikesCount(prev => newLikedState ? prev + 1 : prev - 1);
    hapticFeedback?.('light');
    playSound?.('tap');
    
    if (updateStreak && newLikedState) {
      updateStreak(displayMemory.author.toLowerCase().replace(/\s+/g, '-'));
    }
  };

  const handleBookmark = () => {
    setIsBookmarked(!isBookmarked);
    hapticFeedback?.('medium');
    playSound?.('bookmark');
  };

  const handleFollow = () => {
    setIsFollowing(!isFollowing);
    hapticFeedback?.('medium');
    playSound?.('success');
  };

  const handleShare = () => {
    hapticFeedback?.('light');
    playSound?.('tap');
    // Share functionality
  };

  const handleAddComment = () => {
    if (newComment.trim()) {
      const comment: Comment = {
        id: Date.now().toString(),
        author: 'You',
        authorAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
        content: newComment.trim(),
        timestamp: 'now',
        likes: 0,
        isLiked: false
      };
      setCommentsData([...commentsData, comment]);
      setNewComment('');
      hapticFeedback?.('success');
      playSound?.('success');
    }
  };

  const handleCommentLike = (commentId: string) => {
    setCommentsData(prev => prev.map(comment => 
      comment.id === commentId 
        ? { 
            ...comment, 
            isLiked: !comment.isLiked, 
            likes: comment.isLiked ? comment.likes - 1 : comment.likes + 1 
          }
        : comment
    ));
    hapticFeedback?.('light');
  };

  const handleBack = () => {
    hapticFeedback?.('light');
    playSound?.('tap');
    onNavigate('home');
  };

  const getCategoryIcon = (category: string) => {
    const iconMap: { [key: string]: string } = {
      'food': '🍽️',
      'art': '🎨',
      'nature': '🌿',
      'lifestyle': '✨',
      'travel': '✈️',
      'fitness': '💪',
      'photography': '📸'
    };
    return iconMap[category] || '📝';
  };

  const getCategoryColor = (category: string) => {
    const colorMap: { [key: string]: string } = {
      'food': 'from-orange-500 to-red-500',
      'art': 'from-purple-500 to-pink-500',
      'nature': 'from-green-500 to-teal-500',
      'lifestyle': 'from-blue-500 to-indigo-500',
      'travel': 'from-cyan-500 to-blue-500',
      'fitness': 'from-red-500 to-pink-500',
      'photography': 'from-gray-600 to-gray-800'
    };
    return colorMap[category] || 'from-gray-500 to-gray-600';
  };

  return (
    <div className={`h-screen w-full overflow-hidden bg-gradient-to-br ${colors.background} relative`}>
      {/* Header - Fixed with blur overlay */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className="fixed top-0 left-0 right-0 z-50 pt-12 pb-4"
        style={{ padding: `48px ${responsive.padding}px 16px` }}
      >
        <div 
          className="absolute inset-0 backdrop-blur-xl border-b"
          style={{ 
            background: `${colors.glassBackground}99`,
            borderColor: colors.borderLight
          }}
        />
        
        <div className="relative flex items-center justify-between">
          <motion.button
            whileTap={{ scale: 0.95 }}
            whileHover={{ scale: 1.05 }}
            onClick={handleBack}
            className="w-10 h-10 rounded-full flex items-center justify-center border transition-all duration-200"
            style={{ 
              background: colors.glassBackground,
              borderColor: colors.borderMedium,
              boxShadow: colors.shadowSm
            }}
          >
            <ArrowLeft size={responsive.iconSize} style={{ color: colors.textPrimary }} />
          </motion.button>

          <div className="flex items-center space-x-3">
            <motion.button
              whileTap={{ scale: 0.95 }}
              whileHover={{ scale: 1.05 }}
              onClick={handleBookmark}
              className={`w-10 h-10 rounded-full flex items-center justify-center border transition-all duration-200 ${
                isBookmarked ? 'border-yellow-500/50' : ''
              }`}
              style={{ 
                background: isBookmarked 
                  ? 'linear-gradient(135deg, rgba(255, 215, 0, 0.2), rgba(255, 193, 7, 0.2))'
                  : colors.glassBackground,
                borderColor: isBookmarked ? 'rgba(255, 215, 0, 0.5)' : colors.borderMedium,
                boxShadow: isBookmarked ? colors.shadowGold : colors.shadowSm
              }}
            >
              <Bookmark 
                size={responsive.iconSize} 
                style={{ color: isBookmarked ? '#FFD700' : colors.textPrimary }}
                className={isBookmarked ? 'fill-current' : ''}
              />
            </motion.button>
            
            <motion.button
              whileTap={{ scale: 0.95 }}
              whileHover={{ scale: 1.05 }}
              onClick={handleShare}
              className="w-10 h-10 rounded-full flex items-center justify-center border transition-all duration-200"
              style={{ 
                background: colors.glassBackground,
                borderColor: colors.borderMedium,
                boxShadow: colors.shadowSm
              }}
            >
              <Share size={responsive.iconSize} style={{ color: colors.textPrimary }} />
            </motion.button>
          </div>
        </div>
      </motion.div>

      {/* Main Content - Scrollable */}
      <div className="pt-24 h-full overflow-y-auto scrollbar-hide">
        <div style={{ padding: `0 ${responsive.padding}px ${responsive.padding}px` }}>
          
          {/* Memory Image */}
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ delay: 0.1, duration: 0.5 }}
            className="rounded-3xl overflow-hidden mb-6 relative"
            style={{ 
              height: responsive.imageHeight,
              boxShadow: colors.shadowLg
            }}
          >
            <ImageWithFallback
              src={displayMemory.imageUrl || ''}
              alt={displayMemory.title}
              className="w-full h-full object-cover"
            />
            
            {/* Category Badge */}
            <div className="absolute top-4 left-4">
              <div 
                className={`px-3 py-1.5 rounded-full text-white text-sm font-semibold backdrop-blur-md bg-gradient-to-r ${getCategoryColor(displayMemory.category)}`}
                style={{ fontSize: responsive.metaSize }}
              >
                <span className="mr-1">{getCategoryIcon(displayMemory.category)}</span>
                {displayMemory.category.charAt(0).toUpperCase() + displayMemory.category.slice(1)}
              </div>
            </div>

            {/* Stats overlay */}
            <div className="absolute bottom-4 right-4 flex space-x-2">
              <div 
                className="px-2 py-1 rounded-lg backdrop-blur-md border flex items-center space-x-1"
                style={{ 
                  background: colors.glassBackground,
                  borderColor: colors.borderLight
                }}
              >
                <Eye size={12} style={{ color: colors.textSecondary }} />
                <span style={{ color: colors.textSecondary, fontSize: responsive.metaSize }}>
                  {displayMemory.views}
                </span>
              </div>
            </div>
          </motion.div>

          {/* Author Section */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2, duration: 0.5 }}
            className="rounded-2xl p-4 mb-6 border"
            style={{ 
              background: colors.glassBackground,
              borderColor: colors.borderMedium,
              boxShadow: colors.shadowMd
            }}
          >
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <div className="relative">
                  <img
                    src={displayMemory.authorAvatar}
                    alt={displayMemory.author}
                    className="rounded-full object-cover"
                    style={{ 
                      width: responsive.avatarSize, 
                      height: responsive.avatarSize 
                    }}
                  />
                  {displayMemory.isVerified && (
                    <div className="absolute -bottom-1 -right-1 w-5 h-5 bg-blue-500 rounded-full flex items-center justify-center">
                      <Star size={12} className="text-white fill-current" />
                    </div>
                  )}
                </div>
                
                <div>
                  <div className="flex items-center space-x-2">
                    <h3 
                      style={{ 
                        color: colors.textPrimary, 
                        fontSize: responsive.bodySize 
                      }}
                      className="font-semibold"
                    >
                      {displayMemory.author}
                    </h3>
                  </div>
                  
                  <div className="flex items-center space-x-4 mt-1">
                    <div className="flex items-center space-x-1">
                      <MapPin size={12} style={{ color: colors.textSecondary }} />
                      <span 
                        style={{ 
                          color: colors.textSecondary, 
                          fontSize: responsive.metaSize 
                        }}
                      >
                        {displayMemory.location}
                      </span>
                    </div>
                    
                    <div className="flex items-center space-x-1">
                      <Calendar size={12} style={{ color: colors.textSecondary }} />
                      <span 
                        style={{ 
                          color: colors.textSecondary, 
                          fontSize: responsive.metaSize 
                        }}
                      >
                        {displayMemory.timestamp}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
              
              <motion.button
                whileTap={{ scale: 0.95 }}
                whileHover={{ scale: 1.05 }}
                onClick={handleFollow}
                className={`px-4 py-2 rounded-xl font-semibold transition-all duration-200 flex items-center space-x-2 ${
                  isFollowing ? 'bg-gray-600' : 'bg-gradient-to-r from-purple-600 to-purple-500'
                }`}
                style={{ 
                  fontSize: responsive.metaSize,
                  boxShadow: isFollowing ? colors.shadowSm : colors.shadowPurple
                }}
              >
                <UserPlus size={14} className="text-white" />
                <span className="text-white">
                  {isFollowing ? 'Following' : 'Follow'}
                </span>
              </motion.button>
            </div>
          </motion.div>

          {/* Memory Content */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.3, duration: 0.5 }}
            className="rounded-2xl p-5 mb-6 border"
            style={{ 
              background: colors.glassBackground,
              borderColor: colors.borderMedium,
              boxShadow: colors.shadowMd
            }}
          >
            <h1 
              style={{ 
                color: colors.textPrimary, 
                fontSize: responsive.titleSize 
              }}
              className="font-bold mb-4 leading-tight"
            >
              {displayMemory.title}
            </h1>
            
            <div className="relative">
              <p 
                style={{ 
                  color: colors.textSecondary, 
                  fontSize: responsive.bodySize 
                }}
                className={`leading-relaxed ${!showFullDescription && displayMemory.description.length > 150 ? 'line-clamp-3' : ''}`}
              >
                {displayMemory.description}
              </p>
              
              {displayMemory.description.length > 150 && (
                <motion.button
                  whileTap={{ scale: 0.95 }}
                  onClick={() => setShowFullDescription(!showFullDescription)}
                  className="mt-2 font-semibold"
                  style={{ 
                    color: colors.accent,
                    fontSize: responsive.metaSize
                  }}
                >
                  {showFullDescription ? 'Show less' : 'Show more'}
                </motion.button>
              )}
            </div>

            {/* Tags */}
            {displayMemory.tags && displayMemory.tags.length > 0 && (
              <div className="flex flex-wrap gap-2 mt-4">
                {displayMemory.tags.map((tag, index) => (
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
            )}
          </motion.div>

          {/* Interaction Bar */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4, duration: 0.5 }}
            className="rounded-2xl p-4 mb-6 border"
            style={{ 
              background: colors.glassBackground,
              borderColor: colors.borderMedium,
              boxShadow: colors.shadowMd
            }}
          >
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-6">
                <motion.button
                  whileTap={{ scale: 0.9 }}
                  whileHover={{ scale: 1.05 }}
                  onClick={handleLike}
                  className={`flex items-center space-x-2 transition-all duration-200 ${
                    isLiked ? 'text-red-500' : ''
                  }`}
                  style={{ color: isLiked ? '#EF4444' : colors.textSecondary }}
                >
                  <Heart 
                    size={responsive.iconSize} 
                    className={isLiked ? 'fill-current' : ''} 
                  />
                  <span 
                    className="font-semibold"
                    style={{ fontSize: responsive.bodySize }}
                  >
                    {likesCount}
                  </span>
                </motion.button>
                
                <button 
                  className="flex items-center space-x-2 transition-colors duration-200"
                  style={{ color: colors.textSecondary }}
                >
                  <MessageCircle size={responsive.iconSize} />
                  <span 
                    className="font-semibold"
                    style={{ fontSize: responsive.bodySize }}
                  >
                    {commentsData.length}
                  </span>
                </button>
                
                <button 
                  onClick={handleShare}
                  className="flex items-center space-x-2 transition-colors duration-200"
                  style={{ color: colors.textSecondary }}
                >
                  <Share size={responsive.iconSize} />
                  <span 
                    className="font-semibold"
                    style={{ fontSize: responsive.bodySize }}
                  >
                    Share
                  </span>
                </button>
              </div>

              <button
                className="p-2 rounded-full transition-colors duration-200"
                style={{ color: colors.textSecondary }}
              >
                <MoreVertical size={responsive.iconSize} />
              </button>
            </div>
          </motion.div>

          {/* Comments Section */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.5, duration: 0.5 }}
            className="rounded-2xl p-5 border mb-6"
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
              className="font-bold mb-4"
            >
              Comments ({commentsData.length})
            </h3>

            {/* Add Comment */}
            <div className="flex space-x-3 mb-6">
              <img
                src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100"
                alt="Your Avatar"
                className="rounded-full object-cover flex-shrink-0"
                style={{ 
                  width: responsive.avatarSize - 8, 
                  height: responsive.avatarSize - 8 
                }}
              />
              
              <div className="flex-1">
                <div className="relative">
                  <textarea
                    value={newComment}
                    onChange={(e) => setNewComment(e.target.value)}
                    placeholder="Add a comment..."
                    className="w-full p-3 rounded-xl border resize-none outline-none transition-all duration-200"
                    style={{ 
                      background: colors.inputBackground,
                      borderColor: colors.borderMedium,
                      color: colors.textPrimary,
                      fontSize: responsive.bodySize
                    }}
                    rows={3}
                  />
                  
                  <motion.button
                    whileTap={{ scale: 0.95 }}
                    whileHover={{ scale: 1.05 }}
                    onClick={handleAddComment}
                    disabled={!newComment.trim()}
                    className={`absolute bottom-3 right-3 px-4 py-2 rounded-lg font-semibold transition-all duration-200 ${
                      newComment.trim() 
                        ? 'bg-gradient-to-r from-purple-600 to-purple-500 text-white' 
                        : 'bg-gray-300 text-gray-500 cursor-not-allowed'
                    }`}
                    style={{ fontSize: responsive.metaSize }}
                  >
                    Post
                  </motion.button>
                </div>
              </div>
            </div>

            {/* Comments List */}
            <div className="space-y-4">
              <AnimatePresence>
                {commentsData.map((comment, index) => (
                  <motion.div
                    key={comment.id}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -20 }}
                    transition={{ delay: index * 0.1 }}
                    className="flex space-x-3"
                  >
                    <img
                      src={comment.authorAvatar}
                      alt={comment.author}
                      className="rounded-full object-cover flex-shrink-0"
                      style={{ 
                        width: responsive.avatarSize - 8, 
                        height: responsive.avatarSize - 8 
                      }}
                    />
                    
                    <div className="flex-1">
                      <div 
                        className="p-3 rounded-xl border"
                        style={{ 
                          background: colors.inputBackground,
                          borderColor: colors.borderLight
                        }}
                      >
                        <div className="flex items-center justify-between mb-2">
                          <span 
                            style={{ 
                              color: colors.textPrimary, 
                              fontSize: responsive.bodySize 
                            }}
                            className="font-semibold"
                          >
                            {comment.author}
                          </span>
                          
                          <span 
                            style={{ 
                              color: colors.textSecondary, 
                              fontSize: responsive.metaSize 
                            }}
                          >
                            {comment.timestamp}
                          </span>
                        </div>
                        
                        <p 
                          style={{ 
                            color: colors.textSecondary, 
                            fontSize: responsive.bodySize 
                          }}
                          className="leading-relaxed"
                        >
                          {comment.content}
                        </p>
                      </div>
                      
                      <div className="flex items-center space-x-4 mt-2 ml-3">
                        <motion.button
                          whileTap={{ scale: 0.9 }}
                          onClick={() => handleCommentLike(comment.id)}
                          className={`flex items-center space-x-1 transition-colors duration-200 ${
                            comment.isLiked ? 'text-red-500' : ''
                          }`}
                          style={{ color: comment.isLiked ? '#EF4444' : colors.textSecondary }}
                        >
                          <Heart 
                            size={14} 
                            className={comment.isLiked ? 'fill-current' : ''} 
                          />
                          <span 
                            style={{ fontSize: responsive.metaSize }}
                            className="font-medium"
                          >
                            {comment.likes}
                          </span>
                        </motion.button>
                        
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
                  </motion.div>
                ))}
              </AnimatePresence>
            </div>
          </motion.div>

          {/* Bottom spacing for safe area */}
          <div className="h-20" />
        </div>
      </div>
    </div>
  );
};

export default MemoryDetailScreen;