import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { 
  ArrowLeft, 
  Bell, 
  BellOff, 
  Volume2, 
  VolumeX, 
  Shield, 
  UserMinus, 
  AlertTriangle, 
  Trash2, 
  Archive, 
  Star, 
  Search, 
  Download, 
  Share, 
  Settings, 
  Camera, 
  Edit3, 
  Users, 
  UserPlus, 
  Crown, 
  Palette, 
  Clock,
  Lock,
  Eye,
  EyeOff,
  MessageSquare
} from 'lucide-react';
import { useTheme } from './ThemeContext';
import { ImageWithFallback } from './figma/ImageWithFallback';

interface ChatData {
  id: string;
  name: string;
  avatar: string;
  isOnline: boolean;
  type: 'direct' | 'group';
  participants?: Array<{
    id: string;
    name: string;
    avatar: string;
    isOnline: boolean;
    role?: 'admin' | 'member';
  }>;
  description?: string;
  createdAt?: Date;
  totalMessages?: number;
  sharedMedia?: number;
  mutedUntil?: Date;
  customizations?: {
    wallpaper?: string;
    theme?: string;
  };
}

interface ChatSettingsScreenProps {
  onNavigate: (screen: string, isSubScreen?: boolean, data?: any) => void;
  chat: ChatData | null;
}

const ChatSettingsScreen: React.FC<ChatSettingsScreenProps> = ({ 
  onNavigate, 
  chat 
}) => {
  const { colors, isDarkMode, hapticFeedback, playSound } = useTheme();
  
  // State management
  const [isNotificationsEnabled, setIsNotificationsEnabled] = useState(true);
  const [isSoundEnabled, setIsSoundEnabled] = useState(true);
  const [isMuted, setIsMuted] = useState(false);
  const [isBlocked, setIsBlocked] = useState(false);
  const [showBlockDialog, setShowBlockDialog] = useState(false);
  const [showDeleteDialog, setShowDeleteDialog] = useState(false);
  const [showEditDialog, setShowEditDialog] = useState(false);
  const [editedName, setEditedName] = useState('');
  const [editedDescription, setEditedDescription] = useState('');

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
    description: 'Coffee enthusiast & urban explorer ☕🏙️',
    createdAt: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), // 30 days ago
    totalMessages: 1247,
    sharedMedia: 89,
    participants: [
      {
        id: '1',
        name: 'Sarah Chen',
        avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b691?w=100',
        isOnline: true,
        role: 'admin'
      },
      {
        id: '2',
        name: 'You',
        avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
        isOnline: true,
        role: 'member'
      }
    ]
  };

  const displayChat = chat || defaultChat;

  // Initialize edit form
  useEffect(() => {
    if (displayChat) {
      setEditedName(displayChat.name);
      setEditedDescription(displayChat.description || '');
      setIsMuted(displayChat.mutedUntil ? new Date() < displayChat.mutedUntil : false);
    }
  }, [displayChat]);

  // Responsive sizing
  const getResponsiveValues = () => {
    const base = {
      padding: screenSize === 'small' ? 16 : screenSize === 'medium' ? 20 : 24,
      titleSize: screenSize === 'small' ? 18 : screenSize === 'medium' ? 20 : 22,
      bodySize: screenSize === 'small' ? 14 : screenSize === 'medium' ? 15 : 16,
      metaSize: screenSize === 'small' ? 12 : screenSize === 'medium' ? 13 : 14,
      iconSize: screenSize === 'small' ? 18 : screenSize === 'medium' ? 20 : 22,
      avatarSize: screenSize === 'small' ? 80 : screenSize === 'medium' ? 100 : 120,
      headerHeight: screenSize === 'small' ? 60 : screenSize === 'medium' ? 64 : 68,
    };
    return base;
  };

  const responsive = getResponsiveValues();

  // Event handlers
  const handleBack = () => {
    hapticFeedback?.('light');
    playSound?.('tap');
    onNavigate('chat-interface', true, displayChat);
  };

  const handleMute = () => {
    setIsMuted(!isMuted);
    hapticFeedback?.('medium');
    playSound?.('notification');
  };

  const handleBlock = () => {
    setIsBlocked(!isBlocked);
    setShowBlockDialog(false);
    hapticFeedback?.('warning');
    playSound?.('error');
  };

  const handleDelete = () => {
    setShowDeleteDialog(false);
    hapticFeedback?.('warning');
    playSound?.('error');
    // Navigate back after deletion
    setTimeout(() => onNavigate('chat'), 500);
  };

  const handleSaveEdit = () => {
    setShowEditDialog(false);
    hapticFeedback?.('success');
    playSound?.('success');
  };

  const formatDate = (date: Date) => {
    return date.toLocaleDateString('en-US', { 
      month: 'long', 
      day: 'numeric', 
      year: 'numeric' 
    });
  };

  const SettingItem: React.FC<{
    icon: React.ReactNode;
    title: string;
    subtitle?: string;
    value?: string;
    isSwitch?: boolean;
    switchValue?: boolean;
    onSwitchChange?: (value: boolean) => void;
    onPress?: () => void;
    danger?: boolean;
    showArrow?: boolean;
  }> = ({ 
    icon, 
    title, 
    subtitle, 
    value, 
    isSwitch, 
    switchValue, 
    onSwitchChange, 
    onPress,
    danger,
    showArrow = true
  }) => (
    <motion.div
      whileTap={{ scale: onPress ? 0.98 : 1 }}
      onClick={onPress}
      className={`p-4 rounded-xl border transition-all duration-200 ${
        onPress ? 'cursor-pointer' : ''
      }`}
      style={{ 
        background: colors.glassBackground,
        borderColor: colors.borderMedium,
        boxShadow: colors.shadowSm
      }}
    >
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-3 flex-1">
          <div 
            className="w-10 h-10 rounded-xl flex items-center justify-center"
            style={{ 
              background: danger ? 'rgba(239, 68, 68, 0.1)' : `${colors.accent}20`
            }}
          >
            {React.cloneElement(icon as React.ReactElement, {
              size: responsive.iconSize,
              style: { color: danger ? '#EF4444' : colors.accent }
            })}
          </div>
          
          <div className="flex-1">
            <h3 
              style={{ 
                color: danger ? '#EF4444' : colors.textPrimary,
                fontSize: responsive.bodySize 
              }}
              className="font-semibold"
            >
              {title}
            </h3>
            {subtitle && (
              <p 
                style={{ 
                  color: colors.textSecondary, 
                  fontSize: responsive.metaSize 
                }}
                className="mt-1"
              >
                {subtitle}
              </p>
            )}
          </div>
        </div>
        
        <div className="flex items-center space-x-2">
          {value && (
            <span 
              style={{ 
                color: colors.textSecondary, 
                fontSize: responsive.metaSize 
              }}
              className="font-medium"
            >
              {value}
            </span>
          )}
          
          {isSwitch && (
            <motion.button
              whileTap={{ scale: 0.9 }}
              onClick={(e) => {
                e.stopPropagation();
                onSwitchChange?.(!switchValue);
                hapticFeedback?.('light');
              }}
              className={`w-12 h-6 rounded-full p-1 transition-all duration-200 ${
                switchValue ? 'bg-purple-600' : ''
              }`}
              style={{ 
                background: switchValue ? undefined : colors.borderMedium
              }}
            >
              <motion.div
                animate={{ x: switchValue ? 24 : 0 }}
                transition={{ type: 'spring', stiffness: 500, damping: 30 }}
                className="w-4 h-4 bg-white rounded-full shadow"
              />
            </motion.button>
          )}
          
          {showArrow && onPress && !isSwitch && (
            <ArrowLeft 
              size={16} 
              style={{ 
                color: colors.textSecondary,
                transform: 'rotate(180deg)'
              }}
            />
          )}
        </div>
      </div>
    </motion.div>
  );

  const SectionHeader: React.FC<{ title: string }> = ({ title }) => (
    <h2 
      style={{ 
        color: colors.textPrimary, 
        fontSize: responsive.bodySize + 2 
      }}
      className="font-bold mb-4 px-1"
    >
      {title}
    </h2>
  );

  const ConfirmDialog: React.FC<{
    isOpen: boolean;
    onClose: () => void;
    onConfirm: () => void;
    title: string;
    message: string;
    confirmText: string;
    danger?: boolean;
  }> = ({ isOpen, onClose, onConfirm, title, message, confirmText, danger }) => (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="fixed inset-0 z-50 flex items-center justify-center p-4"
          style={{ background: 'rgba(0, 0, 0, 0.5)' }}
          onClick={onClose}
        >
          <motion.div
            initial={{ scale: 0.8, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0.8, opacity: 0 }}
            onClick={(e) => e.stopPropagation()}
            className="w-full max-w-sm rounded-3xl p-6 border"
            style={{ 
              background: colors.glassBackground,
              borderColor: colors.borderMedium,
              boxShadow: colors.shadowXl
            }}
          >
            <h3 
              style={{ 
                color: colors.textPrimary, 
                fontSize: responsive.titleSize 
              }}
              className="font-bold mb-3"
            >
              {title}
            </h3>
            
            <p 
              style={{ 
                color: colors.textSecondary, 
                fontSize: responsive.bodySize 
              }}
              className="mb-6 leading-relaxed"
            >
              {message}
            </p>
            
            <div className="flex space-x-3">
              <motion.button
                whileTap={{ scale: 0.95 }}
                onClick={onClose}
                className="flex-1 py-3 rounded-xl border font-semibold"
                style={{ 
                  background: colors.inputBackground,
                  borderColor: colors.borderMedium,
                  color: colors.textSecondary,
                  fontSize: responsive.bodySize
                }}
              >
                Cancel
              </motion.button>
              
              <motion.button
                whileTap={{ scale: 0.95 }}
                onClick={onConfirm}
                className={`flex-1 py-3 rounded-xl font-semibold text-white ${
                  danger ? 'bg-red-500' : 'bg-gradient-to-r from-purple-600 to-purple-500'
                }`}
                style={{ 
                  fontSize: responsive.bodySize,
                  boxShadow: danger ? colors.shadowLg : colors.shadowPurple
                }}
              >
                {confirmText}
              </motion.button>
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );

  return (
    <div className={`h-screen w-full overflow-hidden bg-gradient-to-br ${colors.background}`}>
      {/* Header */}
      <div 
        className="flex-shrink-0 pt-12 pb-4 border-b"
        style={{ 
          background: `${colors.glassBackground}99`,
          borderColor: colors.borderLight,
          padding: `48px ${responsive.padding}px 16px`
        }}
      >
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <motion.button
              whileTap={{ scale: 0.95 }}
              whileHover={{ scale: 1.05 }}
              onClick={handleBack}
              className="w-10 h-10 rounded-full flex items-center justify-center border"
              style={{ 
                background: colors.glassBackground,
                borderColor: colors.borderMedium
              }}
            >
              <ArrowLeft size={responsive.iconSize} style={{ color: colors.textPrimary }} />
            </motion.button>

            <h1 
              style={{ 
                color: colors.textPrimary, 
                fontSize: responsive.titleSize 
              }}
              className="font-bold"
            >
              Chat Settings
            </h1>
          </div>

          {displayChat.type === 'group' && (
            <motion.button
              whileTap={{ scale: 0.95 }}
              whileHover={{ scale: 1.05 }}
              onClick={() => setShowEditDialog(true)}
              className="w-10 h-10 rounded-full flex items-center justify-center border"
              style={{ 
                background: colors.glassBackground,
                borderColor: colors.borderMedium
              }}
            >
              <Edit3 size={responsive.iconSize} style={{ color: colors.textPrimary }} />
            </motion.button>
          )}
        </div>
      </div>

      {/* Content */}
      <div className="flex-1 overflow-y-auto scrollbar-hide">
        <div style={{ padding: responsive.padding }}>
          
          {/* Chat Header */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="rounded-3xl p-6 mb-6 border text-center"
            style={{ 
              background: colors.glassBackground,
              borderColor: colors.borderMedium,
              boxShadow: colors.shadowLg
            }}
          >
            <div className="relative inline-block mb-4">
              <ImageWithFallback
                src={displayChat.avatar}
                alt={displayChat.name}
                className="rounded-full object-cover mx-auto"
                style={{ 
                  width: responsive.avatarSize, 
                  height: responsive.avatarSize 
                }}
              />
              
              {displayChat.type === 'group' && (
                <div className="absolute -bottom-2 -right-2 w-8 h-8 bg-purple-600 rounded-full flex items-center justify-center">
                  <Users size={16} className="text-white" />
                </div>
              )}
              
              {displayChat.isOnline && displayChat.type === 'direct' && (
                <div 
                  className="absolute bottom-2 right-2 w-6 h-6 bg-green-400 rounded-full border-4"
                  style={{ borderColor: colors.glassBackground }}
                />
              )}
            </div>

            <h2 
              style={{ 
                color: colors.textPrimary, 
                fontSize: responsive.titleSize 
              }}
              className="font-bold mb-2"
            >
              {displayChat.name}
            </h2>

            {displayChat.description && (
              <p 
                style={{ 
                  color: colors.textSecondary, 
                  fontSize: responsive.bodySize 
                }}
                className="mb-4"
              >
                {displayChat.description}
              </p>
            )}

            <div className="flex justify-center space-x-6">
              <div className="text-center">
                <div 
                  style={{ 
                    color: colors.textPrimary, 
                    fontSize: responsive.bodySize + 2 
                  }}
                  className="font-bold"
                >
                  {displayChat.totalMessages?.toLocaleString() || '0'}
                </div>
                <div 
                  style={{ 
                    color: colors.textSecondary, 
                    fontSize: responsive.metaSize 
                  }}
                >
                  Messages
                </div>
              </div>

              <div className="text-center">
                <div 
                  style={{ 
                    color: colors.textPrimary, 
                    fontSize: responsive.bodySize + 2 
                  }}
                  className="font-bold"
                >
                  {displayChat.sharedMedia || '0'}
                </div>
                <div 
                  style={{ 
                    color: colors.textSecondary, 
                    fontSize: responsive.metaSize 
                  }}
                >
                  Media
                </div>
              </div>

              {displayChat.type === 'group' && (
                <div className="text-center">
                  <div 
                    style={{ 
                      color: colors.textPrimary, 
                      fontSize: responsive.bodySize + 2 
                    }}
                    className="font-bold"
                  >
                    {displayChat.participants?.length || '0'}
                  </div>
                  <div 
                    style={{ 
                      color: colors.textSecondary, 
                      fontSize: responsive.metaSize 
                    }}
                  >
                    Members
                  </div>
                </div>
              )}
            </div>
          </motion.div>

          {/* Participants (for group chats) */}
          {displayChat.type === 'group' && displayChat.participants && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.1 }}
              className="mb-6"
            >
              <SectionHeader title="Participants" />
              
              <div className="space-y-3">
                {displayChat.participants.map((participant, index) => (
                  <motion.div
                    key={participant.id}
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: index * 0.1 }}
                    className="p-3 rounded-xl border"
                    style={{ 
                      background: colors.glassBackground,
                      borderColor: colors.borderMedium
                    }}
                  >
                    <div className="flex items-center space-x-3">
                      <div className="relative">
                        <img
                          src={participant.avatar}
                          alt={participant.name}
                          className="w-12 h-12 rounded-full object-cover"
                        />
                        {participant.isOnline && (
                          <div className="absolute bottom-0 right-0 w-3 h-3 bg-green-400 rounded-full border-2 border-white" />
                        )}
                      </div>
                      
                      <div className="flex-1">
                        <div className="flex items-center space-x-2">
                          <h4 
                            style={{ 
                              color: colors.textPrimary, 
                              fontSize: responsive.bodySize 
                            }}
                            className="font-semibold"
                          >
                            {participant.name}
                          </h4>
                          {participant.role === 'admin' && (
                            <Crown size={14} className="text-yellow-500" />
                          )}
                        </div>
                        
                        <p 
                          style={{ 
                            color: colors.textSecondary, 
                            fontSize: responsive.metaSize 
                          }}
                        >
                          {participant.role === 'admin' ? 'Admin' : 'Member'}
                        </p>
                      </div>

                      {participant.id !== '2' && (
                        <motion.button
                          whileTap={{ scale: 0.95 }}
                          className="p-2 rounded-lg border"
                          style={{ 
                            background: colors.inputBackground,
                            borderColor: colors.borderLight
                          }}
                        >
                          <MoreVertical size={16} style={{ color: colors.textSecondary }} />
                        </motion.button>
                      )}
                    </div>
                  </motion.div>
                ))}

                <motion.button
                  whileTap={{ scale: 0.98 }}
                  className="w-full p-4 rounded-xl border-2 border-dashed flex items-center justify-center space-x-2"
                  style={{ 
                    borderColor: colors.accent,
                    background: `${colors.accent}10`
                  }}
                >
                  <UserPlus size={responsive.iconSize} style={{ color: colors.accent }} />
                  <span 
                    style={{ 
                      color: colors.accent, 
                      fontSize: responsive.bodySize 
                    }}
                    className="font-semibold"
                  >
                    Add Member
                  </span>
                </motion.button>
              </div>
            </motion.div>
          )}

          {/* Notifications */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 }}
            className="mb-6"
          >
            <SectionHeader title="Notifications" />
            
            <div className="space-y-3">
              <SettingItem
                icon={<Bell />}
                title="Notifications"
                subtitle="Receive notifications for new messages"
                isSwitch
                switchValue={isNotificationsEnabled}
                onSwitchChange={setIsNotificationsEnabled}
                showArrow={false}
              />
              
              <SettingItem
                icon={<Volume2 />}
                title="Sound"
                subtitle="Play sound for notifications"
                isSwitch
                switchValue={isSoundEnabled}
                onSwitchChange={setIsSoundEnabled}
                showArrow={false}
              />
              
              <SettingItem
                icon={isMuted ? <BellOff /> : <Bell />}
                title={isMuted ? "Unmute" : "Mute"}
                subtitle={isMuted ? "Notifications are muted" : "Mute this conversation"}
                onPress={handleMute}
              />
            </div>
          </motion.div>

          {/* Privacy & Security */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.3 }}
            className="mb-6"
          >
            <SectionHeader title="Privacy & Security" />
            
            <div className="space-y-3">
              <SettingItem
                icon={<Shield />}
                title="Encryption"
                subtitle="End-to-end encrypted"
                value="Active"
                showArrow={false}
              />
              
              <SettingItem
                icon={<Eye />}
                title="Read Receipts"
                subtitle="Show when you've read messages"
                isSwitch
                switchValue={true}
                onSwitchChange={() => {}}
                showArrow={false}
              />
              
              <SettingItem
                icon={<Clock />}
                title="Disappearing Messages"
                subtitle="Messages disappear after 24 hours"
                onPress={() => {}}
              />
            </div>
          </motion.div>

          {/* Media & Files */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4 }}
            className="mb-6"
          >
            <SectionHeader title="Media & Files" />
            
            <div className="space-y-3">
              <SettingItem
                icon={<Camera />}
                title="Shared Media"
                subtitle={`${displayChat.sharedMedia || 0} items`}
                onPress={() => {}}
              />
              
              <SettingItem
                icon={<Download />}
                title="Auto-Download"
                subtitle="Download media automatically"
                onPress={() => {}}
              />
              
              <SettingItem
                icon={<Archive />}
                title="Export Chat"
                subtitle="Download chat history"
                onPress={() => {}}
              />
            </div>
          </motion.div>

          {/* Customization */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.5 }}
            className="mb-6"
          >
            <SectionHeader title="Customization" />
            
            <div className="space-y-3">
              <SettingItem
                icon={<Palette />}
                title="Chat Theme"
                subtitle="Customize chat appearance"
                value="Default"
                onPress={() => {}}
              />
              
              <SettingItem
                icon={<MessageSquare />}
                title="Chat Wallpaper"
                subtitle="Set custom background"
                onPress={() => {}}
              />
            </div>
          </motion.div>

          {/* Actions */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.6 }}
            className="mb-6"
          >
            <SectionHeader title="Actions" />
            
            <div className="space-y-3">
              <SettingItem
                icon={<Star />}
                title="Star Chat"
                subtitle="Add to starred chats"
                onPress={() => {}}
              />
              
              <SettingItem
                icon={<Share />}
                title="Share Contact"
                subtitle="Share this contact with others"
                onPress={() => {}}
              />
              
              <SettingItem
                icon={<Search />}
                title="Search Messages"
                subtitle="Find specific messages"
                onPress={() => {}}
              />
            </div>
          </motion.div>

          {/* Danger Zone */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.7 }}
            className="mb-6"
          >
            <SectionHeader title="Danger Zone" />
            
            <div className="space-y-3">
              {displayChat.type === 'direct' && (
                <SettingItem
                  icon={<UserMinus />}
                  title={isBlocked ? "Unblock User" : "Block User"}
                  subtitle={isBlocked ? "Unblock this user" : "Block this user"}
                  onPress={() => setShowBlockDialog(true)}
                  danger
                />
              )}
              
              <SettingItem
                icon={<Trash2 />}
                title="Delete Chat"
                subtitle="Delete this conversation permanently"
                onPress={() => setShowDeleteDialog(true)}
                danger
              />
            </div>
          </motion.div>

          {/* Chat Info */}
          {displayChat.createdAt && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.8 }}
              className="rounded-2xl p-4 border mb-20"
              style={{ 
                background: colors.glassBackground,
                borderColor: colors.borderMedium
              }}
            >
              <p 
                style={{ 
                  color: colors.textSecondary, 
                  fontSize: responsive.metaSize 
                }}
                className="text-center"
              >
                {displayChat.type === 'group' ? 'Group created' : 'Chat started'} on {formatDate(displayChat.createdAt)}
              </p>
            </motion.div>
          )}
        </div>
      </div>

      {/* Dialogs */}
      <ConfirmDialog
        isOpen={showBlockDialog}
        onClose={() => setShowBlockDialog(false)}
        onConfirm={handleBlock}
        title={isBlocked ? "Unblock User" : "Block User"}
        message={isBlocked 
          ? "Are you sure you want to unblock this user? They will be able to send you messages again."
          : "Are you sure you want to block this user? They won't be able to send you messages."
        }
        confirmText={isBlocked ? "Unblock" : "Block"}
        danger={!isBlocked}
      />

      <ConfirmDialog
        isOpen={showDeleteDialog}
        onClose={() => setShowDeleteDialog(false)}
        onConfirm={handleDelete}
        title="Delete Chat"
        message="Are you sure you want to delete this chat? This action cannot be undone and all messages will be permanently deleted."
        confirmText="Delete"
        danger
      />

      {/* Edit Dialog */}
      <AnimatePresence>
        {showEditDialog && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 z-50 flex items-center justify-center p-4"
            style={{ background: 'rgba(0, 0, 0, 0.5)' }}
            onClick={() => setShowEditDialog(false)}
          >
            <motion.div
              initial={{ scale: 0.8, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.8, opacity: 0 }}
              onClick={(e) => e.stopPropagation()}
              className="w-full max-w-md rounded-3xl p-6 border"
              style={{ 
                background: colors.glassBackground,
                borderColor: colors.borderMedium,
                boxShadow: colors.shadowXl
              }}
            >
              <h3 
                style={{ 
                  color: colors.textPrimary, 
                  fontSize: responsive.titleSize 
                }}
                className="font-bold mb-6"
              >
                Edit {displayChat.type === 'group' ? 'Group' : 'Chat'}
              </h3>
              
              <div className="space-y-4 mb-6">
                <div>
                  <label 
                    style={{ 
                      color: colors.textSecondary, 
                      fontSize: responsive.metaSize 
                    }}
                    className="block mb-2 font-medium"
                  >
                    Name
                  </label>
                  <input
                    value={editedName}
                    onChange={(e) => setEditedName(e.target.value)}
                    className="w-full p-3 rounded-xl border outline-none"
                    style={{ 
                      background: colors.inputBackground,
                      borderColor: colors.borderMedium,
                      color: colors.textPrimary,
                      fontSize: responsive.bodySize
                    }}
                  />
                </div>

                <div>
                  <label 
                    style={{ 
                      color: colors.textSecondary, 
                      fontSize: responsive.metaSize 
                    }}
                    className="block mb-2 font-medium"
                  >
                    Description
                  </label>
                  <textarea
                    value={editedDescription}
                    onChange={(e) => setEditedDescription(e.target.value)}
                    rows={3}
                    className="w-full p-3 rounded-xl border outline-none resize-none"
                    style={{ 
                      background: colors.inputBackground,
                      borderColor: colors.borderMedium,
                      color: colors.textPrimary,
                      fontSize: responsive.bodySize
                    }}
                  />
                </div>
              </div>
              
              <div className="flex space-x-3">
                <motion.button
                  whileTap={{ scale: 0.95 }}
                  onClick={() => setShowEditDialog(false)}
                  className="flex-1 py-3 rounded-xl border font-semibold"
                  style={{ 
                    background: colors.inputBackground,
                    borderColor: colors.borderMedium,
                    color: colors.textSecondary,
                    fontSize: responsive.bodySize
                  }}
                >
                  Cancel
                </motion.button>
                
                <motion.button
                  whileTap={{ scale: 0.95 }}
                  onClick={handleSaveEdit}
                  className="flex-1 py-3 rounded-xl font-semibold text-white bg-gradient-to-r from-purple-600 to-purple-500"
                  style={{ 
                    fontSize: responsive.bodySize,
                    boxShadow: colors.shadowPurple
                  }}
                >
                  Save
                </motion.button>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};

export default ChatSettingsScreen;