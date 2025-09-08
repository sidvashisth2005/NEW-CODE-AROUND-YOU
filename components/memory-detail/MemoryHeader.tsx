import React from 'react';
import { motion } from 'motion/react';
import { Clock, MapPin, Eye } from 'lucide-react';
import { getTypeIcon, getTypeColor } from './helpers';
import { useTheme } from '../ThemeContext';

interface MemoryHeaderProps {
  memory: any;
}

export const MemoryHeader: React.FC<MemoryHeaderProps> = ({ memory }) => {
  const { colors, isDarkMode } = useTheme();
  const TypeIcon = getTypeIcon(memory.type);
  const typeColor = getTypeColor(memory.type);

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.1, duration: 0.5, type: "spring" }}
      className={`glass-card rounded-[24px] p-6 backdrop-blur-xl mb-6 border ${colors.borderMedium}`}
      style={{ 
        background: colors.glassBackground,
        boxShadow: colors.shadowLg
      }}
    >
      {/* Author Info */}
      <div className="flex items-center space-x-4 mb-4">
        <div 
          className="w-12 h-12 bg-gradient-to-r from-purple-500 to-blue-500 rounded-full flex items-center justify-center"
          style={{ boxShadow: colors.shadowSm }}
        >
          <span className="text-white font-bold">{memory.avatar || memory.author?.[0] || 'M'}</span>
        </div>
        <div className="flex-1">
          <h3 className={`${colors.textPrimary} font-semibold`}>{memory.author || 'Anonymous'}</h3>
          <div className={`flex items-center space-x-2 ${colors.textSecondary} text-sm`}>
            <Clock size={14} />
            <span>{memory.time || '2 hours ago'}</span>
            <span>•</span>
            <MapPin size={14} />
            <span>{memory.location || 'Downtown SF'}</span>
          </div>
        </div>
        <div 
          className={`w-8 h-8 bg-gradient-to-r ${typeColor} rounded-full flex items-center justify-center`}
          style={{ boxShadow: colors.shadowSm }}
        >
          <TypeIcon size={16} className="text-white" />
        </div>
      </div>

      {/* Memory Title */}
      <h1 className={`${colors.textPrimary} text-2xl font-bold mb-3`}>
        {memory.title || 'Amazing Discovery'}
      </h1>
      
      {/* Memory Description */}
      <p className={`${colors.textSecondary} leading-relaxed mb-4`}>
        {memory.description || 'This is an incredible memory captured in this beautiful location. The experience was truly unforgettable and worth sharing with the community.'}
      </p>

      {/* Interaction Stats */}
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-6">
          <div className={`flex items-center space-x-2 ${colors.textSecondary}`}>
            <Eye size={16} />
            <span className="text-sm">1.2k views</span>
          </div>
          <div className={`flex items-center space-x-2 ${colors.textSecondary}`}>
            <MapPin size={16} />
            <span className="text-sm">{memory.distance || '50'}m away</span>
          </div>
        </div>
        <div className={`flex items-center space-x-1 ${colors.textSecondary} text-sm`}>
          <span className="capitalize">{memory.type || 'photo'}</span>
          <span>memory</span>
        </div>
      </div>
    </motion.div>
  );
};