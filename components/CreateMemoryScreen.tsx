import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { ArrowLeft, Type, Camera, Video, Mic, Upload, Sparkles, RotateCcw, Move3D, ZoomIn, Check, Globe, Lock, Users, Eye, UserPlus, X, FileText } from 'lucide-react';
import { ScrollArea } from './ui/scroll-area';
import { Switch } from './ui/switch';
import { useTheme } from './ThemeContext';

interface CreateMemoryScreenProps {
  onNavigate: (screen: string, isSubScreen?: boolean) => void;
}

const CreateMemoryScreen: React.FC<CreateMemoryScreenProps> = ({ onNavigate }) => {
  const { colors } = useTheme();
  const [currentStep, setCurrentStep] = useState(1);
  const [selectedType, setSelectedType] = useState<string | null>(null);
  const [selectedModel, setSelectedModel] = useState<string | null>(null);
  const [isPublic, setIsPublic] = useState(true);
  const [selectedViewers, setSelectedViewers] = useState<string[]>([]);
  const [isUploading, setIsUploading] = useState(false);
  const [memoryName, setMemoryName] = useState('');
  const [memoryDescription, setMemoryDescription] = useState('');
  const [memoryContent, setMemoryContent] = useState('');

  const memoryTypes = [
    {
      id: 'text',
      title: 'Text Note',
      subtitle: 'Share thoughts & stories',
      icon: Type,
      gradient: 'from-purple-500 to-violet-600',
      description: 'Perfect for quotes, thoughts, or quick notes'
    },
    {
      id: 'photo',
      title: 'Photo Memory',
      subtitle: 'Capture the moment',
      icon: Camera,
      gradient: 'from-blue-500 to-cyan-600',
      description: 'Share beautiful moments visually'
    },
    {
      id: 'video',
      title: 'Video Story',
      subtitle: 'Moving memories',
      icon: Video,
      gradient: 'from-red-500 to-pink-600',
      description: 'Create dynamic video experiences'
    },
    {
      id: 'audio',
      title: 'Voice Note',
      subtitle: 'Speak your mind',
      icon: Mic,
      gradient: 'from-green-500 to-emerald-600',
      description: 'Record audio messages and sounds'
    }
  ];

  const arModels = [
    {
      id: 'sphere',
      name: 'Floating Sphere',
      preview: '🔮',
      description: 'Classic floating orb'
    },
    {
      id: 'crystal',
      name: 'Crystal Fragment',
      preview: '💎',
      description: 'Geometric crystal shape'
    },
    {
      id: 'hologram',
      name: 'Holographic Panel',
      preview: '📱',
      description: 'Futuristic display panel'
    },
    {
      id: 'particle',
      name: 'Particle Cloud',
      preview: '✨',
      description: 'Animated particle system'
    },
    {
      id: 'portal',
      name: 'Portal Ring',
      preview: '⭕',
      description: 'Dimensional gateway'
    },
    {
      id: 'flame',
      name: 'Energy Flame',
      preview: '🔥',
      description: 'Animated energy effect'
    }
  ];

  const availableViewers = [
    { id: '1', name: 'Sarah Chen', avatar: 'S', status: 'online' },
    { id: '2', name: 'Mike Johnson', avatar: 'M', status: 'offline' },
    { id: '3', name: 'Alex Rivera', avatar: 'A', status: 'online' },
    { id: '4', name: 'Emma Watson', avatar: 'E', status: 'offline' },
    { id: '5', name: 'David Kim', avatar: 'D', status: 'online' }
  ];

  const canProceedStep2 = () => {
    return memoryName.trim().length >= 3 && 
           memoryDescription.trim().length >= 10 && 
           (selectedType === 'text' ? memoryContent.trim().length > 0 : true);
  };

  const handleNext = () => {
    if (currentStep === 1 && selectedType) {
      setCurrentStep(2);
    } else if (currentStep === 2 && canProceedStep2()) {
      setCurrentStep(3);
    } else if (currentStep === 3 && selectedModel) {
      setCurrentStep(4);
    } else if (currentStep === 4) {
      setCurrentStep(5); // Go to preview
    }
  };

  const handleBack = () => {
    if (currentStep > 1) {
      setCurrentStep(currentStep - 1);
    } else {
      onNavigate('home');
    }
  };

  const handlePublish = async () => {
    setIsUploading(true);
    await new Promise(resolve => setTimeout(resolve, 2000));
    setIsUploading(false);
    onNavigate('home');
  };

  const toggleViewer = (viewerId: string) => {
    setSelectedViewers(prev => 
      prev.includes(viewerId) 
        ? prev.filter(id => id !== viewerId)
        : [...prev, viewerId]
    );
  };

  const renderStepContent = () => {
    switch (currentStep) {
      case 1:
        return (
          <div className="space-y-6 p-6 pb-32">
            <div className="text-center mb-8">
              <h2 className={`text-2xl font-bold mb-2 ${colors.textPrimary}`}>Choose Memory Type</h2>
              <p className={colors.textSecondary}>What kind of memory would you like to create?</p>
            </div>

            <div className="grid grid-cols-2 gap-4">
              {memoryTypes.map((type) => {
                const Icon = type.icon;
                const isSelected = selectedType === type.id;
                
                return (
                  <motion.button
                    key={type.id}
                    whileTap={{ scale: 0.95 }}
                    onClick={() => setSelectedType(type.id)}
                    className={`glass-card rounded-[24px] p-6 backdrop-blur-xl transition-all duration-300 border ${
                      isSelected ? 'border-purple-500/50' : colors.glassBorder
                    }`}
                    style={isSelected ? { 
                      boxShadow: '0 8px 32px rgba(107, 31, 179, 0.3)' 
                    } : {}}
                  >
                    <div className={`w-12 h-12 bg-gradient-to-r ${type.gradient} rounded-full flex items-center justify-center mb-4 mx-auto`}>
                      <Icon size={24} className="text-white" />
                    </div>
                    <h3 className={`font-semibold mb-1 ${colors.textPrimary}`}>{type.title}</h3>
                    <p className={`text-sm mb-2 ${colors.textSecondary}`}>{type.subtitle}</p>
                    <p className={`text-xs ${colors.textSecondary}`}>{type.description}</p>
                  </motion.button>
                );
              })}
            </div>
          </div>
        );

      case 2:
        return (
          <div className="space-y-6 p-6 pb-32">
            <div className="text-center mb-8">
              <h2 className={`text-2xl font-bold mb-2 ${colors.textPrimary}`}>Create Your Memory</h2>
              <p className={colors.textSecondary}>Add details and content for your {selectedType} memory</p>
            </div>

            {/* Memory Name */}
            <motion.div
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.1, duration: 0.4 }}
              className={`glass-card rounded-[20px] p-4 backdrop-blur-xl border ${colors.glassBorder}`}
            >
              <div className="flex items-center space-x-3 mb-3">
                <FileText size={18} className={colors.accent} />
                <label className={`font-medium ${colors.textPrimary}`}>Memory Name</label>
                <span className={`text-xs ${colors.textSecondary}`}>({memoryName.length}/50)</span>
              </div>
              <input
                type="text"
                value={memoryName}
                onChange={(e) => setMemoryName(e.target.value.slice(0, 50))}
                placeholder="Give your memory a catchy name..."
                className={`w-full ${colors.inputBackground} border ${colors.glassBorder} rounded-[16px] px-4 py-3 ${colors.textPrimary} placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all duration-200`}
                maxLength={50}
              />
              {memoryName.length > 0 && memoryName.length < 3 && (
                <p className="text-orange-400 text-xs mt-2">Name must be at least 3 characters long</p>
              )}
            </motion.div>

            {/* Memory Description */}
            <motion.div
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.2, duration: 0.4 }}
              className={`glass-card rounded-[20px] p-4 backdrop-blur-xl border ${colors.glassBorder}`}
            >
              <div className="flex items-center space-x-3 mb-3">
                <Type size={18} className={colors.accent} />
                <label className={`font-medium ${colors.textPrimary}`}>Description</label>
                <span className={`text-xs ${colors.textSecondary}`}>({memoryDescription.length}/200)</span>
              </div>
              <textarea
                value={memoryDescription}
                onChange={(e) => setMemoryDescription(e.target.value.slice(0, 200))}
                placeholder="Describe your memory in detail (minimum 10 characters)..."
                className={`w-full h-24 ${colors.inputBackground} border ${colors.glassBorder} rounded-[16px] px-4 py-3 ${colors.textPrimary} placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all duration-200 resize-none`}
                maxLength={200}
              />
              {memoryDescription.length > 0 && memoryDescription.length < 10 && (
                <p className="text-orange-400 text-xs mt-2">Description must be at least 10 characters long</p>
              )}
              {memoryDescription.length >= 10 && (
                <p className="text-green-400 text-xs mt-2">✓ Description looks good!</p>
              )}
            </motion.div>

            {/* Content Section */}
            <motion.div
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.3, duration: 0.4 }}
              className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.glassBorder}`}
            >
              <div className="flex items-center space-x-3 mb-4">
                {React.createElement(memoryTypes.find(t => t.id === selectedType)?.icon || Type, { 
                  size: 20, 
                  className: colors.accent
                })}
                <h3 className={`font-semibold ${colors.textPrimary}`}>Add {selectedType} content</h3>
              </div>

              {selectedType === 'text' ? (
                <textarea
                  value={memoryContent}
                  onChange={(e) => setMemoryContent(e.target.value)}
                  placeholder="Write your memory content here..."
                  className={`w-full h-32 ${colors.inputBackground} border ${colors.glassBorder} rounded-[16px] p-4 ${colors.textPrimary} placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-purple-500 resize-none`}
                />
              ) : (
                <div className="text-center">
                  <motion.div
                    whileHover={{ scale: 1.05 }}
                    whileTap={{ scale: 0.95 }}
                    className="w-24 h-24 bg-gradient-to-r from-purple-500 to-blue-500 rounded-full flex items-center justify-center mx-auto mb-4 cursor-pointer"
                    style={{ 
                      boxShadow: '0 8px 32px rgba(107, 31, 179, 0.4)' 
                    }}
                  >
                    <Upload size={32} className="text-white" />
                  </motion.div>
                  
                  <h4 className={`font-semibold mb-2 ${colors.textPrimary}`}>Upload {selectedType}</h4>
                  <p className={`text-sm mb-4 ${colors.textSecondary}`}>
                    {selectedType === 'photo' && "Select a photo from your gallery"}
                    {selectedType === 'video' && "Choose a video file to upload"}
                    {selectedType === 'audio' && "Record audio or upload an audio file"}
                  </p>

                  <motion.button
                    whileTap={{ scale: 0.95 }}
                    className="bg-gradient-to-r from-purple-600 to-purple-500 px-6 py-3 rounded-[16px] text-white font-semibold"
                    style={{ 
                      boxShadow: '0 4px 16px rgba(107, 31, 179, 0.4)' 
                    }}
                  >
                    Upload {selectedType}
                  </motion.button>
                </div>
              )}
            </motion.div>

            {/* Privacy Settings */}
            <motion.div
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.4, duration: 0.4 }}
              className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.glassBorder}`}
            >
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center space-x-3">
                  {isPublic ? <Globe size={20} className="text-green-400" /> : <Lock size={20} className="text-orange-400" />}
                  <div>
                    <h3 className={`font-semibold ${colors.textPrimary}`}>Privacy Settings</h3>
                    <p className={`text-sm ${colors.textSecondary}`}>
                      {isPublic ? 'Everyone can see this memory' : 'Only selected people can see this memory'}
                    </p>
                  </div>
                </div>
                <Switch
                  checked={isPublic}
                  onCheckedChange={setIsPublic}
                  className="data-[state=checked]:bg-green-500"
                />
              </div>

              {!isPublic && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: 'auto' }}
                  exit={{ opacity: 0, height: 0 }}
                  transition={{ duration: 0.3 }}
                >
                  <div className={`border-t pt-4 ${colors.glassBorder}`}>
                    <div className="flex items-center space-x-2 mb-3">
                      <Eye size={16} className={colors.accent} />
                      <span className={`font-medium ${colors.textPrimary}`}>Select Viewers</span>
                      <span className={`text-sm ${colors.textSecondary}`}>({selectedViewers.length})</span>
                    </div>
                    
                    <div className="space-y-2 max-h-32 overflow-y-auto">
                      {availableViewers.map((viewer) => (
                        <motion.button
                          key={viewer.id}
                          whileTap={{ scale: 0.98 }}
                          onClick={() => toggleViewer(viewer.id)}
                          className={`w-full flex items-center space-x-3 p-3 rounded-[12px] transition-all duration-300 ${
                            selectedViewers.includes(viewer.id) 
                              ? 'bg-purple-600/30 ring-1 ring-purple-500' 
                              : 'bg-white/5 hover:bg-white/10'
                          }`}
                        >
                          <div className="relative">
                            <div className="w-8 h-8 bg-gradient-to-r from-purple-500 to-blue-500 rounded-full flex items-center justify-center">
                              <span className="text-white text-sm font-semibold">{viewer.avatar}</span>
                            </div>
                            {viewer.status === 'online' && (
                              <div className="absolute -bottom-1 -right-1 w-3 h-3 bg-green-400 rounded-full border border-white"></div>
                            )}
                          </div>
                          <span className={`flex-1 text-left ${colors.textPrimary}`}>{viewer.name}</span>
                          {selectedViewers.includes(viewer.id) && (
                            <Check size={16} className="text-green-400" />
                          )}
                        </motion.button>
                      ))}
                    </div>
                  </div>
                </motion.div>
              )}
            </motion.div>
          </div>
        );

      case 3:
        return (
          <div className="space-y-6 p-6 pb-32">
            <div className="text-center mb-8">
              <h2 className={`text-2xl font-bold mb-2 ${colors.textPrimary}`}>Choose AR Model</h2>
              <p className={colors.textSecondary}>How should your memory appear in AR?</p>
            </div>

            <div className="grid grid-cols-2 gap-4">
              {arModels.map((model) => {
                const isSelected = selectedModel === model.id;
                
                return (
                  <motion.button
                    key={model.id}
                    whileTap={{ scale: 0.95 }}
                    onClick={() => setSelectedModel(model.id)}
                    className={`glass-card rounded-[20px] p-4 backdrop-blur-xl transition-all duration-300 border ${
                      isSelected ? 'border-purple-500/50' : colors.glassBorder
                    }`}
                    style={isSelected ? { 
                      boxShadow: '0 8px 32px rgba(107, 31, 179, 0.3)' 
                    } : {}}
                  >
                    <div className="text-4xl mb-3 text-center">{model.preview}</div>
                    <h3 className={`font-semibold text-sm mb-1 ${colors.textPrimary}`}>{model.name}</h3>
                    <p className={`text-xs ${colors.textSecondary}`}>{model.description}</p>
                  </motion.button>
                );
              })}
            </div>
          </div>
        );

      case 4:
        return (
          <div className="space-y-6 p-6 pb-32">
            <div className="text-center mb-8">
              <h2 className={`text-2xl font-bold mb-2 ${colors.textPrimary}`}>Place in AR</h2>
              <p className={colors.textSecondary}>Position your memory in the real world</p>
            </div>

            {/* AR Placement Interface */}
            <div className={`relative h-64 glass-card rounded-[24px] overflow-hidden backdrop-blur-xl bg-black/50 border ${colors.glassBorder}`}>
              <div className="absolute inset-0 flex items-center justify-center">
                <motion.div
                  animate={{
                    y: [0, -10, 0],
                    rotateY: [0, 180, 360],
                  }}
                  transition={{
                    duration: 3,
                    repeat: Infinity,
                    ease: "easeInOut"
                  }}
                  className="text-6xl"
                >
                  {arModels.find(m => m.id === selectedModel)?.preview}
                </motion.div>
              </div>

              {/* AR Controls */}
              <div className="absolute bottom-4 left-4 right-4 flex justify-center space-x-4">
                <motion.button
                  whileTap={{ scale: 0.95 }}
                  className={`glass-card w-12 h-12 rounded-full flex items-center justify-center backdrop-blur-md border ${colors.glassBorder}`}
                >
                  <Move3D size={20} className={colors.textPrimary} />
                </motion.button>
                <motion.button
                  whileTap={{ scale: 0.95 }}
                  className={`glass-card w-12 h-12 rounded-full flex items-center justify-center backdrop-blur-md border ${colors.glassBorder}`}
                >
                  <RotateCcw size={20} className={colors.textPrimary} />
                </motion.button>
                <motion.button
                  whileTap={{ scale: 0.95 }}
                  className={`glass-card w-12 h-12 rounded-full flex items-center justify-center backdrop-blur-md border ${colors.glassBorder}`}
                >
                  <ZoomIn size={20} className={colors.textPrimary} />
                </motion.button>
              </div>
            </div>

            <div className={`glass-card rounded-[20px] p-4 backdrop-blur-xl border ${colors.glassBorder}`}>
              <div className="flex items-center justify-between mb-3">
                <span className={`font-medium ${colors.textPrimary}`}>Placement Settings</span>
                <Sparkles size={16} className={colors.accent} />
              </div>
              <div className="space-y-3">
                <div className="flex items-center justify-between">
                  <span className={`text-sm ${colors.textSecondary}`}>Height</span>
                  <span className={`text-sm ${colors.textPrimary}`}>1.5m</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className={`text-sm ${colors.textSecondary}`}>Visibility</span>
                  <span className={`text-sm ${colors.textPrimary}`}>{isPublic ? 'Public' : 'Private'}</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className={`text-sm ${colors.textSecondary}`}>Duration</span>
                  <span className={`text-sm ${colors.textPrimary}`}>24 hours</span>
                </div>
              </div>
            </div>
          </div>
        );

      case 5:
        return (
          <div className="space-y-6 p-6 pb-32">
            <div className="text-center mb-8">
              <h2 className={`text-2xl font-bold mb-2 ${colors.textPrimary}`}>Preview Your Memory</h2>
              <p className={colors.textSecondary}>Review how your memory will appear before publishing</p>
            </div>

            {/* Memory Preview */}
            <div className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.glassBorder}`}
                 style={{ 
                   boxShadow: '0 12px 40px rgba(107, 31, 179, 0.3)' 
                 }}>
              <div className="flex items-center space-x-4 mb-6">
                <div className="w-12 h-12 bg-gradient-to-r from-purple-500 to-blue-500 rounded-full flex items-center justify-center">
                  <span className="text-white font-bold">A</span>
                </div>
                <div>
                  <h3 className={`font-semibold ${colors.textPrimary}`}>{memoryName || 'Untitled Memory'}</h3>
                  <p className={`text-sm ${colors.textSecondary}`}>Creating memory • Just now</p>
                </div>
              </div>

              {/* Description Preview */}
              <div className={`glass-card rounded-[20px] p-4 backdrop-blur-md mb-4 border ${colors.glassBorder}`}>
                <p className={`text-sm leading-relaxed ${colors.textPrimary}`}>
                  {memoryDescription || 'No description provided'}
                </p>
              </div>

              {/* Content Preview */}
              <div className={`glass-card rounded-[20px] p-4 backdrop-blur-md mb-4 border ${colors.glassBorder}`}>
                <div className="flex items-center space-x-3 mb-3">
                  <div className={`w-8 h-8 bg-gradient-to-r ${memoryTypes.find(t => t.id === selectedType)?.gradient} rounded-full flex items-center justify-center`}>
                    {React.createElement(memoryTypes.find(t => t.id === selectedType)?.icon || Type, { size: 16, className: "text-white" })}
                  </div>
                  <div>
                    <p className={`font-medium capitalize ${colors.textPrimary}`}>{selectedType} content</p>
                    <p className={`text-xs ${colors.textSecondary}`}>Ready to publish</p>
                  </div>
                </div>
                
                {selectedType === 'text' && memoryContent && (
                  <p className={`text-sm leading-relaxed ${colors.textPrimary}`}>
                    {memoryContent}
                  </p>
                )}
              </div>

              {/* AR Model Preview */}
              <div className={`glass-card rounded-[20px] p-4 backdrop-blur-md mb-4 border ${colors.glassBorder}`}>
                <div className="flex items-center space-x-3 mb-3">
                  <div className="text-2xl">{arModels.find(m => m.id === selectedModel)?.preview}</div>
                  <div>
                    <p className={`font-medium ${colors.textPrimary}`}>{arModels.find(m => m.id === selectedModel)?.name}</p>
                    <p className={`text-xs ${colors.textSecondary}`}>AR Model</p>
                  </div>
                </div>
              </div>

              {/* Privacy Info */}
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-2">
                  {isPublic ? <Globe size={16} className="text-green-400" /> : <Lock size={16} className="text-orange-400" />}
                  <span className={`text-sm ${colors.textSecondary}`}>
                    {isPublic ? 'Public memory' : `Shared with ${selectedViewers.length} people`}
                  </span>
                </div>
                <div className={`text-xs ${colors.textSecondary}`}>
                  Height: 1.5m • Duration: 24h
                </div>
              </div>
            </div>

            {/* Action Buttons */}
            <div className="flex space-x-3">
              <motion.button
                whileTap={{ scale: 0.98 }}
                onClick={() => setCurrentStep(4)}
                className={`flex-1 glass-card py-3 rounded-[16px] font-medium backdrop-blur-xl border ${colors.glassBorder} hover:border-white/40 transition-all duration-200 ${colors.textPrimary}`}
              >
                Edit
              </motion.button>
              <motion.button
                whileTap={{ scale: 0.98 }}
                onClick={handlePublish}
                disabled={isUploading}
                className="flex-2 bg-gradient-to-r from-purple-600 to-purple-500 py-3 px-6 rounded-[16px] text-white font-semibold flex items-center justify-center space-x-2"
                style={{ 
                  boxShadow: '0 8px 32px rgba(107, 31, 179, 0.4)' 
                }}
              >
                {isUploading ? (
                  <motion.div
                    animate={{ rotate: 360 }}
                    transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
                    className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full"
                  />
                ) : (
                  <>
                    <Sparkles size={18} />
                    <span>Publish Memory</span>
                  </>
                )}
              </motion.button>
            </div>
          </div>
        );

      default:
        return null;
    }
  };

  return (
    <div className={`h-full w-full flex flex-col bg-gradient-to-br ${colors.background}`}>
      {/* Header - Fixed */}
      <div className="flex-shrink-0 pt-12 px-6 pb-4 bg-gradient-to-b from-black/30 via-black/10 to-transparent">
        <motion.div
          initial={{ opacity: 0, y: -30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4 }}
        >
          <div className="flex items-center justify-between mb-6">
            <motion.button
              whileTap={{ scale: 0.95 }}
              onClick={handleBack}
              className={`w-10 h-10 glass-card rounded-full flex items-center justify-center backdrop-blur-md border ${colors.glassBorder} hover:border-white/40 transition-all duration-200`}
            >
              <ArrowLeft size={20} className={colors.textPrimary} />
            </motion.button>

            <div className="text-center">
              <h1 className={`text-xl font-bold ${colors.textPrimary}`}>
                {currentStep === 5 ? 'Preview Memory' : 'Create Memory'}
              </h1>
              <p className={`text-sm ${colors.textSecondary}`}>Step {currentStep} of 5</p>
            </div>

            <div className="w-10 h-10"></div>
          </div>

          {/* Progress Bar */}
          <div className={`glass-card rounded-full h-2 backdrop-blur-md overflow-hidden border ${colors.glassBorder}`}>
            <motion.div
              className="h-full bg-gradient-to-r from-purple-500 to-blue-500"
              style={{ 
                boxShadow: '0 2px 8px rgba(107, 31, 179, 0.4)' 
              }}
              initial={{ width: '20%' }}
              animate={{ width: `${currentStep * 20}%` }}
              transition={{ duration: 0.5, ease: "easeOut" }}
            />
          </div>
        </motion.div>
      </div>

      {/* Content - Scrollable */}
      <div className="flex-1 min-h-0 overflow-y-auto">
        <AnimatePresence mode="wait">
          <motion.div
            key={currentStep}
            initial={{ opacity: 0, x: 30 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -30 }}
            transition={{ duration: 0.3 }}
          >
            {renderStepContent()}
          </motion.div>
        </AnimatePresence>
      </div>

      {/* Bottom Action Button - Fixed */}
      <div className="flex-shrink-0 p-6 pb-8">
        <motion.button
          whileTap={{ scale: 0.98 }}
          onClick={handleNext}
          disabled={
            (currentStep === 1 && !selectedType) ||
            (currentStep === 2 && !canProceedStep2()) ||
            (currentStep === 3 && !selectedModel) ||
            currentStep === 5
          }
          className={`w-full py-4 rounded-[18px] font-semibold transition-all duration-200 ${
            (currentStep === 1 && !selectedType) ||
            (currentStep === 2 && !canProceedStep2()) ||
            (currentStep === 3 && !selectedModel) ||
            currentStep === 5
              ? `glass-card border ${colors.glassBorder} ${colors.textSecondary}`
              : 'bg-gradient-to-r from-purple-600 to-purple-500 text-white'
          }`}
          style={
            !((currentStep === 1 && !selectedType) ||
              (currentStep === 2 && !canProceedStep2()) ||
              (currentStep === 3 && !selectedModel) ||
              currentStep === 5)
              ? { boxShadow: '0 8px 32px rgba(107, 31, 179, 0.4)' }
              : {}
          }
        >
          {currentStep === 4 ? 'Preview Memory' : currentStep === 5 ? 'Ready to Publish' : 'Continue'}
        </motion.button>
      </div>
    </div>
  );
};

export default CreateMemoryScreen;