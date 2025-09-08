# Around You - Premium iOS AR Social Discovery App

A premium Flutter application where users create, share, and discover "memories" anchored to real-world locations using AR technology.

## 🚀 Features

- **AR Camera Experience**: Live camera feed with AR memory overlays
- **Location-Based Memories**: Create and discover memories tied to real-world locations  
- **Premium UI**: Apple Human Interface Guidelines compliant design
- **Glassmorphism Design**: Advanced blur effects and premium styling
- **Social Features**: Chat, trails, communities, and user profiles
- **Admin Dashboard**: Comprehensive analytics and content moderation
- **Dark/Light Themes**: Seamless theme switching with haptic feedback

## 🎨 Design System

- **Color Palette**: Royal Purple (#6B1FB3) and Lavender (#C6B6E2)
- **Typography**: SF Pro Display font family
- **Animations**: Spring-based micro-interactions with haptic feedback
- **Shadows**: Premium shadow system for depth and elevation

## 🛠 Tech Stack

- **Framework**: Flutter 3.10+
- **Language**: Dart 3.0+
- **State Management**: Provider
- **Backend**: Firebase (Auth, Firestore, Storage, Analytics)
- **Maps**: Google Maps Flutter
- **Camera**: Camera plugin with AR capabilities
- **Authentication**: Apple Sign In, Google Sign In

## 📱 Screens

1. **Splash Screen**: Animated loading with particle effects
2. **Onboarding**: 3-slide introduction to app features
3. **Login**: Apple/Google authentication
4. **Home**: AR camera interface
5. **Around**: Map view of nearby memories
6. **Chat**: Messaging and communities
7. **Trails**: Curated memory experiences
8. **Profile**: User stats and achievements
9. **Settings**: Comprehensive app configuration
10. **Admin Dashboard**: Analytics and moderation tools

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10 or higher
- Dart SDK 3.0 or higher
- iOS 14.0+ / Android API 21+
- Xcode (for iOS development)
- Android Studio (for Android development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd around-you
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a new Firebase project
   - Add iOS and Android apps to your Firebase project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in their respective platform directories

4. **Configure Maps**
   - Get Google Maps API key
   - Add to `android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.swift`

5. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── core/                     # Core utilities and services
│   ├── constants/           # App constants and design tokens
│   ├── services/           # Location, storage services
│   └── utils/              # Helper functions and logger
├── models/                  # Data models and providers
├── screens/                 # All app screens
├── theme/                   # Theme configuration
└── widgets/                 # Reusable UI components
```

## 🎯 Key Features Implementation

### Glassmorphism Effects
```dart
Container(
  decoration: BoxDecoration(
    color: AppConstants.lightGlassBackground,
    borderRadius: BorderRadius.circular(AppConstants.radiusL),
    border: Border.all(color: AppConstants.lightGlassBorder),
    boxShadow: AppConstants.shadowMd,
  ),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
    child: child,
  ),
)
```

### Spring Animations
```dart
AnimatedContainer(
  duration: AppConstants.animationMedium,
  curve: Curves.elasticOut,
  transform: Matrix4.identity()..scale(isPressed ? 0.95 : 1.0),
  child: child,
)
```

### Haptic Feedback
```dart
void handleTap() {
  HapticFeedback.lightImpact();
  SystemSound.play(SystemSoundType.click);
  // Handle action
}
```

## 🔧 Configuration

### Theme Customization
Customize colors, shadows, and spacing in `/lib/core/constants/app_constants.dart`

### Firebase Setup
Configure Firebase services in `/lib/core/services/`

### Maps Integration
Set up Google Maps API keys for location services

## 📊 Analytics

The app includes comprehensive analytics:
- User engagement metrics
- Memory creation/interaction statistics  
- Location-based insights
- Performance monitoring
- Crash reporting

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 📦 Building

### iOS
```bash
flutter build ios --release
```

### Android
```bash
flutter build apk --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Check the comprehensive context file: `AROUND_YOU_CONTEXT.md`

---

**Built with ❤️ using Flutter & Dart**