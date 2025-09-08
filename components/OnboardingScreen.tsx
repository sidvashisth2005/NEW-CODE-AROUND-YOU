import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { ChevronRight, MapPin, Camera, Users, Star } from 'lucide-react';
import { useTheme } from './ThemeContext';

interface OnboardingScreenProps {
  onComplete: () => void;
}

const OnboardingScreen: React.FC<OnboardingScreenProps> = ({ onComplete }) => {
  const { colors, isDarkMode, hapticFeedback, playSound } = useTheme();
  const [currentStep, setCurrentStep] = useState(0);

  const onboardingSteps = [
    {
      title: "Welcome to\nAround You",
      subtitle: "Discover memories anchored to the world around you",
      icon: MapPin,
      gradient: isDarkMode ? "from-purple-600 to-purple-800" : "from-purple-200 via-white to-purple-300",
      accentColor: colors.accent
    },
    {
      title: "Create AR\nMemories",
      subtitle: "Capture moments in text, photo, video, and audio",
      icon: Camera,
      gradient: isDarkMode ? "from-blue-600 to-indigo-800" : "from-blue-200 via-white to-indigo-300",
      accentColor: colors.accent
    },
    {
      title: "Connect &\nDiscover",
      subtitle: "Find memories left by others in real-world locations",
      icon: Users,
      gradient: isDarkMode ? "from-indigo-600 to-purple-800" : "from-indigo-200 via-white to-purple-300",
      accentColor: colors.accent
    },
    {
      title: "Your Story\nAwaits",
      subtitle: "Start creating magical experiences today",
      icon: Star,
      gradient: isDarkMode ? "from-purple-600 to-pink-800" : "from-purple-200 via-white to-pink-300",
      accentColor: colors.accent
    }
  ];

  const handleNext = () => {
    hapticFeedback && hapticFeedback('light');
    playSound && playSound('tap');
    
    if (currentStep < onboardingSteps.length - 1) {
      setCurrentStep(currentStep + 1);
    } else {
      playSound && playSound('success');
      onComplete();
    }
  };

  const handleSkip = () => {
    hapticFeedback && hapticFeedback('light');
    playSound && playSound('tap');
    onComplete();
  };

  const currentStepData = onboardingSteps[currentStep];
  const Icon = currentStepData.icon;

  return (
    <div className={`h-full w-full relative overflow-hidden bg-gradient-to-br ${currentStepData.gradient}`}>
      {/* Background Animation */}
      <div className="absolute inset-0">
        {Array.from({ length: 20 }).map((_, i) => (
          <motion.div
            key={i}
            className="absolute w-2 h-2 bg-white/10 rounded-full"
            initial={{
              x: Math.random() * (typeof window !== 'undefined' ? window.innerWidth : 390),
              y: (typeof window !== 'undefined' ? window.innerHeight : 844) + 50,
              opacity: 0
            }}
            animate={{
              y: -50,
              opacity: [0, 1, 0],
            }}
            transition={{
              duration: Math.random() * 3 + 2,
              repeat: Infinity,
              delay: Math.random() * 2,
              ease: "linear"
            }}
          />
        ))}
      </div>

      {/* Content */}
      <div className="relative z-10 h-full flex flex-col items-center justify-between p-8 pt-16 pb-12">
        {/* Skip Button */}
        <div className="w-full flex justify-end">
          <motion.button
            whileTap={{ scale: 0.95 }}
            whileHover={{ scale: 1.05 }}
            onClick={handleSkip}
            className={`glass-card px-4 py-2 rounded-full backdrop-blur-md border ${colors.borderMedium} ${colors.textSecondary} transition-all duration-200`}
            style={{ 
              background: colors.glassBackground,
              boxShadow: colors.shadowSm
            }}
          >
            Skip
          </motion.button>
        </div>

        {/* Main Content */}
        <div className="flex-1 flex flex-col items-center justify-center">
          <AnimatePresence mode="wait">
            <motion.div
              key={currentStep}
              initial={{ opacity: 0, scale: 0.8, y: 50 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 1.2, y: -50 }}
              transition={{ duration: 0.6, ease: "easeOut" }}
              className="flex flex-col items-center text-center"
            >
              {/* Icon */}
              <div className="relative mb-8">
                <motion.div
                  animate={{
                    rotate: [0, 5, -5, 0],
                    scale: [1, 1.05, 1],
                  }}
                  transition={{
                    duration: 4,
                    repeat: Infinity,
                    ease: "easeInOut"
                  }}
                  className={`glass-card w-24 h-24 rounded-full flex items-center justify-center border ${colors.borderMedium}`}
                  style={{ 
                    background: colors.glassBackground,
                    boxShadow: colors.shadowPurple
                  }}
                >
                  <Icon size={40} className={colors.textPrimary} />
                </motion.div>
                
                {/* Floating particles around icon */}
                {Array.from({ length: 6 }).map((_, i) => (
                  <motion.div
                    key={i}
                    className="absolute w-1 h-1 bg-white/60 rounded-full"
                    style={{
                      left: '50%',
                      top: '50%',
                    }}
                    animate={{
                      x: [0, Math.cos(i * 60 * Math.PI / 180) * 50],
                      y: [0, Math.sin(i * 60 * Math.PI / 180) * 50],
                      opacity: [0, 1, 0],
                      scale: [0, 1, 0],
                    }}
                    transition={{
                      duration: 2,
                      repeat: Infinity,
                      delay: i * 0.3,
                      ease: "easeInOut"
                    }}
                  />
                ))}
              </div>

              {/* Title */}
              <motion.h1
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.2, duration: 0.6 }}
                className={`text-4xl font-bold ${colors.textPrimary} mb-4 leading-tight`}
                style={{ fontFamily: 'SF Pro Display, -apple-system, system-ui' }}
              >
                {currentStepData.title}
              </motion.h1>

              {/* Subtitle */}
              <motion.p
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.4, duration: 0.6 }}
                className={`text-lg ${colors.textSecondary} max-w-xs leading-relaxed`}
              >
                {currentStepData.subtitle}
              </motion.p>
            </motion.div>
          </AnimatePresence>
        </div>

        {/* Bottom Section */}
        <div className="w-full flex flex-col items-center space-y-6">
          {/* Progress Dots */}
          <div className="flex space-x-3">
            {onboardingSteps.map((_, index) => (
              <motion.div
                key={index}
                className={`h-2 rounded-full transition-all duration-300 ${
                  index === currentStep ? 'bg-white w-8' : 'bg-white/30 w-2'
                }`}
                layoutId={index === currentStep ? 'activeDot' : undefined}
              />
            ))}
          </div>

          {/* Next Button */}
          <motion.button
            whileTap={{ scale: 0.95 }}
            whileHover={{ scale: 1.02 }}
            onClick={handleNext}
            className={`glass-card w-full max-w-xs py-4 rounded-[20px] flex items-center justify-center space-x-3 ${colors.textPrimary} backdrop-blur-md border ${colors.borderMedium} transition-all duration-300`}
            style={{ 
              background: colors.glassBackground,
              boxShadow: colors.shadowPurple
            }}
          >
            <span className="font-semibold text-lg">
              {currentStep === onboardingSteps.length - 1 ? 'Get Started' : 'Continue'}
            </span>
            <ChevronRight size={20} />
          </motion.button>
        </div>
      </div>
    </div>
  );
};

export default OnboardingScreen;