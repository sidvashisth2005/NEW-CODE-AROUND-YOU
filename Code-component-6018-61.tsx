# Around You - Complete App Context & Specifications

## App Overview
**Around You** is a premium iOS AR social discovery app where users create, share, and discover "memories" anchored to real-world locations. Built with Flutter/Dart for cross-platform excellence.

## Design System

### Color Palette
- **Primary Royal Purple**: #6B1FB3
- **Secondary Lavender**: #C6B6E2  
- **Accent Gold**: #FFD700
- **Silver**: #C0C0C0
- **Pure Black**: #000000
- **Pure White**: #FFFFFF

### Design Principles
- **Apple Human Interface Guidelines** compliance
- **Glassmorphism** with enhanced blur effects
- **Neumorphism** styling throughout
- **SF Pro Typography** system
- **Premium micro-interactions** with haptic feedback
- **Spring animations** with proper easing curves
- **Particle effects** and ambient animations

### Theme System
```dart
// Light Mode
backgroundColor: Color(0xFFF8F7FF), // Purple-tinted white
cardBackground: Color(0xFFFFFFFF).withOpacity(0.95),
textPrimary: Color(0xFF1A1A1A),
textSecondary: Color(0xFF666666),

// Dark Mode  
backgroundColor: Color(0xFF0A0A0F), // Deep purple-black
cardBackground: Color(0xFF000000).withOpacity(0.4),
textPrimary: Color(0xFFFFFFFF),
textSecondary: Color(0xFFCCCCCC),
```

## Screen Architecture

### 1. Splash Screen
- **Duration**: 3-4 seconds with loading simulation
- **Particle System**: 20+ floating particles with physics
- **Logo Animation**: Scale + bounce with glow effect
- **Progress Bar**: Glassmorphic with shimmer animation
- **Loading Steps**: AR Engine → Memory Database → Network → Experience → Welcome

### 2. Onboarding Screen (3 Slides)
- **Slide 1**: Discover - AR memories around you
- **Slide 2**: Create - Leave memories for others  
- **Slide 3**: Connect - Join trails and communities
- **Navigation**: Dots indicator + swipe gestures
- **Skip/Next**: Smooth transitions with haptics

### 3. Login Screen
- **Apple Sign In**: Primary authentication
- **Google Sign In**: Secondary option
- **Guest Mode**: Limited functionality access
- **Form Validation**: Real-time with smooth error states
- **Biometric**: Face ID/Touch ID integration

### 4. Home Screen (AR Camera)
- **Live Camera Feed**: AR overlay system
- **Memory Detection**: Floating memory indicators
- **Scanning Mode**: Toggle with crosshair overlay
- **Pull-to-Refresh**: Custom physics with haptic feedback
- **Create Button**: Golden floating action button
- **Status Bar**: Location + scan count

### 5. Around Screen (Map View)
- **Interactive Map**: Custom styled with glassmorphic controls
- **Memory Pins**: Animated with distance badges
- **Filter System**: All/Photos/Videos/Audio/Recent
- **Search Radius**: Slider control (100m - 1km)
- **Clustering**: Smart grouping for performance
- **Location Services**: Real-time GPS with accuracy indicator

### 6. Chat Screen
- **Chat List**: Glassmorphic cards with online indicators
- **Filter Tabs**: All/Recent/Groups/Favorites
- **Search Bar**: Real-time filtering
- **Unread Badges**: Animated count indicators
- **Action Buttons**: Video/Voice call, Settings per chat
- **Communities Button**: Access to public groups

### 7. Chat Interface
- **Message Bubbles**: Gradient sender, glass receiver
- **Typing Indicators**: Animated dots
- **Media Support**: Images, videos, voice notes, locations
- **Message States**: Sent/Delivered/Read with icons
- **Keyboard Handling**: Smart resize with animation
- **Pull-to-Load**: Historical messages

### 8. Trails Screen
- **Trail Cards**: Large glassmorphic with metrics
- **Difficulty Badges**: Color-coded (Easy/Medium/Hard)
- **Creator Info**: Avatar + name + rating
- **Filter System**: All/Recent/Popular/Featured
- **Progress Tracking**: Visual completion indicators
- **Create Trail Button**: Purple floating action

### 9. Trail Detail Screen
- **Hero Header**: Large image with overlay controls
- **Trail Info**: Duration, difficulty, memories count
- **Memory List**: Checkpoint-style with connecting lines
- **Progress Bar**: Animated completion status
- **Action Buttons**: Start/Continue/Share/Save
- **Reviews Section**: User ratings and comments

### 10. Profile Screen
- **User Avatar**: Large circular with edit overlay
- **Stats Grid**: Memories/Trails/Followers/Following
- **Streak Counter**: Fire icon with days count
- **Achievement Badges**: Unlocked accomplishments grid
- **Settings Access**: Gear icon top-right
- **Activity Feed**: Recent interactions

### 11. Create Memory Screen
- **Media Capture**: Camera/Gallery/Video/Audio modes
- **Location Picker**: Map with precise positioning
- **Memory Types**: Photo/Video/Audio/Text/Mixed media
- **Privacy Settings**: Public/Friends/Private visibility
- **Tags System**: Searchable hashtags
- **Preview Mode**: Full preview before posting

### 12. Memory Detail Screen
- **Media Viewer**: Full-screen with zoom/pan
- **Interaction Bar**: Like/Comment/Share/Save buttons
- **Comments Thread**: Nested replies support
- **Location Info**: Distance and direction from user
- **Creator Profile**: Quick access to user profile
- **Related Memories**: Nearby or similar content

### 13. Settings Screen
- **Profile Settings**: Avatar, name, bio editing
- **Privacy Controls**: Who can see/message/tag you
- **Notification Settings**: Granular control per type
- **Theme Toggle**: Light/Dark with smooth transition
- **Accent Colors**: Purple variants selection
- **Data Management**: Cache clearing, storage info
- **Account Actions**: Sign out, delete account

### 14. Notifications Screen
- **Notification Types**: Likes/Comments/Follows/Memory discoveries
- **Grouping**: Smart grouping by type and time
- **Action Buttons**: Accept/Decline for follow requests
- **Mark as Read**: Swipe gestures or bulk actions
- **Filter Options**: All/Unread/Mentions
- **Clear All**: Confirmation dialog

### 15. Admin Dashboard (Admin accounts only)
- **User Analytics**: Registration trends, active users
- **Memory Statistics**: Upload rates, popular types
- **Content Moderation**: Flagged content review
- **System Health**: App performance metrics
- **Revenue Analytics**: Premium subscriptions, usage
- **Geographic Distribution**: User location heatmaps

## Technical Features

### Navigation System
```dart
// Route management with smooth transitions
class AppRouter {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const home = '/home';
  static const around = '/around';
  static const chat = '/chat';
  static const trails = '/trails';
  static const profile = '/profile';
  // ... sub-routes
}
```

### State Management
- **Provider Pattern**: Theme, Auth, User, Memory state
- **Local Storage**: Preferences, cache, offline data
- **Network State**: Connection status, sync queue
- **Location State**: GPS, permissions, accuracy

### Animations & Interactions
- **Page Transitions**: Slide, fade, scale with physics
- **Micro-interactions**: Button taps, card hovers, swipes
- **Particle Systems**: Splash screen, success states
- **Haptic Feedback**: Light/Medium/Heavy for different actions
- **Sound Design**: Tap, success, error audio cues

### Premium Features
- **Glassmorphism**: Advanced blur effects with proper shadows
- **Spring Animations**: Natural motion with bounce
- **Particle Effects**: Floating elements, success celebrations
- **Haptic Feedback**: iOS-style vibration patterns
- **Sound Design**: Procedural audio generation
- **Theme Customization**: Multiple accent color options

### Data Models
```dart
class Memory {
  String id;
  String userId;
  MemoryType type; // photo, video, audio, text
  String content;
  GeoPoint location;
  DateTime createdAt;
  List<String> tags;
  PrivacyLevel privacy;
  int likes;
  List<Comment> comments;
}

class Trail {
  String id;
  String title;
  String description;
  String creatorId;
  List<String> memoryIds;
  Difficulty difficulty;
  Duration estimatedTime;
  int participants;
  double rating;
}

class User {
  String id;
  String name;
  String email;
  String? avatarUrl;
  UserStats stats;
  PrivacySettings privacy;
  List<String> followers;
  List<String> following;
}
```

### Backend Integration
- **Authentication**: Firebase Auth (Apple, Google, Guest)
- **Database**: Firestore for real-time data
- **Storage**: Firebase Storage for media files
- **Push Notifications**: FCM for engagement
- **Analytics**: Firebase Analytics + Custom metrics
- **Crash Reporting**: Firebase Crashlytics

### Performance Optimizations
- **Image Caching**: Efficient memory management
- **List Virtualization**: Smooth scrolling for large datasets
- **Network Batching**: Reduce API calls
- **Offline Support**: Local-first architecture
- **Background Sync**: Queue operations when offline

## UI Component Library

### Glass Container
```dart
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color backgroundColor;
  final Border? border;
  
  // Glassmorphic container with backdrop blur
}
```

### Floating Action Button
```dart
class FloatingCreateButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color gradientStart;
  final Color gradientEnd;
  final IconData icon;
  
  // Animated FAB with pulse effect
}
```

### Bottom Navigation
```dart
class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavigationItem> items;
  
  // Glassmorphic nav with smooth active indicators
}
```

This context file contains everything needed to regenerate the entire Around You app with pixel-perfect Flutter implementation. Every screen, animation, color, and interaction is specified in detail.