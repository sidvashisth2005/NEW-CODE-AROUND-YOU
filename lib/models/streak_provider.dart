import 'package:flutter/material.dart';

class StreakProvider extends ChangeNotifier {
  final Map<String, int> _streaks = {
    'sarah-chen': 5,
    'mike-johnson': 12,
    'alex-rivera': 3,
    'emma-watson': 8,
  };
  
  Map<String, int> get streaks => Map.unmodifiable(_streaks);
  
  int getStreak(String userId) {
    return _streaks[userId] ?? 0;
  }
  
  void updateStreak(String userId) {
    _streaks[userId] = (_streaks[userId] ?? 0) + 1;
    notifyListeners();
  }
  
  int getTotalStreaks() {
    return _streaks.values.reduce((a, b) => a + b);
  }
  
  void resetStreak(String userId) {
    _streaks[userId] = 0;
    notifyListeners();
  }
  
  List<MapEntry<String, int>> getTopStreaks({int limit = 10}) {
    final entries = _streaks.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(limit).toList();
  }
}