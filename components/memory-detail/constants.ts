import { Camera, Video, Mic, Type } from 'lucide-react';

export const DEFAULT_MEMORY = {
  id: 1,
  title: 'Golden Gate Sunset',
  description: 'Captured this magical moment during golden hour at the Golden Gate Bridge. The sky was painted with the most beautiful colors I\'ve ever seen.',
  type: 'photo',
  likes: 24,
  comments: 3,
  time: '2h ago',
  location: 'Golden Gate Bridge',
  author: 'Alex Rivera',
  avatar: 'A'
};

export const INITIAL_COMMENTS = [
  {
    id: 1,
    author: 'Sarah Chen',
    avatar: 'S',
    text: 'This is absolutely stunning! The colors are incredible 🌅',
    time: '2h ago',
    likes: 12
  },
  {
    id: 2,
    author: 'Mike Johnson',
    avatar: 'M',
    text: 'I was there yesterday too! Such a magical place',
    time: '1h ago',
    likes: 8
  },
  {
    id: 3,
    author: 'Emma Watson',
    avatar: 'E',
    text: 'Amazing shot! What camera did you use?',
    time: '45m ago',
    likes: 5
  }
];

export const MEMORY_TYPE_CONFIG = {
  photo: { icon: Camera, color: 'from-blue-500 to-cyan-500' },
  video: { icon: Video, color: 'from-red-500 to-pink-500' },
  audio: { icon: Mic, color: 'from-green-500 to-emerald-500' },
  text: { icon: Type, color: 'from-purple-500 to-violet-500' }
};