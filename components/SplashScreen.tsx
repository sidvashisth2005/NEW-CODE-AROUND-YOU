import React, { useEffect, useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import Logo from './Logo';
import { useTheme } from './ThemeContext';

interface SplashScreenProps {
  onComplete: () => void;
}

const SplashScreen: React.FC<SplashScreenProps> = ({ onComplete }) => {
  const { colors, isDarkMode, hapticFeedback, playSound } = useTheme();
  const [loadingProgress, setLoadingProgress] = useState(0);
  const [showLogo, setShowLogo] = useState(false);
  const [loadingText, setLoadingText] = useState('Initializing AR Engine...');

  const loadingSteps = [
    'Initializing AR Engine...',
    'Loading Memory Database...',
    'Connecting to Network...',
    'Preparing Experience...',
    'Welcome to Around You!'
  ];

  useEffect(() => {
    // Show logo after initial delay
    const logoTimer = setTimeout(() => {
      setShowLogo(true);
      hapticFeedback && hapticFeedback('light');
      playSound && playSound('startup');
    }, 300);

    // Simulate loading process
    const loadingInterval = setInterval(() => {
      setLoadingProgress(prev => {
        const newProgress = prev + Math.random() * 15 + 5;
        
        // Update loading text based on progress
        const stepIndex = Math.floor((newProgress / 100) * loadingSteps.length);
        if (stepIndex < loadingSteps.length) {
          setLoadingText(loadingSteps[stepIndex]);
        }
        
        if (newProgress >= 100) {
          clearInterval(loadingInterval);
          hapticFeedback && hapticFeedback('medium');
          playSound && playSound('success');
          // Complete after final animation
          setTimeout(() => {
            onComplete();
          }, 1000);
          return 100;
        }
        
        return newProgress;
      });
    }, 150);

    return () => {
      clearTimeout(logoTimer);
      clearInterval(loadingInterval);
    };
  }, [onComplete, hapticFeedback, playSound]);

  return (
    <motion.div
      className={`h-screen w-full bg-gradient-to-br ${colors.background} flex flex-col items-center justify-center relative overflow-hidden`}
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0, scale: 1.1 }}
      transition={{ duration: 0.8 }}
    >
      {/* Enhanced Animated Background Elements */}
      <div className="absolute inset-0 overflow-hidden">
        {/* Floating Orb Animations - Improved */}
        {[...Array(18)].map((_, i) => {
          const size = Math.random() * 80 + 30;
          const initialX = Math.random() * 100;
          const initialY = Math.random() * 100;
          const moveRange = 150;
          
          return (
            <motion.div
              key={i}
              className="absolute rounded-full backdrop-blur-md"
              style={{
                width: size,
                height: size,
                left: `${initialX}%`,
                top: `${initialY}%`,
                background: `radial-gradient(circle, ${
                  isDarkMode 
                    ? `rgba(107, 31, 179, ${0.15 + Math.random() * 0.15})` 
                    : `rgba(198, 182, 226, ${0.2 + Math.random() * 0.2})`
                } 0%, transparent 70%)`,
                filter: 'blur(1px)',
              }}
              animate={{
                x: [0, (Math.random() - 0.5) * moveRange, 0],
                y: [0, (Math.random() - 0.5) * moveRange, 0],
                scale: [1, 0.8 + Math.random() * 0.4, 1],
                opacity: [0.4, 0.8, 0.4],
                rotate: [0, Math.random() * 360, 0],
              }}
              transition={{
                duration: 15 + Math.random() * 10,
                repeat: Infinity,
                ease: "easeInOut",
                delay: Math.random() * 8,
              }}
            />
          );
        })}

        {/* Particle Trail System */}
        {[...Array(25)].map((_, i) => (
          <motion.div
            key={`particle-${i}`}
            className="absolute w-1 h-1 rounded-full"
            style={{
              left: `${Math.random() * 100}%`,
              top: `${Math.random() * 100}%`,
              background: isDarkMode 
                ? `rgba(255, 255, 255, ${0.3 + Math.random() * 0.4})`
                : `rgba(107, 31, 179, ${0.4 + Math.random() * 0.3})`,
              boxShadow: isDarkMode
                ? '0 0 4px rgba(255, 255, 255, 0.5)'
                : '0 0 4px rgba(107, 31, 179, 0.5)'
            }}
            animate={{
              y: [0, -100 - Math.random() * 50],
              x: [(Math.random() - 0.5) * 20, (Math.random() - 0.5) * 40],
              opacity: [0, 1, 0],
              scale: [0, 1, 0.5, 0],
            }}
            transition={{
              duration: 3 + Math.random() * 2,
              repeat: Infinity,
              delay: Math.random() * 6,
              ease: "easeOut",
            }}
          />
        ))}

        {/* Enhanced Grid Pattern */}
        <div 
          className={`absolute inset-0 ${isDarkMode ? 'opacity-8' : 'opacity-4'}`}
          style={{
            backgroundImage: `
              linear-gradient(${isDarkMode ? 'rgba(255,255,255,0.06)' : 'rgba(107, 31, 179, 0.06)'} 1px, transparent 1px), 
              linear-gradient(90deg, ${isDarkMode ? 'rgba(255,255,255,0.06)' : 'rgba(107, 31, 179, 0.06)'} 1px, transparent 1px)
            `,
            backgroundSize: '40px 40px',
            animation: 'gridFloat 20s ease-in-out infinite'
          }}
        />

        {/* Radial Gradient Overlays */}
        <div className={`absolute inset-0 ${
          isDarkMode 
            ? 'bg-gradient-radial from-transparent via-purple-900/10 to-purple-900/25' 
            : 'bg-gradient-radial from-transparent via-purple-200/15 to-purple-400/30'
        }`} />
        
        {/* Center Glow Effect */}
        <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
          <motion.div
            className={`w-96 h-96 rounded-full ${
              isDarkMode 
                ? 'bg-gradient-radial from-purple-600/5 to-transparent' 
                : 'bg-gradient-radial from-purple-300/10 to-transparent'
            }`}
            animate={{
              scale: [1, 1.2, 1],
              opacity: [0.3, 0.6, 0.3],
            }}
            transition={{
              duration: 8,
              repeat: Infinity,
              ease: "easeInOut",
            }}
          />
        </div>
      </div>

      {/* Main Content */}
      <div className="relative z-10 flex flex-col items-center">
        {/* Logo */}
        <AnimatePresence>
          {showLogo && (
            <motion.div
              initial={{ scale: 0, opacity: 0, y: 50 }}
              animate={{ scale: 1, opacity: 1, y: 0 }}
              transition={{
                type: "spring",
                bounce: 0.4,
                duration: 1.2
              }}
              className="mb-12"
            >
              <Logo size={120} animated={true} showText={true} />
            </motion.div>
          )}
        </AnimatePresence>

        {/* Loading Section */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 1.5, duration: 0.8 }}
          className="w-80 max-w-sm"
        >
          {/* Loading Text */}
          <motion.div
            className="text-center mb-8"
            key={loadingText}
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -10 }}
            transition={{ duration: 0.4 }}
          >
            <p className={`font-medium mb-2 ${colors.textPrimary}`}>{loadingText}</p>
            <p className={`text-sm ${colors.textSecondary}`}>
              {loadingProgress < 100 ? `${Math.round(loadingProgress)}%` : 'Ready!'}
            </p>
          </motion.div>

          {/* Progress Bar */}
          <div 
            className={`glass-card rounded-full h-3 p-1 backdrop-blur-xl border ${colors.borderMedium} overflow-hidden`}
            style={{ 
              background: colors.glassBackground,
              boxShadow: colors.shadowMd
            }}
          >
            <motion.div
              className="h-full rounded-full bg-gradient-to-r from-purple-500 to-blue-500 relative"
              style={{ 
                boxShadow: colors.shadowPurple
              }}
              initial={{ width: '0%' }}
              animate={{ width: `${loadingProgress}%` }}
              transition={{ duration: 0.3, ease: "easeOut" }}
            >
              {/* Progress Bar Glow Effect */}
              <motion.div
                className="absolute inset-0 bg-gradient-to-r from-transparent via-white/30 to-transparent"
                animate={{
                  x: ['-100%', '200%'],
                }}
                transition={{
                  duration: 2,
                  repeat: Infinity,
                  ease: "easeInOut",
                }}
              />
            </motion.div>
          </div>

          {/* Loading Dots */}
          <div className="flex justify-center space-x-2 mt-6">
            {[...Array(3)].map((_, i) => (
              <motion.div
                key={i}
                className={`w-2 h-2 rounded-full ${isDarkMode ? 'bg-white/60' : 'bg-purple-400/60'}`}
                animate={{
                  scale: [1, 1.5, 1],
                  opacity: [0.6, 1, 0.6],
                }}
                transition={{
                  duration: 1.5,
                  repeat: Infinity,
                  delay: i * 0.2,
                  ease: "easeInOut",
                }}
              />
            ))}
          </div>
        </motion.div>

        {/* Completion Animation */}
        <AnimatePresence>
          {loadingProgress >= 100 && (
            <motion.div
              initial={{ opacity: 0, scale: 0.8 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 1.2 }}
              transition={{ duration: 0.6, ease: "easeOut" }}
              className="absolute inset-0 flex items-center justify-center"
            >
              <motion.div
                className="w-32 h-32 border-4 border-purple-400/50 rounded-full"
                animate={{
                  scale: [1, 20],
                  opacity: [0.8, 0],
                }}
                transition={{
                  duration: 1,
                  ease: "easeOut",
                }}
              />
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      {/* Bottom Branding */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 2, duration: 0.8 }}
        className="absolute bottom-12 text-center"
      >
        <p className={`text-sm mb-2 ${colors.textSecondary}`}>Powered by Advanced AR Technology</p>
        <div className="flex items-center justify-center space-x-2">
          <div className="w-1 h-1 bg-purple-400 rounded-full"></div>
          <p className={`text-xs ${colors.textSecondary}`}>Premium iOS Experience</p>
          <div className="w-1 h-1 bg-purple-400 rounded-full"></div>
        </div>
      </motion.div>

      {/* Particle Effects */}
      <div className="absolute inset-0 pointer-events-none">
        {[...Array(20)].map((_, i) => (
          <motion.div
            key={i}
            className={`absolute w-1 h-1 rounded-full ${isDarkMode ? 'bg-white/30' : 'bg-purple-400/30'}`}
            style={{
              left: `${Math.random() * 100}%`,
              top: `${Math.random() * 100}%`,
            }}
            animate={{
              y: [0, -100],
              opacity: [0, 1, 0],
              scale: [0, 1, 0],
            }}
            transition={{
              duration: Math.random() * 3 + 2,
              repeat: Infinity,
              delay: Math.random() * 5,
              ease: "easeOut",
            }}
          />
        ))}
      </div>
    </motion.div>
  );
};

export default SplashScreen;