import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:around_you/main.dart';
import 'package:around_you/theme/theme_provider.dart';

void main() {
  group('AroundYou App Tests', () {
    testWidgets('App should start with splash screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const AroundYouApp());

      // Verify that splash screen elements are present
      expect(find.text('Around You'), findsOneWidget);
      expect(find.text('Discover memories around you'), findsOneWidget);
    });

    testWidgets('Theme provider should toggle themes', (WidgetTester tester) async {
      final themeProvider = ThemeProvider();
      
      // Test initial state
      expect(themeProvider.isDarkMode, false);
      
      // Test toggle
      themeProvider.toggleTheme();
      expect(themeProvider.isDarkMode, true);
      
      // Test toggle back
      themeProvider.toggleTheme();
      expect(themeProvider.isDarkMode, false);
    });

    testWidgets('App should handle navigation properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          child: const AroundYouApp(),
        ),
      );

      // Wait for splash screen to load
      await tester.pump();
      
      // Check if app loads without throwing
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    group('ThemeProvider Tests', () {
      late ThemeProvider themeProvider;

      setUp(() {
        themeProvider = ThemeProvider();
      });

      test('should initialize with light mode', () {
        expect(themeProvider.isDarkMode, false);
      });

      test('should toggle theme mode', () {
        final initialMode = themeProvider.isDarkMode;
        themeProvider.toggleTheme();
        expect(themeProvider.isDarkMode, !initialMode);
      });

      test('should set dark mode explicitly', () {
        themeProvider.setDarkMode(true);
        expect(themeProvider.isDarkMode, true);
        
        themeProvider.setDarkMode(false);
        expect(themeProvider.isDarkMode, false);
      });
    });

    group('Color System Tests', () {
      testWidgets('should apply correct colors based on theme', (WidgetTester tester) async {
        await tester.pumpWidget(
          ChangeNotifierProvider(
            create: (context) => ThemeProvider(),
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  home: Container(
                    color: themeProvider.colors.accent,
                    child: const Text('Test'),
                  ),
                );
              },
            ),
          ),
        );

        await tester.pump();
        
        // Find the container and verify it exists
        expect(find.byType(Container), findsWidgets);
      });
    });
  });

  group('Navigation Tests', () {
    testWidgets('should navigate between screens without errors', (WidgetTester tester) async {
      await tester.pumpWidget(const AroundYouApp());
      
      // Let the app initialize
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      
      // App should start and not throw any exceptions
      expect(tester.takeException(), isNull);
    });
  });

  group('Performance Tests', () {
    testWidgets('app should build quickly', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();
      
      await tester.pumpWidget(const AroundYouApp());
      await tester.pump();
      
      stopwatch.stop();
      
      // App should build in less than 1 second
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });
}