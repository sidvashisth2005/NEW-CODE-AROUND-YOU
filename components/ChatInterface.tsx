import React, { useState, useEffect, useRef } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { 
  ArrowLeft, 
  Send, 
  Plus, 
  Camera, 
  Image, 
  MapPin, 
  Smile, 
  MoreVertical,
  Phone,
  Video,
  Info,
  Search,
  Archive,
  Star,
  Volume2,
  VolumeX,
  UserPlus,
  Users
} from 'lucide-react';
import { useTheme } from './ThemeContext';
import { ImageWithFallback } from './figma/ImageWithFallback';

interface Message {
  id: string;
  content: string;
  sender: {
    id: string;
    name: string;
    avatar: string;
  };
  timestamp: Date;
  type: 'text' | 'image' | 'location' | 'memory';
  status: 'sending' | 'sent' | 'delivered' | 'read';
  reactions?: { emoji: string; users: string[] }[];
  replyTo?: string;
  attachment?: {
    type: 'image' | 'memory' | 'location';
    url?: string;
    title?: string;
    description?: string;
  };
}

interface ChatData {
  id: string;
  name: string;
  avatar: string;
  isOnline: boolean;
  lastSeen?: Date;
  type: 'direct' | 'group';
  participants?: Array<{
    id: string;
    name: string;
    avatar: string;
    isOnline: boolean;
  }>;
  isTyping?: boolean;
  isMuted?: boolean;
}

interface ChatInterfaceProps {
  chat: ChatData | null;
  onBack: () => void;
  onNavigate: (screen: string, isSubScreen?: boolean, data?: any) => void;
}

const ChatInterface: React.FC<ChatInterfaceProps> = ({ 
  chat, 
  onBack, 
  onNavigate 
}) => {
  const { colors, isDarkMode, hapticFeedback, playSound } = useTheme();
  
  // State management
  const [messages, setMessages] = useState<Message[]>([]);
  const [newMessage, setNewMessage] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const [showAttachmentMenu, setShowAttachmentMenu] = useState(false);
  const [replyingTo, setReplyingTo] = useState<Message | null>(null);
  const [selectedMessages, setSelectedMessages] = useState<Set<string>>(new Set());
  const [isSelectionMode, setIsSelectionMode] = useState(false);

  // Refs
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

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

  // Default chat data
  const defaultChat: ChatData = {
    id: '1',
    name: 'Sarah Chen',
    avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b691?w=100',
    isOnline: true,
    type: 'direct',
    isTyping: false,
    isMuted: false
  };

  const displayChat = chat || defaultChat;

  // Sample messages
  useEffect(() => {
    const sampleMessages: Message[] = [
      {
        id: '1',
        content: 'Hey! I just discovered the most amazing coffee shop downtown ☕',
        sender: {
          id: 'sarah',
          name: 'Sarah Chen',
          avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b691?w=100'
        },
        timestamp: new Date(Date.now() - 3600000),
        type: 'text',
        status: 'read'
      },
      {
        id: '2',
        content: 'That sounds awesome! Where is it exactly?',
        sender: {
          id: 'me',
          name: 'You',
          avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100'
        },
        timestamp: new Date(Date.now() - 3500000),
        type: 'text',
        status: 'read'
      },
      {
        id: '3',
        content: '',
        sender: {
          id: 'sarah',
          name: 'Sarah Chen',
          avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b691?w=100'
        },
        timestamp: new Date(Date.now() - 3400000),
        type: 'location',
        status: 'read',
        attachment: {
          type: 'location',
          title: 'Central Perk Café',
          description: '123 Main Street, Downtown'
        }
      },
      {
        id: '4',
        content: 'Check out this latte art! 📸',
        sender: {
          id: 'sarah',
          name: 'Sarah Chen',
          avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b691?w=100'
        },
        timestamp: new Date(Date.now() - 3300000),
        type: 'image',
        status: 'read',
        attachment: {
          type: 'image',
          url: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=400'
        }
      },
      {
        id: '5',
        content: 'Wow, that looks incredible! I\'ll definitely check it out this weekend 😍',
        sender: {
          id: 'me',
          name: 'You',
          avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100'
        },
        timestamp: new Date(Date.now() - 3200000),
        type: 'text',
        status: 'read',
        reactions: [
          { emoji: '❤️', users: ['sarah'] }
        ]
      }
    ];
    
    setMessages(sampleMessages);
  }, []);

  // Scroll to bottom on new messages
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  // Responsive sizing
  const getResponsiveValues = () => {
    const base = {
      padding: screenSize === 'small' ? 16 : screenSize === 'medium' ? 20 : 24,
      titleSize: screenSize === 'small' ? 16 : screenSize === 'medium' ? 18 : 20,
      bodySize: screenSize === 'small' ? 14 : screenSize === 'medium' ? 15 : 16,
      metaSize: screenSize === 'small' ? 11 : screenSize === 'medium' ? 12 : 13,
      iconSize: screenSize === 'small' ? 18 : screenSize === 'medium' ? 20 : 22,
      avatarSize: screenSize === 'small' ? 32 : screenSize === 'medium' ? 36 : 40,
      headerHeight: screenSize === 'small' ? 60 : screenSize === 'medium' ? 64 : 68,
      inputHeight: screenSize === 'small' ? 44 : screenSize === 'medium' ? 48 : 52,
    };
    return base;
  };

  const responsive = getResponsiveValues();

  // Event handlers
  const handleSendMessage = () => {
    if (newMessage.trim()) {
      const message: Message = {
        id: Date.now().toString(),
        content: newMessage.trim(),
        sender: {
          id: 'me',
          name: 'You',
          avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100'
        },
        timestamp: new Date(),
        type: 'text',
        status: 'sending',
        replyTo: replyingTo?.id
      };

      setMessages(prev => [...prev, message]);
      setNewMessage('');
      setReplyingTo(null);
      hapticFeedback?.('light');
      playSound?.('send');

      // Simulate message delivery
      setTimeout(() => {
        setMessages(prev => prev.map(msg => 
          msg.id === message.id ? { ...msg, status: 'delivered' } : msg
        ));
      }, 1000);
    }
  };

  const handleAttachment = (type: 'camera' | 'image' | 'location') => {
    setShowAttachmentMenu(false);
    hapticFeedback?.('medium');

    let message: Message;
    const baseMessage = {
      id: Date.now().toString(),
      sender: {
        id: 'me',
        name: 'You',
        avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100'
      },
      timestamp: new Date(),
      status: 'sending' as const
    };

    switch (type) {
      case 'location':
        message = {
          ...baseMessage,
          content: '',
          type: 'location',
          attachment: {
            type: 'location',
            title: 'Current Location',
            description: 'Shared live location'
          }
        };
        break;
      case 'image':
      case 'camera':
        message = {
          ...baseMessage,
          content: 'Shared a photo',
          type: 'image',
          attachment: {
            type: 'image',
            url: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400'
          }
        };
        break;
    }

    setMessages(prev => [...prev, message]);
  };

  const handleMessageReaction = (messageId: string, emoji: string) => {
    setMessages(prev => prev.map(msg => {
      if (msg.id === messageId) {
        const reactions = msg.reactions || [];
        const existingReaction = reactions.find(r => r.emoji === emoji);
        
        if (existingReaction) {
          if (existingReaction.users.includes('me')) {
            // Remove reaction
            existingReaction.users = existingReaction.users.filter(u => u !== 'me');
            if (existingReaction.users.length === 0) {
              return { ...msg, reactions: reactions.filter(r => r.emoji !== emoji) };
            }
          } else {
            // Add reaction
            existingReaction.users.push('me');
          }
        } else {
          // Create new reaction
          reactions.push({ emoji, users: ['me'] });
        }
        
        return { ...msg, reactions };
      }
      return msg;
    }));
    
    hapticFeedback?.('light');
  };

  const handleMessageSelect = (messageId: string) => {
    if (isSelectionMode) {
      const newSelected = new Set(selectedMessages);
      if (newSelected.has(messageId)) {
        newSelected.delete(messageId);
      } else {
        newSelected.add(messageId);
      }
      setSelectedMessages(newSelected);
      
      if (newSelected.size === 0) {
        setIsSelectionMode(false);
      }
    }
  };

  const formatTime = (date: Date) => {
    return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  };

  const formatLastSeen = (date: Date) => {
    const now = new Date();
    const diff = now.getTime() - date.getTime();
    const minutes = Math.floor(diff / 60000);
    
    if (minutes < 1) return 'Active now';
    if (minutes < 60) return `Active ${minutes}m ago`;
    
    const hours = Math.floor(minutes / 60);
    if (hours < 24) return `Active ${hours}h ago`;
    
    const days = Math.floor(hours / 24);
    return `Active ${days}d ago`;
  };

  const MessageBubble: React.FC<{ message: Message; isOwn: boolean }> = ({ message, isOwn }) => {
    const [showOptions, setShowOptions] = useState(false);

    return (
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className={`flex ${isOwn ? 'justify-end' : 'justify-start'} mb-4`}
      >
        <div className={`flex max-w-[80%] ${isOwn ? 'flex-row-reverse' : 'flex-row'} items-end space-x-2`}>
          {!isOwn && (
            <img
              src={message.sender.avatar}
              alt={message.sender.name}
              className="rounded-full object-cover flex-shrink-0"
              style={{ 
                width: responsive.avatarSize, 
                height: responsive.avatarSize 
              }}
            />
          )}
          
          <div className={`${isOwn ? 'mr-2' : 'ml-2'}`}>
            {/* Reply indicator */}
            {message.replyTo && (
              <div 
                className={`p-2 mb-1 rounded-lg border-l-4 ${isOwn ? 'ml-8' : 'mr-8'}`}
                style={{ 
                  background: colors.glassBackground,
                  borderColor: colors.accent,
                  borderLeftColor: colors.accent
                }}
              >
                <p 
                  style={{ 
                    color: colors.textSecondary, 
                    fontSize: responsive.metaSize 
                  }}
                  className="truncate"
                >
                  Replying to previous message
                </p>
              </div>
            )}

            <motion.div
              whileTap={{ scale: 0.98 }}
              onLongPress={() => setShowOptions(!showOptions)}
              onClick={() => handleMessageSelect(message.id)}
              className={`relative p-3 rounded-2xl ${
                isOwn 
                  ? 'bg-gradient-to-r from-purple-600 to-purple-500 text-white' 
                  : 'border'
              } ${
                selectedMessages.has(message.id) ? 'ring-2 ring-blue-500' : ''
              }`}
              style={{
                background: isOwn 
                  ? undefined 
                  : colors.glassBackground,
                borderColor: isOwn 
                  ? undefined 
                  : colors.borderMedium,
                boxShadow: isOwn ? colors.shadowPurple : colors.shadowSm
              }}
            >
              {/* Text content */}
              {message.type === 'text' && (
                <p 
                  style={{ 
                    color: isOwn ? 'white' : colors.textPrimary,
                    fontSize: responsive.bodySize 
                  }}
                  className="leading-relaxed break-words"
                >
                  {message.content}
                </p>
              )}

              {/* Image attachment */}
              {message.type === 'image' && message.attachment?.url && (
                <div className="space-y-2">
                  <ImageWithFallback
                    src={message.attachment.url}
                    alt="Shared image"
                    className="rounded-xl max-w-full h-auto"
                    style={{ maxHeight: '300px', objectFit: 'cover' }}
                  />
                  {message.content && (
                    <p 
                      style={{ 
                        color: isOwn ? 'white' : colors.textPrimary,
                        fontSize: responsive.bodySize 
                      }}
                    >
                      {message.content}
                    </p>
                  )}
                </div>
              )}

              {/* Location attachment */}
              {message.type === 'location' && message.attachment && (
                <div 
                  className="p-3 rounded-xl border"
                  style={{ 
                    background: isOwn ? 'rgba(255, 255, 255, 0.1)' : colors.inputBackground,
                    borderColor: isOwn ? 'rgba(255, 255, 255, 0.2)' : colors.borderLight
                  }}
                >
                  <div className="flex items-center space-x-2 mb-2">
                    <MapPin 
                      size={16} 
                      style={{ color: isOwn ? 'white' : colors.accent }}
                    />
                    <span 
                      style={{ 
                        color: isOwn ? 'white' : colors.textPrimary,
                        fontSize: responsive.bodySize 
                      }}
                      className="font-medium"
                    >
                      {message.attachment.title}
                    </span>
                  </div>
                  <p 
                    style={{ 
                      color: isOwn ? 'rgba(255, 255, 255, 0.8)' : colors.textSecondary,
                      fontSize: responsive.metaSize 
                    }}
                  >
                    {message.attachment.description}
                  </p>
                </div>
              )}

              {/* Reactions */}
              {message.reactions && message.reactions.length > 0 && (
                <div className="flex flex-wrap gap-1 mt-2">
                  {message.reactions.map((reaction, index) => (
                    <motion.button
                      key={index}
                      whileTap={{ scale: 0.9 }}
                      onClick={() => handleMessageReaction(message.id, reaction.emoji)}
                      className="flex items-center space-x-1 px-2 py-1 rounded-full border text-xs"
                      style={{ 
                        background: reaction.users.includes('me') 
                          ? colors.accent + '20' 
                          : colors.glassBackground,
                        borderColor: reaction.users.includes('me') 
                          ? colors.accent 
                          : colors.borderLight
                      }}
                    >
                      <span>{reaction.emoji}</span>
                      <span style={{ color: colors.textSecondary }}>
                        {reaction.users.length}
                      </span>
                    </motion.button>
                  ))}
                </div>
              )}

              {/* Message status */}
              {isOwn && (
                <div className="flex items-center justify-end mt-1 space-x-1">
                  <span 
                    style={{ 
                      color: 'rgba(255, 255, 255, 0.7)',
                      fontSize: responsive.metaSize 
                    }}
                  >
                    {formatTime(message.timestamp)}
                  </span>
                  <div className="flex space-x-1">
                    {message.status === 'sending' && (
                      <div 
                        className="w-2 h-2 rounded-full animate-pulse"
                        style={{ background: 'rgba(255, 255, 255, 0.5)' }}
                      />
                    )}
                    {message.status === 'sent' && (
                      <div 
                        className="w-2 h-2 rounded-full"
                        style={{ background: 'rgba(255, 255, 255, 0.7)' }}
                      />
                    )}
                    {message.status === 'delivered' && (
                      <div className="flex space-x-0.5">
                        <div 
                          className="w-2 h-2 rounded-full"
                          style={{ background: 'rgba(255, 255, 255, 0.7)' }}
                        />
                        <div 
                          className="w-2 h-2 rounded-full"
                          style={{ background: 'rgba(255, 255, 255, 0.7)' }}
                        />
                      </div>
                    )}
                    {message.status === 'read' && (
                      <div className="flex space-x-0.5">
                        <div className="w-2 h-2 rounded-full bg-blue-400" />
                        <div className="w-2 h-2 rounded-full bg-blue-400" />
                      </div>
                    )}
                  </div>
                </div>
              )}

              {!isOwn && (
                <p 
                  style={{ 
                    color: colors.textSecondary, 
                    fontSize: responsive.metaSize 
                  }}
                  className="mt-1"
                >
                  {formatTime(message.timestamp)}
                </p>
              )}
            </motion.div>

            {/* Quick reactions */}
            <AnimatePresence>
              {showOptions && (
                <motion.div
                  initial={{ opacity: 0, scale: 0.8 }}
                  animate={{ opacity: 1, scale: 1 }}
                  exit={{ opacity: 0, scale: 0.8 }}
                  className={`flex space-x-2 mt-2 ${isOwn ? 'justify-end' : 'justify-start'}`}
                >
                  {['❤️', '😂', '👍', '😮', '😢', '😡'].map((emoji) => (
                    <motion.button
                      key={emoji}
                      whileTap={{ scale: 0.8 }}
                      onClick={() => {
                        handleMessageReaction(message.id, emoji);
                        setShowOptions(false);
                      }}
                      className="w-8 h-8 rounded-full flex items-center justify-center border"
                      style={{ 
                        background: colors.glassBackground,
                        borderColor: colors.borderMedium
                      }}
                    >
                      <span className="text-sm">{emoji}</span>
                    </motion.button>
                  ))}
                </motion.div>
              )}
            </AnimatePresence>
          </div>
        </div>
      </motion.div>
    );
  };

  return (
    <div className={`h-screen w-full flex flex-col bg-gradient-to-br ${colors.background}`}>
      {/* Header */}
      <div 
        className="flex-shrink-0 pt-12 pb-3 border-b backdrop-blur-md"
        style={{ 
          background: `${colors.glassBackground}99`,
          borderColor: colors.borderLight,
          padding: `48px ${responsive.padding}px 12px`,
          height: responsive.headerHeight + 48
        }}
      >
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <motion.button
              whileTap={{ scale: 0.95 }}
              whileHover={{ scale: 1.05 }}
              onClick={onBack}
              className="w-10 h-10 rounded-full flex items-center justify-center border"
              style={{ 
                background: colors.glassBackground,
                borderColor: colors.borderMedium
              }}
            >
              <ArrowLeft size={responsive.iconSize} style={{ color: colors.textPrimary }} />
            </motion.button>

            <div className="flex items-center space-x-3">
              <div className="relative">
                <img
                  src={displayChat.avatar}
                  alt={displayChat.name}
                  className="rounded-full object-cover"
                  style={{ 
                    width: responsive.avatarSize + 8, 
                    height: responsive.avatarSize + 8 
                  }}
                />
                {displayChat.isOnline && (
                  <div 
                    className="absolute bottom-0 right-0 w-3 h-3 bg-green-400 rounded-full border-2"
                    style={{ borderColor: colors.background.split(' ')[1] === 'from-gray-50' ? 'white' : 'black' }}
                  />
                )}
              </div>

              <div>
                <h2 
                  style={{ 
                    color: colors.textPrimary, 
                    fontSize: responsive.titleSize 
                  }}
                  className="font-bold"
                >
                  {displayChat.name}
                </h2>
                <p 
                  style={{ 
                    color: colors.textSecondary, 
                    fontSize: responsive.metaSize 
                  }}
                >
                  {displayChat.isOnline 
                    ? (displayChat.isTyping ? 'Typing...' : 'Active now')
                    : displayChat.lastSeen ? formatLastSeen(displayChat.lastSeen) : 'Offline'
                  }
                </p>
              </div>
            </div>
          </div>

          <div className="flex items-center space-x-2">
            <motion.button
              whileTap={{ scale: 0.95 }}
              whileHover={{ scale: 1.05 }}
              className="w-10 h-10 rounded-full flex items-center justify-center border"
              style={{ 
                background: colors.glassBackground,
                borderColor: colors.borderMedium
              }}
            >
              <Phone size={responsive.iconSize} style={{ color: colors.textPrimary }} />
            </motion.button>

            <motion.button
              whileTap={{ scale: 0.95 }}
              whileHover={{ scale: 1.05 }}
              className="w-10 h-10 rounded-full flex items-center justify-center border"
              style={{ 
                background: colors.glassBackground,
                borderColor: colors.borderMedium
              }}
            >
              <Video size={responsive.iconSize} style={{ color: colors.textPrimary }} />
            </motion.button>

            <motion.button
              whileTap={{ scale: 0.95 }}
              whileHover={{ scale: 1.05 }}
              onClick={() => onNavigate('chat-settings', true, displayChat)}
              className="w-10 h-10 rounded-full flex items-center justify-center border"
              style={{ 
                background: colors.glassBackground,
                borderColor: colors.borderMedium
              }}
            >
              <Info size={responsive.iconSize} style={{ color: colors.textPrimary }} />
            </motion.button>
          </div>
        </div>
      </div>

      {/* Messages Area */}
      <div className="flex-1 overflow-y-auto scrollbar-hide">
        <div style={{ padding: responsive.padding }}>
          {messages.map((message) => (
            <MessageBubble 
              key={message.id}
              message={message}
              isOwn={message.sender.id === 'me'}
            />
          ))}
          
          {/* Typing indicator */}
          {displayChat.isTyping && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              className="flex justify-start mb-4"
            >
              <div className="flex items-end space-x-2">
                <img
                  src={displayChat.avatar}
                  alt={displayChat.name}
                  className="rounded-full object-cover"
                  style={{ 
                    width: responsive.avatarSize, 
                    height: responsive.avatarSize 
                  }}
                />
                <div 
                  className="p-3 rounded-2xl border"
                  style={{ 
                    background: colors.glassBackground,
                    borderColor: colors.borderMedium
                  }}
                >
                  <div className="flex space-x-1">
                    {[0, 1, 2].map((i) => (
                      <motion.div
                        key={i}
                        animate={{ 
                          scale: [1, 1.2, 1],
                          opacity: [0.5, 1, 0.5]
                        }}
                        transition={{ 
                          duration: 1.4,
                          repeat: Infinity,
                          delay: i * 0.2
                        }}
                        className="w-2 h-2 rounded-full"
                        style={{ background: colors.textSecondary }}
                      />
                    ))}
                  </div>
                </div>
              </div>
            </motion.div>
          )}
          
          <div ref={messagesEndRef} />
        </div>
      </div>

      {/* Reply preview */}
      <AnimatePresence>
        {replyingTo && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 20 }}
            className="border-t border-l-4 p-3"
            style={{ 
              background: colors.glassBackground,
              borderColor: colors.borderLight,
              borderLeftColor: colors.accent
            }}
          >
            <div className="flex items-center justify-between">
              <div className="flex-1">
                <p 
                  style={{ 
                    color: colors.accent, 
                    fontSize: responsive.metaSize 
                  }}
                  className="font-medium"
                >
                  Replying to {replyingTo.sender.name}
                </p>
                <p 
                  style={{ 
                    color: colors.textSecondary, 
                    fontSize: responsive.metaSize 
                  }}
                  className="truncate"
                >
                  {replyingTo.content}
                </p>
              </div>
              <motion.button
                whileTap={{ scale: 0.95 }}
                onClick={() => setReplyingTo(null)}
                className="p-1"
              >
                <ArrowLeft size={16} style={{ color: colors.textSecondary }} />
              </motion.button>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Input Area */}
      <div 
        className="flex-shrink-0 border-t p-4"
        style={{ 
          background: colors.glassBackground,
          borderColor: colors.borderLight
        }}
      >
        <div className="flex items-end space-x-3">
          {/* Attachment Menu */}
          <div className="relative">
            <motion.button
              whileTap={{ scale: 0.95 }}
              whileHover={{ scale: 1.05 }}
              onClick={() => setShowAttachmentMenu(!showAttachmentMenu)}
              className="w-10 h-10 rounded-full flex items-center justify-center border"
              style={{ 
                background: showAttachmentMenu ? colors.accent : colors.glassBackground,
                borderColor: showAttachmentMenu ? colors.accent : colors.borderMedium,
                height: responsive.inputHeight
              }}
            >
              <Plus 
                size={responsive.iconSize} 
                style={{ 
                  color: showAttachmentMenu ? 'white' : colors.textPrimary,
                  transform: showAttachmentMenu ? 'rotate(45deg)' : 'rotate(0deg)',
                  transition: 'transform 0.2s ease'
                }}
              />
            </motion.button>

            <AnimatePresence>
              {showAttachmentMenu && (
                <motion.div
                  initial={{ opacity: 0, scale: 0.8, y: 20 }}
                  animate={{ opacity: 1, scale: 1, y: 0 }}
                  exit={{ opacity: 0, scale: 0.8, y: 20 }}
                  className="absolute bottom-full left-0 mb-2 rounded-2xl border p-2"
                  style={{ 
                    background: colors.glassBackground,
                    borderColor: colors.borderMedium,
                    boxShadow: colors.shadowLg
                  }}
                >
                  <div className="flex space-x-2">
                    <motion.button
                      whileTap={{ scale: 0.95 }}
                      onClick={() => handleAttachment('camera')}
                      className="w-12 h-12 rounded-xl flex flex-col items-center justify-center border"
                      style={{ 
                        background: colors.inputBackground,
                        borderColor: colors.borderLight
                      }}
                    >
                      <Camera size={18} style={{ color: colors.textPrimary }} />
                      <span 
                        style={{ 
                          color: colors.textSecondary, 
                          fontSize: 10 
                        }}
                      >
                        Camera
                      </span>
                    </motion.button>

                    <motion.button
                      whileTap={{ scale: 0.95 }}
                      onClick={() => handleAttachment('image')}
                      className="w-12 h-12 rounded-xl flex flex-col items-center justify-center border"
                      style={{ 
                        background: colors.inputBackground,
                        borderColor: colors.borderLight
                      }}
                    >
                      <Image size={18} style={{ color: colors.textPrimary }} />
                      <span 
                        style={{ 
                          color: colors.textSecondary, 
                          fontSize: 10 
                        }}
                      >
                        Photo
                      </span>
                    </motion.button>

                    <motion.button
                      whileTap={{ scale: 0.95 }}
                      onClick={() => handleAttachment('location')}
                      className="w-12 h-12 rounded-xl flex flex-col items-center justify-center border"
                      style={{ 
                        background: colors.inputBackground,
                        borderColor: colors.borderLight
                      }}
                    >
                      <MapPin size={18} style={{ color: colors.textPrimary }} />
                      <span 
                        style={{ 
                          color: colors.textSecondary, 
                          fontSize: 10 
                        }}
                      >
                        Location
                      </span>
                    </motion.button>
                  </div>
                </motion.div>
              )}
            </AnimatePresence>
          </div>

          {/* Message Input */}
          <div className="flex-1 relative">
            <input
              ref={inputRef}
              value={newMessage}
              onChange={(e) => setNewMessage(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && handleSendMessage()}
              placeholder="Type a message..."
              className="w-full px-4 py-3 rounded-2xl border outline-none transition-all duration-200"
              style={{ 
                background: colors.inputBackground,
                borderColor: colors.borderMedium,
                color: colors.textPrimary,
                fontSize: responsive.bodySize,
                height: responsive.inputHeight
              }}
            />

            <motion.button
              whileTap={{ scale: 0.95 }}
              whileHover={{ scale: 1.05 }}
              className="absolute right-2 top-1/2 transform -translate-y-1/2 w-8 h-8 rounded-full flex items-center justify-center"
              style={{ background: colors.accent }}
            >
              <Smile size={16} className="text-white" />
            </motion.button>
          </div>

          {/* Send Button */}
          <motion.button
            whileTap={{ scale: 0.95 }}
            whileHover={{ scale: 1.05 }}
            onClick={handleSendMessage}
            disabled={!newMessage.trim()}
            className={`rounded-full flex items-center justify-center transition-all duration-200 ${
              newMessage.trim() 
                ? 'bg-gradient-to-r from-purple-600 to-purple-500' 
                : ''
            }`}
            style={{ 
              width: responsive.inputHeight,
              height: responsive.inputHeight,
              background: newMessage.trim() 
                ? undefined 
                : colors.glassBackground,
              border: newMessage.trim() 
                ? 'none' 
                : `1px solid ${colors.borderMedium}`,
              boxShadow: newMessage.trim() ? colors.shadowPurple : 'none'
            }}
          >
            <Send 
              size={responsive.iconSize} 
              style={{ 
                color: newMessage.trim() ? 'white' : colors.textSecondary 
              }}
              className={newMessage.trim() ? 'fill-current' : ''}
            />
          </motion.button>
        </div>
      </div>
    </div>
  );
};

export default ChatInterface;