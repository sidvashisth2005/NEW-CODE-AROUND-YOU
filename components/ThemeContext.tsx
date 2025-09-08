import React, { createContext, useContext, useState, useEffect } from 'react';

interface ThemeColors {
  background: string;
  cardBackground: string;
  textPrimary: string;
  textSecondary: string;
  accent: string;
  glassBackground: string;
  glassBorder: string;
  navBackground: string;
  inputBackground: string;
  gradientPrimary: string;
  gradientSecondary: string;
  // Enhanced shadow system
  shadowSm: string;
  shadowMd: string;
  shadowLg: string;
  shadowXl: string;
  shadowGlow: string;
  shadowPurple: string;
  shadowGold: string;
  // Enhanced borders
  borderLight: string;
  borderMedium: string;
  borderStrong: string;
  // Filter states
  filterInactive: string;
  filterActive: string;
  filterHover: string;
  // Chat message colors
  senderBubble: string;
  receiverBubble: string;
  senderText: string;
  receiverText: string;
}

interface ThemeContextType {
  isDarkMode: boolean;
  toggleTheme: () => void;
  colors: ThemeColors;
  // Premium features
  accentColor: string;
  setAccentColor: (color: string) => void;
  hapticFeedback: (type: 'light' | 'medium' | 'heavy') => void;
  playSound: (type: 'tap' | 'success' | 'error') => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export const ThemeProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [isDarkMode, setIsDarkMode] = useState(true);
  const [accentColor, setAccentColor] = useState('#6B1FB3'); // Default purple

  useEffect(() => {
    const savedTheme = localStorage.getItem('theme');
    const savedAccent = localStorage.getItem('accentColor');
    if (savedTheme) {
      setIsDarkMode(savedTheme === 'dark');
    }
    if (savedAccent) {
      setAccentColor(savedAccent);
    }
  }, []);

  const toggleTheme = () => {
    const newTheme = !isDarkMode;
    setIsDarkMode(newTheme);
    localStorage.setItem('theme', newTheme ? 'dark' : 'light');
    hapticFeedback('light');
  };

  const handleSetAccentColor = (color: string) => {
    setAccentColor(color);
    localStorage.setItem('accentColor', color);
    hapticFeedback('medium');
  };

  // Haptic Feedback (Web Vibration API)
  const hapticFeedback = (type: 'light' | 'medium' | 'heavy') => {
    if ('vibrate' in navigator) {
      switch (type) {
        case 'light':
          navigator.vibrate(10);
          break;
        case 'medium':
          navigator.vibrate(25);
          break;
        case 'heavy':
          navigator.vibrate(50);
          break;
      }
    }
  };

  // Sound Effects
  const playSound = (type: 'tap' | 'success' | 'error') => {
    // Create audio context for sound effects
    if ('AudioContext' in window || 'webkitAudioContext' in window) {
      const AudioContext = window.AudioContext || (window as any).webkitAudioContext;
      const audioContext = new AudioContext();
      
      const playTone = (frequency: number, duration: number, type: OscillatorType = 'sine') => {
        const oscillator = audioContext.createOscillator();
        const gainNode = audioContext.createGain();
        
        oscillator.connect(gainNode);
        gainNode.connect(audioContext.destination);
        
        oscillator.frequency.setValueAtTime(frequency, audioContext.currentTime);
        oscillator.type = type;
        
        gainNode.gain.setValueAtTime(0, audioContext.currentTime);
        gainNode.gain.linearRampToValueAtTime(0.1, audioContext.currentTime + 0.01);
        gainNode.gain.exponentialRampToValueAtTime(0.001, audioContext.currentTime + duration);
        
        oscillator.start(audioContext.currentTime);
        oscillator.stop(audioContext.currentTime + duration);
      };

      switch (type) {
        case 'tap':
          playTone(800, 0.1);
          break;
        case 'success':
          playTone(523, 0.1);
          setTimeout(() => playTone(659, 0.1), 100);
          break;
        case 'error':
          playTone(300, 0.2);
          break;
      }
    }
  };

  const darkColors = {
    background: 'from-black via-gray-950 to-purple-950',
    cardBackground: 'rgba(0, 0, 0, 0.4)',
    textPrimary: 'text-white',
    textSecondary: 'text-white/70',
    accent: 'text-purple-400',
    glassBackground: 'rgba(255, 255, 255, 0.1)',
    glassBorder: 'border-white/20',
    navBackground: 'rgba(0, 0, 0, 0.8)',
    inputBackground: 'bg-white/10',
    gradientPrimary: 'from-purple-600 to-purple-800',
    gradientSecondary: 'from-purple-400 to-blue-600',
    // Enhanced shadow system for dark mode
    shadowSm: '0 2px 8px rgba(0, 0, 0, 0.3)',
    shadowMd: '0 4px 16px rgba(0, 0, 0, 0.4)',
    shadowLg: '0 8px 32px rgba(0, 0, 0, 0.5)',
    shadowXl: '0 12px 48px rgba(0, 0, 0, 0.6)',
    shadowGlow: '0 0 20px rgba(107, 31, 179, 0.4)',
    shadowPurple: '0 8px 32px rgba(107, 31, 179, 0.4)',
    shadowGold: '0 8px 32px rgba(255, 215, 0, 0.4)',
    // Enhanced borders
    borderLight: 'border-white/20',
    borderMedium: 'border-white/30',
    borderStrong: 'border-white/50',
    // Filter states
    filterInactive: 'bg-white/10 border-white/20 text-white/70 hover:bg-white/15 hover:border-white/30',
    filterActive: 'bg-gradient-to-r from-purple-600 to-purple-500 border-purple-400/50 text-white shadow-lg',
    filterHover: 'hover:bg-white/15 hover:border-white/30',
    // Chat message colors for dark mode
    senderBubble: 'bg-gradient-to-r from-purple-600 to-purple-500',
    receiverBubble: 'bg-white/10 border border-white/20',
    senderText: 'text-white',
    receiverText: 'text-white'
  };

  const lightColors = {
    background: 'from-purple-50 via-white to-purple-100',
    cardBackground: 'rgba(255, 255, 255, 0.95)',
    textPrimary: 'text-gray-900',
    textSecondary: 'text-gray-600',
    accent: 'text-purple-600',
    glassBackground: 'rgba(255, 255, 255, 0.9)',
    glassBorder: 'border-purple-200/80',
    navBackground: 'rgba(255, 255, 255, 0.95)',
    inputBackground: 'bg-purple-50/90',
    gradientPrimary: 'from-purple-500 to-purple-600',
    gradientSecondary: 'from-purple-400 to-blue-500',
    // Enhanced shadow system for light mode
    shadowSm: '0 2px 8px rgba(107, 31, 179, 0.08), 0 1px 3px rgba(0, 0, 0, 0.06)',
    shadowMd: '0 4px 16px rgba(107, 31, 179, 0.12), 0 2px 6px rgba(0, 0, 0, 0.08)',
    shadowLg: '0 8px 32px rgba(107, 31, 179, 0.16), 0 4px 12px rgba(0, 0, 0, 0.1)',
    shadowXl: '0 12px 48px rgba(107, 31, 179, 0.2), 0 6px 16px rgba(0, 0, 0, 0.12)',
    shadowGlow: '0 0 20px rgba(107, 31, 179, 0.25)',
    shadowPurple: '0 8px 32px rgba(107, 31, 179, 0.25)',
    shadowGold: '0 8px 32px rgba(255, 215, 0, 0.3)',
    // Enhanced borders
    borderLight: 'border-purple-200/60',
    borderMedium: 'border-purple-300/70',
    borderStrong: 'border-purple-400/80',
    // Filter states for light mode
    filterInactive: 'bg-white/80 border-purple-200/60 text-gray-600 hover:bg-white/90 hover:border-purple-300/70 hover:text-gray-700',
    filterActive: 'bg-gradient-to-r from-purple-600 to-purple-500 border-purple-400/50 text-white shadow-lg',
    filterHover: 'hover:bg-white/90 hover:border-purple-300/70',
    // Chat message colors for light mode
    senderBubble: 'bg-gradient-to-r from-purple-600 to-purple-500',
    receiverBubble: 'bg-white border border-purple-200/60',
    senderText: 'text-white',
    receiverText: 'text-gray-900'
  };

  const colors = isDarkMode ? darkColors : lightColors;

  return (
    <ThemeContext.Provider value={{ 
      isDarkMode, 
      toggleTheme, 
      colors, 
      accentColor, 
      setAccentColor: handleSetAccentColor,
      hapticFeedback,
      playSound
    }}>
      {children}
    </ThemeContext.Provider>
  );
};

export const useTheme = () => {
  const context = useContext(ThemeContext);
  if (context === undefined) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  return context;
};