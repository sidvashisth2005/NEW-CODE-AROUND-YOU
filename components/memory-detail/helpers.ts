import { MEMORY_TYPE_CONFIG } from './constants';

export const getTypeIcon = (type: string) => {
  return MEMORY_TYPE_CONFIG[type as keyof typeof MEMORY_TYPE_CONFIG]?.icon || MEMORY_TYPE_CONFIG.photo.icon;
};

export const getTypeColor = (type: string) => {
  return MEMORY_TYPE_CONFIG[type as keyof typeof MEMORY_TYPE_CONFIG]?.color || MEMORY_TYPE_CONFIG.photo.color;
};

export const createNewComment = (text: string, commentsLength: number) => {
  return {
    id: commentsLength + 1,
    author: 'You',
    avatar: 'Y',
    text: text.trim(),
    time: 'Just now',
    likes: 0
  };
};

export const formatViewCount = (count: number) => {
  if (count >= 1000) {
    return `${(count / 1000).toFixed(1)}k`;
  }
  return count.toString();
};