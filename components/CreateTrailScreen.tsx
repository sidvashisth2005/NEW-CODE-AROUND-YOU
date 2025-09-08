import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { ArrowLeft, Route, FileText, MapPin, Users, Globe, Lock, Eye, Check, Camera, Sparkles, Plus, X } from 'lucide-react';
import { ScrollArea } from './ui/scroll-area';
import { Switch } from './ui/switch';
import { Textarea } from './ui/textarea';
import { useTheme } from './ThemeContext';

interface CreateTrailScreenProps {
  onNavigate: (screen: string, isSubScreen?: boolean) => void;
}

const CreateTrailScreen: React.FC<CreateTrailScreenProps> = ({ onNavigate }) => {
  const { colors } = useTheme();
  const [currentStep, setCurrentStep] = useState(1);
  const [isPublic, setIsPublic] = useState(true);
  const [selectedViewers, setSelectedViewers] = useState<string[]>([]);
  const [selectedMemories, setSelectedMemories] = useState<number[]>([]);
  const [isPublishing, setIsPublishing] = useState(false);

  // Form data
  const [trailData, setTrailData] = useState({
    title: '',
    description: '',
    rules: '',
    category: '',
    difficulty: 'Easy'
  });

  const availableViewers = [
    { id: '1', name: 'Sarah Chen', avatar: 'S', status: 'online' },
    { id: '2', name: 'Mike Johnson', avatar: 'M', status: 'offline' },
    { id: '3', name: 'Alex Rivera', avatar: 'A', status: 'online' },
    { id: '4', name: 'Emma Watson', avatar: 'E', status: 'offline' },
    { id: '5', name: 'David Kim', avatar: 'D', status: 'online' },
    { id: '6', name: 'Lisa Park', avatar: 'L', status: 'online' }
  ];

  const userMemories = [
    {
      id: 1,
      title: "Coffee Shop Discovery",
      type: "photo",
      location: "SOMA District",
      time: "2h ago",
      likes: 12,
      description: "Found this amazing hidden coffee spot"
    },
    {
      id: 2,
      title: "Street Art Masterpiece",
      type: "video",
      location: "Mission District",
      time: "1d ago",
      likes: 45,
      description: "Incredible mural by local artist"
    },
    {
      id: 3,
      title: "Sunset at the Bridge",
      type: "photo",
      location: "Golden Gate",
      time: "3d ago",
      likes: 89,
      description: "Perfect golden hour moment"
    },
    {
      id: 4,
      title: "Food Truck Adventure",
      type: "text",
      location: "Financial District",
      time: "5d ago",
      likes: 23,
      description: "Best tacos in the city"
    },
    {
      id: 5,
      title: "Morning Yoga Session",
      type: "audio",
      location: "Dolores Park",
      time: "1w ago",
      likes: 67,
      description: "Peaceful meditation spot"
    },
    {
      id: 6,
      title: "Historic Architecture",
      type: "photo",
      location: "Chinatown",
      time: "1w ago",
      likes: 34,
      description: "Beautiful traditional building details"
    }
  ];

  const categories = [
    { id: 'nature', name: 'Nature', icon: '🌿', color: 'from-green-500 to-emerald-500' },
    { id: 'culture', name: 'Culture', icon: '🎭', color: 'from-purple-500 to-violet-500' },
    { id: 'food', name: 'Food', icon: '🍽️', color: 'from-orange-500 to-red-500' },
    { id: 'photography', name: 'Photography', icon: '📸', color: 'from-blue-500 to-cyan-500' },
    { id: 'adventure', name: 'Adventure', icon: '⛰️', color: 'from-red-500 to-pink-500' },
    { id: 'history', name: 'History', icon: '🏛️', color: 'from-yellow-500 to-orange-500' }
  ];

  const difficulties = [
    { id: 'Easy', color: 'text-green-400', description: 'Suitable for everyone' },
    { id: 'Medium', color: 'text-yellow-400', description: 'Some walking required' },
    { id: 'Hard', color: 'text-red-400', description: 'Physically demanding' }
  ];

  const canProceedStep1 = () => {
    return trailData.title.trim().length >= 3 && 
           trailData.description.trim().length >= 10 &&
           trailData.category !== '';
  };

  const canProceedStep2 = () => {
    return selectedMemories.length >= 2;
  };

  const handleNext = () => {
    if (currentStep === 1 && canProceedStep1()) {
      setCurrentStep(2);
    } else if (currentStep === 2 && canProceedStep2()) {
      setCurrentStep(3);
    } else if (currentStep === 3) {
      setCurrentStep(4); // Go to preview
    }
  };

  const handleBack = () => {
    if (currentStep > 1) {
      setCurrentStep(currentStep - 1);
    } else {
      onNavigate('trails');
    }
  };

  const handlePublish = async () => {
    setIsPublishing(true);
    await new Promise(resolve => setTimeout(resolve, 2000));
    setIsPublishing(false);
    onNavigate('trails');
  };

  const toggleViewer = (viewerId: string) => {
    setSelectedViewers(prev => 
      prev.includes(viewerId) 
        ? prev.filter(id => id !== viewerId)
        : [...prev, viewerId]
    );
  };

  const toggleMemory = (memoryId: number) => {
    setSelectedMemories(prev => 
      prev.includes(memoryId) 
        ? prev.filter(id => id !== memoryId)
        : [...prev, memoryId]
    );
  };

  const getMemoryTypeIcon = (type: string) => {
    switch (type) {
      case 'photo': return '📸';
      case 'video': return '🎥';
      case 'audio': return '🎵';
      case 'text': return '📝';
      default: return '📄';
    }
  };

  const renderStepContent = () => {
    switch (currentStep) {
      case 1:
        return (
          <div className="space-y-6 p-6 pb-32">
            <div className="text-center mb-8">
              <h2 className={`text-2xl font-bold mb-2 ${colors.textPrimary}`}>Create New Trail</h2>
              <p className={colors.textSecondary}>Share your favorite memory journey with others</p>
            </div>

            {/* Trail Title */}
            <motion.div
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.1, duration: 0.4 }}
              className={`glass-card rounded-[20px] p-4 backdrop-blur-xl border ${colors.glassBorder}`}
            >
              <div className="flex items-center space-x-3 mb-3">
                <Route size={18} className={colors.accent} />
                <label className={`font-medium ${colors.textPrimary}`}>Trail Title</label>
                <span className={`text-xs ${colors.textSecondary}`}>({trailData.title.length}/60)</span>
              </div>
              <input
                type="text"
                value={trailData.title}
                onChange={(e) => setTrailData(prev => ({ ...prev, title: e.target.value.slice(0, 60) }))}
                placeholder="Give your trail an exciting name..."
                className={`w-full ${colors.inputBackground} border ${colors.glassBorder} rounded-[16px] px-4 py-3 ${colors.textPrimary} placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all duration-200`}
                maxLength={60}
              />
              {trailData.title.length > 0 && trailData.title.length < 3 && (
                <p className="text-orange-400 text-xs mt-2">Title must be at least 3 characters long</p>
              )}
            </motion.div>

            {/* Trail Description */}
            <motion.div
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.2, duration: 0.4 }}
              className={`glass-card rounded-[20px] p-4 backdrop-blur-xl border ${colors.glassBorder}`}
            >
              <div className="flex items-center space-x-3 mb-3">
                <FileText size={18} className={colors.accent} />
                <label className={`font-medium ${colors.textPrimary}`}>Description</label>
                <span className={`text-xs ${colors.textSecondary}`}>({trailData.description.length}/200)</span>
              </div>
              <Textarea
                value={trailData.description}
                onChange={(e) => setTrailData(prev => ({ ...prev, description: e.target.value.slice(0, 200) }))}
                placeholder="Describe what makes this trail special (minimum 10 characters)..."
                className={`w-full h-24 ${colors.inputBackground} border ${colors.glassBorder} rounded-[16px] px-4 py-3 ${colors.textPrimary} placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all duration-200 resize-none`}
                maxLength={200}
              />
              {trailData.description.length > 0 && trailData.description.length < 10 && (
                <p className="text-orange-400 text-xs mt-2">Description must be at least 10 characters long</p>
              )}
              {trailData.description.length >= 10 && (
                <p className="text-green-400 text-xs mt-2">✓ Description looks good!</p>
              )}
            </motion.div>

            {/* Trail Rules (Optional) */}
            <motion.div
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.3, duration: 0.4 }}
              className={`glass-card rounded-[20px] p-4 backdrop-blur-xl border ${colors.glassBorder}`}
            >
              <div className="flex items-center space-x-3 mb-3">
                <Users size={18} className={colors.accent} />
                <label className={`font-medium ${colors.textPrimary}`}>Trail Rules</label>
                <span className={`text-xs ${colors.accent}`}>(Optional)</span>
              </div>
              <Textarea
                value={trailData.rules}
                onChange={(e) => setTrailData(prev => ({ ...prev, rules: e.target.value.slice(0, 150) }))}
                placeholder="Any guidelines or rules for participants (e.g., be respectful, don't disturb locals)..."
                className={`w-full h-20 ${colors.inputBackground} border ${colors.glassBorder} rounded-[16px] px-4 py-3 ${colors.textPrimary} placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all duration-200 resize-none`}
                maxLength={150}
              />
              <p className={`text-xs mt-2 ${colors.textSecondary}`}>Optional rules help create a better experience for everyone</p>
            </motion.div>

            {/* Category Selection */}
            <motion.div
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.4, duration: 0.4 }}
              className={`glass-card rounded-[20px] p-4 backdrop-blur-xl border ${colors.glassBorder}`}
            >
              <div className="flex items-center space-x-3 mb-4">
                <MapPin size={18} className={colors.accent} />
                <label className={`font-medium ${colors.textPrimary}`}>Category</label>
              </div>
              
              <div className="grid grid-cols-3 gap-3">
                {categories.map((category) => {
                  const isSelected = trailData.category === category.id;
                  return (
                    <motion.button
                      key={category.id}
                      whileTap={{ scale: 0.95 }}
                      onClick={() => setTrailData(prev => ({ ...prev, category: category.id }))}
                      className={`glass-card rounded-[16px] p-3 backdrop-blur-md transition-all duration-200 border text-center ${
                        isSelected ? 'border-purple-500/50 bg-purple-600/30' : `${colors.glassBorder} hover:border-white/40`
                      }`}
                      style={isSelected ? { 
                        boxShadow: '0 4px 12px rgba(107, 31, 179, 0.3)' 
                      } : {}}
                    >
                      <div className="text-2xl mb-1">{category.icon}</div>
                      <span className={`text-xs font-medium ${isSelected ? 'text-white' : colors.textSecondary}`}>
                        {category.name}
                      </span>
                    </motion.button>
                  );
                })}
              </div>
            </motion.div>

            {/* Difficulty Level */}
            <motion.div
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.5, duration: 0.4 }}
              className={`glass-card rounded-[20px] p-4 backdrop-blur-xl border ${colors.glassBorder}`}
            >
              <div className="flex items-center space-x-3 mb-4">
                <Sparkles size={18} className={colors.accent} />
                <label className={`font-medium ${colors.textPrimary}`}>Difficulty Level</label>
              </div>
              
              <div className="space-y-3">
                {difficulties.map((difficulty) => {
                  const isSelected = trailData.difficulty === difficulty.id;
                  return (
                    <motion.button
                      key={difficulty.id}
                      whileTap={{ scale: 0.98 }}
                      onClick={() => setTrailData(prev => ({ ...prev, difficulty: difficulty.id }))}
                      className={`w-full glass-card rounded-[16px] p-3 backdrop-blur-md transition-all duration-200 border text-left ${
                        isSelected ? 'border-purple-500/50 bg-purple-600/30' : `${colors.glassBorder} hover:border-white/40`
                      }`}
                    >
                      <div className="flex items-center justify-between">
                        <div>
                          <span className={`font-medium ${isSelected ? 'text-white' : difficulty.color}`}>
                            {difficulty.id}
                          </span>
                          <p className={`text-sm ${colors.textSecondary}`}>{difficulty.description}</p>
                        </div>
                        {isSelected && <Check size={16} className={colors.accent} />}
                      </div>
                    </motion.button>
                  );
                })}
              </div>
            </motion.div>

            {/* Privacy Settings */}
            <motion.div
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.6, duration: 0.4 }}
              className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.glassBorder}`}
            >
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center space-x-3">
                  {isPublic ? <Globe size={20} className="text-green-400" /> : <Lock size={20} className="text-orange-400" />}
                  <div>
                    <h3 className={`font-semibold ${colors.textPrimary}`}>Privacy Settings</h3>
                    <p className={`text-sm ${colors.textSecondary}`}>
                      {isPublic ? 'Everyone can discover this trail' : 'Only selected people can see this trail'}
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

      case 2:
        return (
          <div className="space-y-6 p-6 pb-32">
            <div className="text-center mb-8">
              <h2 className={`text-2xl font-bold mb-2 ${colors.textPrimary}`}>Select Memories</h2>
              <p className={colors.textSecondary}>Choose memories to include in your trail (minimum 2)</p>
            </div>

            <div className={`glass-card rounded-[20px] p-4 backdrop-blur-xl border ${colors.glassBorder} mb-6`}>
              <div className="flex items-center justify-between">
                <span className={`font-medium ${colors.textPrimary}`}>Selected memories</span>
                <span className={`font-semibold ${colors.accent}`}>{selectedMemories.length}</span>
              </div>
              {selectedMemories.length > 0 && selectedMemories.length < 2 && (
                <p className="text-orange-400 text-xs mt-2">Select at least 2 memories to create a trail</p>
              )}
              {selectedMemories.length >= 2 && (
                <p className="text-green-400 text-xs mt-2">✓ Great! Your trail is taking shape</p>
              )}
            </div>

            <div className="space-y-3">
              {userMemories.map((memory, index) => {
                const isSelected = selectedMemories.includes(memory.id);
                return (
                  <motion.button
                    key={memory.id}
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: index * 0.05, duration: 0.3 }}
                    whileTap={{ scale: 0.98 }}
                    onClick={() => toggleMemory(memory.id)}
                    className={`w-full glass-card rounded-[18px] p-4 backdrop-blur-xl transition-all duration-200 border ${
                      isSelected 
                        ? 'border-purple-500/50 bg-purple-600/30' 
                        : `${colors.glassBorder} hover:border-white/40`
                    }`}
                    style={isSelected ? { 
                      boxShadow: '0 4px 16px rgba(107, 31, 179, 0.3)' 
                    } : {}}
                  >
                    <div className="flex items-center space-x-4">
                      <div className="relative">
                        <div className="w-12 h-12 bg-gradient-to-r from-purple-500 to-blue-500 rounded-[12px] flex items-center justify-center">
                          <span className="text-lg">{getMemoryTypeIcon(memory.type)}</span>
                        </div>
                        {isSelected && (
                          <div className="absolute -top-2 -right-2 w-6 h-6 bg-gradient-to-r from-green-400 to-green-300 rounded-full flex items-center justify-center">
                            <Check size={12} className="text-white" />
                          </div>
                        )}
                      </div>

                      <div className="flex-1 text-left">
                        <h3 className={`font-semibold mb-1 ${colors.textPrimary}`}>{memory.title}</h3>
                        <p className={`text-sm mb-1 ${colors.textSecondary}`}>{memory.description}</p>
                        <div className={`flex items-center space-x-3 text-xs ${colors.textSecondary}`}>
                          <span>{memory.location}</span>
                          <span>•</span>
                          <span>{memory.time}</span>
                          <span>•</span>
                          <span>{memory.likes} likes</span>
                        </div>
                      </div>
                    </div>
                  </motion.button>
                );
              })}
            </div>
          </div>
        );

      case 3:
        return (
          <div className="space-y-6 p-6 pb-32">
            <div className="text-center mb-8">
              <h2 className={`text-2xl font-bold mb-2 ${colors.textPrimary}`}>Trail Route</h2>
              <p className={colors.textSecondary}>Review and organize your trail sequence</p>
            </div>

            {/* Route Visualization */}
            <div className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.glassBorder}`}>
              <h3 className={`font-semibold mb-4 flex items-center ${colors.textPrimary}`}>
                <Route size={20} className={`mr-2 ${colors.accent}`} />
                Trail Sequence
              </h3>
              
              <div className="space-y-4">
                {selectedMemories.map((memoryId, index) => {
                  const memory = userMemories.find(m => m.id === memoryId);
                  if (!memory) return null;
                  
                  return (
                    <div key={memory.id} className="flex items-center space-x-4">
                      <div className="flex-shrink-0 w-8 h-8 bg-gradient-to-r from-purple-500 to-blue-500 rounded-full flex items-center justify-center">
                        <span className="text-white text-sm font-semibold">{index + 1}</span>
                      </div>
                      
                      <div className={`flex-1 glass-card rounded-[12px] p-3 backdrop-blur-md border ${colors.glassBorder}`}>
                        <div className="flex items-center space-x-3">
                          <div className="text-lg">{getMemoryTypeIcon(memory.type)}</div>
                          <div className="flex-1">
                            <h4 className={`font-medium text-sm ${colors.textPrimary}`}>{memory.title}</h4>
                            <p className={`text-xs ${colors.textSecondary}`}>{memory.location}</p>
                          </div>
                        </div>
                      </div>
                      
                      {index < selectedMemories.length - 1 && (
                        <div className={`flex-shrink-0 ${colors.textSecondary}`}>
                          <ArrowLeft size={16} className="rotate-180" />
                        </div>
                      )}
                    </div>
                  );
                })}
              </div>
            </div>

            {/* Trail Stats */}
            <div className={`glass-card rounded-[20px] p-4 backdrop-blur-xl border ${colors.glassBorder}`}>
              <h3 className={`font-semibold mb-3 ${colors.textPrimary}`}>Trail Statistics</h3>
              <div className="grid grid-cols-2 gap-4">
                <div className="text-center">
                  <p className={`text-2xl font-bold ${colors.textPrimary}`}>{selectedMemories.length}</p>
                  <p className={`text-sm ${colors.textSecondary}`}>Memories</p>
                </div>
                <div className="text-center">
                  <p className={`text-2xl font-bold ${colors.textPrimary}`}>~2.5km</p>
                  <p className={`text-sm ${colors.textSecondary}`}>Distance</p>
                </div>
              </div>
            </div>

            {/* Estimated Time */}
            <div className={`glass-card rounded-[20px] p-4 backdrop-blur-xl border ${colors.glassBorder}`}>
              <div className="flex items-center justify-between">
                <div>
                  <h4 className={`font-medium ${colors.textPrimary}`}>Estimated Duration</h4>
                  <p className={`text-sm ${colors.textSecondary}`}>Based on walking pace and content</p>
                </div>
                <div className="text-right">
                  <p className={`text-xl font-bold ${colors.accent}`}>45-60min</p>
                  <p className={`text-xs ${colors.textSecondary}`}>{trailData.difficulty} difficulty</p>
                </div>
              </div>
            </div>
          </div>
        );

      case 4:
        return (
          <div className="space-y-6 p-6 pb-32">
            <div className="text-center mb-8">
              <h2 className={`text-2xl font-bold mb-2 ${colors.textPrimary}`}>Preview Your Trail</h2>
              <p className={colors.textSecondary}>Review everything before publishing</p>
            </div>

            {/* Trail Preview Card */}
            <div className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.glassBorder}`}
                 style={{ 
                   boxShadow: '0 12px 40px rgba(107, 31, 179, 0.3)' 
                 }}>
              {/* Header */}
              <div className="flex items-start justify-between mb-4">
                <div className="flex-1">
                  <h3 className={`font-semibold text-xl mb-2 ${colors.textPrimary}`}>{trailData.title || 'Untitled Trail'}</h3>
                  <p className={`text-sm mb-2 ${colors.accent}`}>by You</p>
                  <p className={`text-sm leading-relaxed ${colors.textPrimary}`}>{trailData.description || 'No description provided'}</p>
                </div>
                
                <div className="ml-4 text-center">
                  <div className="text-3xl mb-1">
                    {categories.find(c => c.id === trailData.category)?.icon || '🗺️'}
                  </div>
                  <span className={`text-xs ${colors.textSecondary}`}>
                    {categories.find(c => c.id === trailData.category)?.name || 'Uncategorized'}
                  </span>
                </div>
              </div>

              {/* Rules */}
              {trailData.rules && (
                <div className={`glass-card rounded-[16px] p-3 backdrop-blur-md mb-4 border ${colors.glassBorder}`}>
                  <h4 className={`font-medium text-sm mb-2 ${colors.textPrimary}`}>Trail Rules</h4>
                  <p className={`text-sm ${colors.textSecondary}`}>{trailData.rules}</p>
                </div>
              )}

              {/* Stats */}
              <div className="grid grid-cols-3 gap-3 mb-4">
                <div className="text-center">
                  <p className={`font-semibold ${colors.textPrimary}`}>{selectedMemories.length}</p>
                  <p className={`text-xs ${colors.textSecondary}`}>Memories</p>
                </div>
                <div className="text-center">
                  <p className={`font-semibold ${colors.textPrimary}`}>~45min</p>
                  <p className={`text-xs ${colors.textSecondary}`}>Duration</p>
                </div>
                <div className={`text-center ${difficulties.find(d => d.id === trailData.difficulty)?.color}`}>
                  <p className="font-semibold">{trailData.difficulty}</p>
                  <p className={`text-xs ${colors.textSecondary}`}>Difficulty</p>
                </div>
              </div>

              {/* Memory Preview */}
              <div className={`border-t pt-4 ${colors.glassBorder}`}>
                <h4 className={`font-medium mb-3 ${colors.textPrimary}`}>Trail Memories ({selectedMemories.length})</h4>
                <div className="grid grid-cols-2 gap-2">
                  {selectedMemories.slice(0, 4).map(memoryId => {
                    const memory = userMemories.find(m => m.id === memoryId);
                    if (!memory) return null;
                    return (
                      <div key={memory.id} className={`glass-card rounded-[8px] p-2 backdrop-blur-md border ${colors.glassBorder} flex items-center space-x-2`}>
                        <span className="text-sm">{getMemoryTypeIcon(memory.type)}</span>
                        <span className={`text-xs truncate ${colors.textPrimary}`}>{memory.title}</span>
                      </div>
                    );
                  })}
                  {selectedMemories.length > 4 && (
                    <div className={`glass-card rounded-[8px] p-2 backdrop-blur-md border ${colors.glassBorder} flex items-center justify-center`}>
                      <span className={`text-xs ${colors.textSecondary}`}>+{selectedMemories.length - 4} more</span>
                    </div>
                  )}
                </div>
              </div>

              {/* Privacy Info */}
              <div className={`flex items-center justify-between mt-4 pt-4 border-t ${colors.glassBorder}`}>
                <div className="flex items-center space-x-2">
                  {isPublic ? <Globe size={16} className="text-green-400" /> : <Lock size={16} className="text-orange-400" />}
                  <span className={`text-sm ${colors.textSecondary}`}>
                    {isPublic ? 'Public trail' : `Shared with ${selectedViewers.length} people`}
                  </span>
                </div>
                <div className={`text-xs ${colors.textSecondary}`}>
                  Ready to publish
                </div>
              </div>
            </div>

            {/* Action Buttons */}
            <div className="flex space-x-3">
              <motion.button
                whileTap={{ scale: 0.98 }}
                onClick={() => setCurrentStep(3)}
                className={`flex-1 glass-card py-3 rounded-[16px] font-medium backdrop-blur-xl border ${colors.glassBorder} hover:border-white/40 transition-all duration-200 ${colors.textPrimary}`}
              >
                Edit
              </motion.button>
              <motion.button
                whileTap={{ scale: 0.98 }}
                onClick={handlePublish}
                disabled={isPublishing}
                className="flex-2 bg-gradient-to-r from-purple-600 to-purple-500 py-3 px-6 rounded-[16px] text-white font-semibold flex items-center justify-center space-x-2"
                style={{ 
                  boxShadow: '0 8px 32px rgba(107, 31, 179, 0.4)' 
                }}
              >
                {isPublishing ? (
                  <motion.div
                    animate={{ rotate: 360 }}
                    transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
                    className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full"
                  />
                ) : (
                  <>
                    <Sparkles size={18} />
                    <span>Publish Trail</span>
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
                {currentStep === 4 ? 'Preview Trail' : 'Create Trail'}
              </h1>
              <p className={`text-sm ${colors.textSecondary}`}>Step {currentStep} of 4</p>
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
              initial={{ width: '25%' }}
              animate={{ width: `${currentStep * 25}%` }}
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
      {currentStep < 4 && (
        <div className="flex-shrink-0 p-6 pb-8">
          <motion.button
            whileTap={{ scale: 0.98 }}
            onClick={handleNext}
            disabled={
              (currentStep === 1 && !canProceedStep1()) ||
              (currentStep === 2 && !canProceedStep2())
            }
            className={`w-full py-4 rounded-[18px] font-semibold transition-all duration-200 ${
              (currentStep === 1 && !canProceedStep1()) ||
              (currentStep === 2 && !canProceedStep2())
                ? `glass-card border ${colors.glassBorder} ${colors.textSecondary}`
                : 'bg-gradient-to-r from-purple-600 to-purple-500 text-white'
            }`}
            style={
              !((currentStep === 1 && !canProceedStep1()) ||
                (currentStep === 2 && !canProceedStep2()))
                ? { boxShadow: '0 8px 32px rgba(107, 31, 179, 0.4)' }
                : {}
            }
          >
            {currentStep === 3 ? 'Preview Trail' : 'Continue'}
          </motion.button>
        </div>
      )}
    </div>
  );
};

export default CreateTrailScreen;