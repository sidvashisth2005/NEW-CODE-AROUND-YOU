import React from 'react';
import { motion } from 'motion/react';

interface LogoProps {
  size?: number;
  animated?: boolean;
  showText?: boolean;
  className?: string;
}

const Logo: React.FC<LogoProps> = ({ 
  size = 80, 
  animated = false, 
  showText = false,
  className = ""
}) => {
  const logoVariants = {
    initial: { scale: 0.8, opacity: 0 },
    animate: { 
      scale: 1, 
      opacity: 1,
      transition: {
        duration: 0.8,
        ease: [0.4, 0, 0.2, 1]
      }
    }
  };

  const pulseVariants = {
    animate: {
      scale: [1, 1.05, 1],
      opacity: [0.7, 1, 0.7],
      transition: {
        duration: 2,
        repeat: Infinity,
        ease: "easeInOut"
      }
    }
  };

  const floatingVariants = {
    animate: {
      y: [0, -8, 0],
      rotate: [0, 2, -2, 0],
      transition: {
        duration: 4,
        repeat: Infinity,
        ease: "easeInOut"
      }
    }
  };

  return (
    <motion.div
      className={`flex flex-col items-center ${className}`}
      variants={animated ? logoVariants : undefined}
      initial={animated ? "initial" : undefined}
      animate={animated ? "animate" : undefined}
    >
      <motion.div
        className="relative"
        variants={animated ? floatingVariants : undefined}
        animate={animated ? "animate" : undefined}
      >
        <svg
          width={size}
          height={size}
          viewBox="0 0 120 120"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
          className="drop-shadow-lg"
        >
          {/* Gradient Definitions */}
          <defs>
            <linearGradient id="primaryGradient" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stopColor="#6B1FB3" />
              <stop offset="100%" stopColor="#C6B6E2" />
            </linearGradient>
            <linearGradient id="accentGradient" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stopColor="#FFD700" />
              <stop offset="100%" stopColor="#FFA500" />
            </linearGradient>
            <linearGradient id="glowGradient" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stopColor="#6B1FB3" stopOpacity="0.3" />
              <stop offset="100%" stopColor="#C6B6E2" stopOpacity="0.1" />
            </linearGradient>
            <filter id="glow">
              <feGaussianBlur stdDeviation="3" result="coloredBlur"/>
              <feMerge> 
                <feMergeNode in="coloredBlur"/>
                <feMergeNode in="SourceGraphic"/>
              </feMerge>
            </filter>
            <filter id="shadow">
              <feDropShadow dx="0" dy="4" stdDeviation="8" floodColor="#6B1FB3" floodOpacity="0.3"/>
            </filter>
          </defs>

          {/* Background Glow Circle */}
          <motion.circle
            cx="60"
            cy="60"
            r="50"
            fill="url(#glowGradient)"
            filter="url(#glow)"
            animate={animated ? {
              scale: [1, 1.1, 1],
              opacity: [0.3, 0.5, 0.3]
            } : undefined}
            transition={animated ? {
              duration: 3,
              repeat: Infinity,
              ease: "easeInOut"
            } : undefined}
          />

          {/* Main Logo Structure - AR Hexagon Frame */}
          <motion.path
            d="M60 15 L90 30 L90 60 L60 75 L30 60 L30 30 Z"
            fill="none"
            stroke="url(#primaryGradient)"
            strokeWidth="3"
            filter="url(#shadow)"
            animate={animated ? {
              rotate: [0, 360],
            } : undefined}
            transition={animated ? {
              duration: 20,
              repeat: Infinity,
              ease: "linear"
            } : undefined}
            style={{ transformOrigin: "60px 60px" }}
          />

          {/* Inner AR Elements - Memory Pins */}
          <motion.g
            animate={animated ? {
              rotate: [0, -180],
            } : undefined}
            transition={animated ? {
              duration: 15,
              repeat: Infinity,
              ease: "linear"
            } : undefined}
            style={{ transformOrigin: "60px 60px" }}
          >
            {/* Central Memory Hub */}
            <circle cx="60" cy="60" r="8" fill="url(#primaryGradient)" filter="url(#glow)" />
            
            {/* Memory Pins at 120-degree intervals */}
            <g>
              {/* Pin 1 - Top */}
              <circle cx="60" cy="35" r="4" fill="url(#accentGradient)" />
              <path d="M60 35 L60 45" stroke="url(#accentGradient)" strokeWidth="2" />
              
              {/* Pin 2 - Bottom Right */}
              <circle cx="82" cy="72" r="4" fill="url(#accentGradient)" />
              <path d="M82 72 L75 68" stroke="url(#accentGradient)" strokeWidth="2" />
              
              {/* Pin 3 - Bottom Left */}
              <circle cx="38" cy="72" r="4" fill="url(#accentGradient)" />
              <path d="M38 72 L45 68" stroke="url(#accentGradient)" strokeWidth="2" />
            </g>
          </motion.g>

          {/* Connection Lines */}
          <motion.g
            opacity="0.6"
            animate={animated ? {
              opacity: [0.3, 0.8, 0.3],
            } : undefined}
            transition={animated ? {
              duration: 2.5,
              repeat: Infinity,
              ease: "easeInOut"
            } : undefined}
          >
            <path d="M60 60 L60 35" stroke="url(#primaryGradient)" strokeWidth="1.5" strokeDasharray="2,2" />
            <path d="M60 60 L82 72" stroke="url(#primaryGradient)" strokeWidth="1.5" strokeDasharray="2,2" />
            <path d="M60 60 L38 72" stroke="url(#primaryGradient)" strokeWidth="1.5" strokeDasharray="2,2" />
          </motion.g>

          {/* Outer Orbital Rings */}
          <motion.g
            animate={animated ? {
              rotate: [0, 360],
            } : undefined}
            transition={animated ? {
              duration: 25,
              repeat: Infinity,
              ease: "linear"
            } : undefined}
            style={{ transformOrigin: "60px 60px" }}
          >
            <circle 
              cx="60" 
              cy="60" 
              r="42" 
              fill="none" 
              stroke="url(#primaryGradient)" 
              strokeWidth="1" 
              opacity="0.4"
              strokeDasharray="5,10"
            />
            <circle cx="60" cy="18" r="2" fill="url(#primaryGradient)" opacity="0.7" />
            <circle cx="102" cy="60" r="2" fill="url(#primaryGradient)" opacity="0.7" />
            <circle cx="18" cy="60" r="2" fill="url(#primaryGradient)" opacity="0.7" />
          </motion.g>

          {/* AR Depth Indicator */}
          <motion.g
            animate={animated ? {
              scale: [1, 1.2, 1],
              opacity: [0.5, 0.8, 0.5]
            } : undefined}
            transition={animated ? {
              duration: 1.8,
              repeat: Infinity,
              ease: "easeInOut"
            } : undefined}
          >
            <path
              d="M50 50 L55 45 L65 45 L70 50 L65 55 L55 55 Z"
              fill="none"
              stroke="url(#accentGradient)"
              strokeWidth="1.5"
              opacity="0.6"
            />
          </motion.g>

          {/* Floating Particles */}
          {animated && (
            <motion.g>
              {[...Array(6)].map((_, i) => (
                <motion.circle
                  key={i}
                  cx={30 + (i * 12)}
                  cy={30 + (i % 2) * 60}
                  r="1"
                  fill="url(#primaryGradient)"
                  animate={{
                    y: [0, -10, 0],
                    opacity: [0.3, 0.8, 0.3],
                    scale: [0.5, 1, 0.5]
                  }}
                  transition={{
                    duration: 2 + (i * 0.3),
                    repeat: Infinity,
                    ease: "easeInOut",
                    delay: i * 0.2
                  }}
                />
              ))}
            </motion.g>
          )}
        </svg>

        {/* Pulse Effect */}
        {animated && (
          <motion.div
            className="absolute inset-0 rounded-full border-2 border-purple-400/30"
            variants={pulseVariants}
            animate="animate"
            style={{
              background: 'radial-gradient(circle, rgba(107, 31, 179, 0.1) 0%, transparent 70%)'
            }}
          />
        )}
      </motion.div>

      {/* App Name */}
      {showText && (
        <motion.div
          className="mt-4 text-center"
          initial={animated ? { opacity: 0, y: 10 } : undefined}
          animate={animated ? { opacity: 1, y: 0 } : undefined}
          transition={animated ? { delay: 0.5, duration: 0.6 } : undefined}
        >
          <h1 className="text-2xl font-bold text-white mb-1">Around You</h1>
          <p className="text-purple-300 text-sm">AR Social Discovery</p>
        </motion.div>
      )}
    </motion.div>
  );
};

export default Logo;