import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Mail, Lock, Eye, EyeOff, ArrowRight, Apple, MessageSquare, User } from 'lucide-react';
import Logo from './Logo';
import { useTheme } from './ThemeContext';

interface LoginScreenProps {
  onComplete: () => void;
}

const LoginScreen: React.FC<LoginScreenProps> = ({ onComplete }) => {
  const { colors, isDarkMode, hapticFeedback, playSound } = useTheme();
  const [isLogin, setIsLogin] = useState(true);
  const [showPassword, setShowPassword] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    hapticFeedback && hapticFeedback('medium');
    playSound && playSound('tap');
    
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 1200));
    
    setIsLoading(false);
    playSound && playSound('success');
    onComplete();
  };

  const handleSocialLogin = async (provider: string) => {
    setIsLoading(true);
    hapticFeedback && hapticFeedback('light');
    playSound && playSound('tap');
    
    // Simulate social login
    await new Promise(resolve => setTimeout(resolve, 800));
    
    setIsLoading(false);
    playSound && playSound('success');
    onComplete();
  };

  const handleTabSwitch = (loginState: boolean) => {
    setIsLogin(loginState);
    hapticFeedback && hapticFeedback('light');
    playSound && playSound('tap');
  };

  const GoogleIcon = () => (
    <svg width="20" height="20" viewBox="0 0 24 24" className="text-current">
      <path fill="currentColor" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
      <path fill="currentColor" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
      <path fill="currentColor" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
      <path fill="currentColor" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
    </svg>
  );

  return (
    <div className={`h-full w-full bg-gradient-to-br ${colors.background} relative overflow-hidden`}>
      {/* Background Elements */}
      <div className="absolute inset-0">
        <motion.div 
          animate={{
            scale: [1, 1.1, 1],
            opacity: [0.3, 0.5, 0.3],
          }}
          transition={{
            duration: 8,
            repeat: Infinity,
            ease: "easeInOut"
          }}
          className="absolute top-1/4 left-1/4 w-32 h-32 bg-purple-500/20 rounded-full blur-xl" 
        />
        <motion.div 
          animate={{
            scale: [1.1, 1, 1.1],
            opacity: [0.4, 0.6, 0.4],
          }}
          transition={{
            duration: 6,
            repeat: Infinity,
            ease: "easeInOut",
            delay: 2
          }}
          className="absolute top-1/2 right-1/4 w-24 h-24 bg-blue-500/20 rounded-full blur-xl" 
        />
        <motion.div 
          animate={{
            scale: [1, 1.2, 1],
            opacity: [0.2, 0.4, 0.2],
          }}
          transition={{
            duration: 10,
            repeat: Infinity,
            ease: "easeInOut",
            delay: 1
          }}
          className="absolute bottom-1/4 left-1/3 w-40 h-40 bg-indigo-500/20 rounded-full blur-xl" 
        />
      </div>

      <div className="relative z-10 h-full flex flex-col items-center justify-center p-6">
        {/* Logo Section */}
        <motion.div
          initial={{ opacity: 0, y: -30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, ease: "easeOut" }}
          className="text-center mb-8"
        >
          {/* Custom Logo */}
          <motion.div
            initial={{ scale: 0.8, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ delay: 0.2, duration: 0.8, ease: "easeOut" }}
            className="mb-6"
          >
            <Logo size={90} animated={true} className="mx-auto" />
          </motion.div>
          
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4, duration: 0.6 }}
          >
            <h1 className={`text-3xl font-bold mb-2 ${colors.textPrimary}`}>Around You</h1>
            <p className={colors.accent}>Discover memories around you</p>
          </motion.div>
        </motion.div>

        {/* Main Form Card */}
        <motion.div
          initial={{ opacity: 0, y: 30, scale: 0.95 }}
          animate={{ opacity: 1, y: 0, scale: 1 }}
          transition={{ duration: 0.6, delay: 0.1 }}
          className="w-full max-w-sm"
        >
          <div 
            className={`glass-card rounded-[24px] p-6 backdrop-blur-xl border ${colors.borderMedium}`}
            style={{ 
              background: colors.glassBackground,
              boxShadow: colors.shadowLg
            }}
          >
            {/* Tab Switcher - Matching Navigation Style */}
            <div 
              className={`glass-nav rounded-[16px] p-1 mb-6 border ${colors.borderLight}`}
              style={{ 
                background: colors.glassBackground
              }}
            >
              <div className="flex relative">
                {/* Login Tab */}
                <button
                  onClick={() => handleTabSwitch(true)}
                  className={`relative flex-1 py-2.5 text-center font-semibold rounded-[12px] transition-all duration-300 ${
                    isLogin ? 'text-white' : colors.textSecondary
                  }`}
                >
                  {/* Active Background - Only shows when this tab is active */}
                  {isLogin && (
                    <motion.div
                      layoutId="activeLoginTab"
                      className="absolute inset-0 bg-gradient-to-r from-purple-600 to-purple-500 rounded-[12px]"
                      style={{ 
                        boxShadow: colors.shadowPurple
                      }}
                      transition={{ 
                        type: "spring", 
                        bounce: 0.2, 
                        duration: 0.5 
                      }}
                    />
                  )}
                  <span className="relative z-10">Login</span>
                </button>
                
                {/* Sign Up Tab */}
                <button
                  onClick={() => handleTabSwitch(false)}
                  className={`relative flex-1 py-2.5 text-center font-semibold rounded-[12px] transition-all duration-300 ${
                    !isLogin ? 'text-white' : colors.textSecondary
                  }`}
                >
                  {/* Active Background - Only shows when this tab is active */}
                  {!isLogin && (
                    <motion.div
                      layoutId="activeLoginTab"
                      className="absolute inset-0 bg-gradient-to-r from-purple-600 to-purple-500 rounded-[12px]"
                      style={{ 
                        boxShadow: colors.shadowPurple
                      }}
                      transition={{ 
                        type: "spring", 
                        bounce: 0.2, 
                        duration: 0.5 
                      }}
                    />
                  )}
                  <span className="relative z-10">Sign Up</span>
                </button>
              </div>
            </div>

            {/* Form */}
            <form onSubmit={handleSubmit} className="space-y-4">
              {/* Name Field - Only for Sign Up */}
              <AnimatePresence>
                {!isLogin && (
                  <motion.div
                    initial={{ opacity: 0, height: 0, y: -10 }}
                    animate={{ opacity: 1, height: 'auto', y: 0 }}
                    exit={{ opacity: 0, height: 0, y: -10 }}
                    transition={{ duration: 0.3, ease: "easeOut" }}
                    className="relative overflow-hidden"
                  >
                    <div className="absolute left-4 top-1/2 transform -translate-y-1/2 z-10">
                      <User size={18} className={colors.textSecondary} />
                    </div>
                    <input
                      type="text"
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                      placeholder="Full Name"
                      className={`w-full pl-11 pr-4 py-3.5 border ${colors.borderMedium} rounded-[16px] focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all duration-200 backdrop-blur-sm placeholder:${colors.textSecondary}`}
                      style={{ 
                        background: colors.glassBackground,
                        color: colors.textPrimary
                      }}
                      required={!isLogin}
                    />
                  </motion.div>
                )}
              </AnimatePresence>

              {/* Email Field */}
              <motion.div
                initial={{ opacity: 0, x: -10 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.2, duration: 0.4 }}
                className="relative"
              >
                <div className="absolute left-4 top-1/2 transform -translate-y-1/2 z-10">
                  <Mail size={18} className={colors.textSecondary} />
                </div>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="Email"
                  className={`w-full pl-11 pr-4 py-3.5 border ${colors.borderMedium} rounded-[16px] focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all duration-200 backdrop-blur-sm placeholder:${colors.textSecondary}`}
                  style={{ 
                    background: colors.glassBackground,
                    color: colors.textPrimary
                  }}
                  required
                />
              </motion.div>

              {/* Password Field */}
              <motion.div
                initial={{ opacity: 0, x: -10 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.3, duration: 0.4 }}
                className="relative"
              >
                <div className="absolute left-4 top-1/2 transform -translate-y-1/2 z-10">
                  <Lock size={18} className={colors.textSecondary} />
                </div>
                <input
                  type={showPassword ? "text" : "password"}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="Password"
                  className={`w-full pl-11 pr-11 py-3.5 border ${colors.borderMedium} rounded-[16px] focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all duration-200 backdrop-blur-sm placeholder:${colors.textSecondary}`}
                  style={{ 
                    background: colors.glassBackground,
                    color: colors.textPrimary
                  }}
                  required
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className={`absolute right-4 top-1/2 transform -translate-y-1/2 z-10 transition-colors duration-200 hover:${colors.textPrimary}`}
                >
                  {showPassword ? (
                    <EyeOff size={18} className={colors.textSecondary} />
                  ) : (
                    <Eye size={18} className={colors.textSecondary} />
                  )}
                </button>
              </motion.div>

              {/* Submit Button */}
              <motion.button
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.4, duration: 0.4 }}
                whileTap={{ scale: 0.98 }}
                whileHover={{ scale: 1.02 }}
                type="submit"
                disabled={isLoading}
                className="w-full bg-gradient-to-r from-purple-600 to-purple-500 py-3.5 rounded-[16px] text-white font-semibold flex items-center justify-center space-x-2 transition-all duration-200 disabled:opacity-70"
                style={{ 
                  boxShadow: colors.shadowPurple
                }}
              >
                {isLoading ? (
                  <motion.div
                    animate={{ rotate: 360 }}
                    transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
                    className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full"
                  />
                ) : (
                  <>
                    <span>{isLogin ? 'Login' : 'Create Account'}</span>
                    <ArrowRight size={18} />
                  </>
                )}
              </motion.button>
            </form>

            {/* Divider */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.5, duration: 0.4 }}
              className="flex items-center my-5"
            >
              <div 
                className="flex-1 h-px"
                style={{ 
                  background: isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(107, 31, 179, 0.2)'
                }}
              ></div>
              <span className={`px-3 text-sm ${colors.textSecondary}`}>or</span>
              <div 
                className="flex-1 h-px"
                style={{ 
                  background: isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(107, 31, 179, 0.2)'
                }}
              ></div>
            </motion.div>

            {/* Social Login Buttons */}
            <div className="space-y-3">
              <motion.button
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.6, duration: 0.4 }}
                whileTap={{ scale: 0.98 }}
                whileHover={{ scale: 1.02 }}
                onClick={() => handleSocialLogin('apple')}
                disabled={isLoading}
                className={`w-full glass-card py-3.5 rounded-[16px] ${colors.textPrimary} font-semibold flex items-center justify-center space-x-3 backdrop-blur-md border ${colors.borderMedium} transition-all duration-200 disabled:opacity-70`}
                style={{ 
                  background: colors.glassBackground,
                  boxShadow: colors.shadowSm
                }}
              >
                <Apple size={18} />
                <span>Continue with Apple</span>
              </motion.button>

              <motion.button
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.7, duration: 0.4 }}
                whileTap={{ scale: 0.98 }}
                whileHover={{ scale: 1.02 }}
                onClick={() => handleSocialLogin('google')}
                disabled={isLoading}
                className={`w-full glass-card py-3.5 rounded-[16px] ${colors.textPrimary} font-semibold flex items-center justify-center space-x-3 backdrop-blur-md border ${colors.borderMedium} transition-all duration-200 disabled:opacity-70`}
                style={{ 
                  background: colors.glassBackground,
                  boxShadow: colors.shadowSm
                }}
              >
                <GoogleIcon />
                <span>Continue with Google</span>
              </motion.button>
            </div>
          </div>
        </motion.div>

        {/* Footer */}
        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.8, duration: 0.4 }}
          className={`text-sm text-center mt-6 max-w-xs leading-relaxed ${colors.textSecondary}`}
        >
          By continuing, you agree to our Terms of Service and Privacy Policy
        </motion.p>
      </div>
    </div>
  );
};

export default LoginScreen;