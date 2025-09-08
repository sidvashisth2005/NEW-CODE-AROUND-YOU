import React from 'react';
import { motion } from 'motion/react';
import { Heart, Send, Smile } from 'lucide-react';
import { useTheme } from '../ThemeContext';

interface Comment {
  id: number;
  author: string;
  avatar: string;
  text: string;
  time: string;
  likes: number;
}

interface CommentSectionProps {
  comments: Comment[];
  commentText: string;
  setCommentText: (text: string) => void;
  onSendComment: () => void;
}

export const CommentSection: React.FC<CommentSectionProps> = ({
  comments,
  commentText,
  setCommentText,
  onSendComment
}) => {
  const { colors, isDarkMode, hapticFeedback, playSound } = useTheme();

  const handleLikeComment = (commentId: number) => {
    hapticFeedback && hapticFeedback('light');
    playSound && playSound('tap');
  };

  const handleEmojiClick = () => {
    hapticFeedback && hapticFeedback('light');
    playSound && playSound('tap');
  };

  const handleSendClick = () => {
    if (commentText.trim()) {
      onSendComment();
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.4, duration: 0.5, type: "spring" }}
      className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.borderMedium}`}
      style={{ 
        background: colors.glassBackground,
        boxShadow: colors.shadowLg
      }}
    >
      <h3 className={`${colors.textPrimary} font-semibold mb-4 flex items-center`}>
        Comments ({comments.length})
      </h3>

      {/* Comments List */}
      <div className="space-y-4 mb-6">
        {comments.map((comment, index) => (
          <motion.div
            key={comment.id}
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.5 + index * 0.1, duration: 0.4, type: "spring" }}
            className="flex space-x-3"
          >
            <div 
              className="w-8 h-8 bg-gradient-to-r from-purple-500 to-blue-500 rounded-full flex items-center justify-center flex-shrink-0"
              style={{ boxShadow: colors.shadowSm }}
            >
              <span className="text-white text-sm font-semibold">{comment.avatar}</span>
            </div>
            <div className="flex-1">
              <div 
                className={`glass-card rounded-[16px] p-3 backdrop-blur-md border ${colors.borderMedium}`}
                style={{ 
                  background: colors.glassBackground,
                  boxShadow: colors.shadowSm
                }}
              >
                <div className="flex items-center space-x-2 mb-1">
                  <span className={`${colors.textPrimary} font-medium text-sm`}>{comment.author}</span>
                  <span className={`${colors.textSecondary} text-xs`}>{comment.time}</span>
                </div>
                <p className={`${colors.textSecondary} text-sm leading-relaxed`}>{comment.text}</p>
              </div>
              <div className="flex items-center space-x-4 mt-2 ml-3">
                <motion.button 
                  whileTap={{ scale: 0.9 }}
                  onClick={() => handleLikeComment(comment.id)}
                  className={`flex items-center space-x-1 ${colors.textSecondary} hover:${colors.textPrimary} transition-colors`}
                >
                  <Heart size={12} />
                  <span className="text-xs">{comment.likes}</span>
                </motion.button>
                <button className={`${colors.textSecondary} hover:${colors.textPrimary} text-xs transition-colors`}>
                  Reply
                </button>
              </div>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Comment Input */}
      <div 
        className={`glass-card rounded-[16px] p-3 backdrop-blur-md border ${colors.borderMedium}`}
        style={{ 
          background: colors.glassBackground,
          boxShadow: colors.shadowSm
        }}
      >
        <div className="flex items-center space-x-3">
          <div 
            className="w-8 h-8 bg-gradient-to-r from-purple-500 to-blue-500 rounded-full flex items-center justify-center flex-shrink-0"
            style={{ boxShadow: colors.shadowSm }}
          >
            <span className="text-white text-sm font-semibold">Y</span>
          </div>
          <input
            type="text"
            value={commentText}
            onChange={(e) => setCommentText(e.target.value)}
            placeholder="Add a comment..."
            className={`flex-1 bg-transparent ${colors.textPrimary} placeholder:${colors.textSecondary} focus:outline-none`}
            onKeyPress={(e) => e.key === 'Enter' && handleSendClick()}
          />
          <motion.button 
            whileTap={{ scale: 0.9 }}
            onClick={handleEmojiClick}
            className={`${colors.textSecondary} hover:${colors.textPrimary} transition-colors`}
          >
            <Smile size={18} />
          </motion.button>
          <motion.button
            whileTap={{ scale: 0.9 }}
            whileHover={{ scale: 1.05 }}
            onClick={handleSendClick}
            disabled={!commentText.trim()}
            className={`w-8 h-8 bg-gradient-to-r from-purple-600 to-purple-500 rounded-full flex items-center justify-center transition-opacity ${
              commentText.trim() ? 'opacity-100' : 'opacity-50'
            }`}
            style={{ 
              boxShadow: colors.shadowPurple
            }}
          >
            <Send size={14} className="text-white" />
          </motion.button>
        </div>
      </div>
    </motion.div>
  );
};