import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class Helpers {
  // Private constructor to prevent instantiation
  Helpers._();
  
  /// Format timestamp to human readable string
  static String formatTimestamp(DateTime timestamp, {bool includeTime = false}) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).round();
      return '${weeks}w ago';
    } else {
      if (includeTime) {
        return DateFormat('MMM d, yyyy \'at\' h:mm a').format(timestamp);
      } else {
        return DateFormat('MMM d, yyyy').format(timestamp);
      }
    }
  }
  
  /// Format date for display
  static String formatDate(DateTime date, {String? format}) {
    format ??= 'MMM d, yyyy';
    return DateFormat(format).format(date);
  }
  
  /// Format time for display
  static String formatTime(DateTime time, {bool use24Hour = false}) {
    final format = use24Hour ? 'HH:mm' : 'h:mm a';
    return DateFormat(format).format(time);
  }
  
  /// Format duration to human readable string
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
  
  /// Format file size to human readable string
  static String formatFileSize(int sizeInBytes) {
    if (sizeInBytes < 1024) {
      return '${sizeInBytes}B';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)}KB';
    } else if (sizeInBytes < 1024 * 1024 * 1024) {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    } else {
      return '${(sizeInBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    }
  }
  
  /// Format number with commas
  static String formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }
  
  /// Format currency
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return '$symbol${NumberFormat('#,##0.00').format(amount)}';
  }
  
  /// Generate random string
  static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = math.Random();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }
  
  /// Generate random color
  static Color generateRandomColor() {
    final random = math.Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
  
  /// Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  /// Validate phone number
  static bool isValidPhoneNumber(String phone) {
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(phone);
  }
  
  /// Validate URL
  static bool isValidUrl(String url) {
    return RegExp(r'^https?:\/\/.+').hasMatch(url);
  }
  
  /// Generate gradient colors
  static List<Color> generateGradient(Color baseColor, {int steps = 3}) {
    final colors = <Color>[];
    final hsl = HSLColor.fromColor(baseColor);
    
    for (int i = 0; i < steps; i++) {
      final lightness = math.max(0.0, math.min(1.0, hsl.lightness + (i * 0.1) - 0.1));
      colors.add(hsl.withLightness(lightness).toColor());
    }
    
    return colors;
  }
  
  /// Get contrast color (black or white) for given background color
  static Color getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
  
  /// Darken color by percentage
  static Color darkenColor(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDarkened = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDarkened.toColor();
  }
  
  /// Lighten color by percentage
  static Color lightenColor(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLightened = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLightened.toColor();
  }
  
  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength, {String ellipsis = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - ellipsis.length)}$ellipsis';
  }
  
  /// Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  /// Convert camelCase to Title Case
  static String camelCaseToTitle(String camelCase) {
    return camelCase
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .trim()
        .split(' ')
        .map((word) => capitalize(word))
        .join(' ');
  }
  
  /// Remove HTML tags from string
  static String stripHtmlTags(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }
  
  /// Get initials from name
  static String getInitials(String name, {int maxChars = 2}) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '';
    
    if (words.length == 1) {
      return words[0].substring(0, math.min(maxChars, words[0].length)).toUpperCase();
    }
    
    String initials = '';
    for (int i = 0; i < math.min(words.length, maxChars); i++) {
      if (words[i].isNotEmpty) {
        initials += words[i][0].toUpperCase();
      }
    }
    
    return initials;
  }
  
  /// Debounce function calls
  static Timer? _debounceTimer;
  static void debounce(Duration delay, VoidCallback callback) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, callback);
  }
  
  /// Throttle function calls
  static DateTime? _lastThrottleTime;
  static void throttle(Duration delay, VoidCallback callback) {
    final now = DateTime.now();
    if (_lastThrottleTime == null || now.difference(_lastThrottleTime!) >= delay) {
      _lastThrottleTime = now;
      callback();
    }
  }
  
  /// Show snackbar with custom styling
  static void showSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    VoidCallback? action,
    String? actionLabel,
  }) {
    final theme = Theme.of(context);
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor ?? Colors.white),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor ?? Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor ?? theme.primaryColor,
      duration: duration,
      action: action != null && actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: textColor ?? Colors.white,
              onPressed: action,
            )
          : null,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
  /// Show loading dialog
  static void showLoadingDialog(
    BuildContext context, {
    String message = 'Loading...',
    bool barrierDismissible = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
  
  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
  
  /// Calculate reading time for text
  static int calculateReadingTime(String text, {int wordsPerMinute = 200}) {
    final wordCount = text.split(' ').length;
    final minutes = (wordCount / wordsPerMinute).ceil();
    return math.max(1, minutes);
  }
  
  /// Generate Lorem Ipsum text
  static String generateLoremIpsum(int wordCount) {
    const words = [
      'lorem', 'ipsum', 'dolor', 'sit', 'amet', 'consectetur', 'adipiscing', 'elit',
      'sed', 'do', 'eiusmod', 'tempor', 'incididunt', 'ut', 'labore', 'et', 'dolore',
      'magna', 'aliqua', 'enim', 'ad', 'minim', 'veniam', 'quis', 'nostrud',
      'exercitation', 'ullamco', 'laboris', 'nisi', 'aliquip', 'ex', 'ea', 'commodo',
      'consequat', 'duis', 'aute', 'irure', 'in', 'reprehenderit', 'voluptate',
      'velit', 'esse', 'cillum', 'fugiat', 'nulla', 'pariatur', 'excepteur',
      'sint', 'occaecat', 'cupidatat', 'non', 'proident', 'sunt', 'culpa', 'qui',
      'officia', 'deserunt', 'mollit', 'anim', 'id', 'est', 'laborum'
    ];
    
    final random = math.Random();
    final selectedWords = <String>[];
    
    for (int i = 0; i < wordCount; i++) {
      selectedWords.add(words[random.nextInt(words.length)]);
    }
    
    return selectedWords.join(' ');
  }
  
  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 768;
  }
  
  /// Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }
  
  /// Get status bar height
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }
  
  /// Get bottom safe area height
  static double getBottomSafeAreaHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }
  
  /// Linear interpolation between two values
  static double lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }
  
  /// Map value from one range to another
  static double mapRange(double value, double inMin, double inMax, double outMin, double outMax) {
    return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
  }
  
  /// Clamp value between min and max
  static double clamp(double value, double min, double max) {
    return math.min(math.max(value, min), max);
  }
}

/// Timer extension for debouncing
class Timer {
  Timer._(this._timer);
  
  final dynamic _timer;
  
  static Timer periodic(Duration duration, void Function(Timer) callback) {
    return Timer._(
      // This would be implemented with actual timer functionality
      null,
    );
  }
  
  void cancel() {
    // Cancel timer implementation
  }
}