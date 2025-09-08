import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';

class StorageService {
  static StorageService? _instance;
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );
  
  late SharedPreferences _prefs;
  
  StorageService._();
  
  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._();
      await _instance!._init();
    }
    return _instance!;
  }
  
  Future<void> _init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      Logger.info('StorageService initialized successfully');
    } catch (e, stackTrace) {
      Logger.error('Failed to initialize StorageService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  // Basic string operations
  Future<bool> setString(String key, String value) async {
    try {
      final result = await _prefs.setString(key, value);
      Logger.debug('Stored string value for key: $key');
      return result;
    } catch (e, stackTrace) {
      Logger.error('Failed to store string for key: $key', error: e, stackTrace: stackTrace);
      return false;
    }
  }
  
  String? getString(String key, {String? defaultValue}) {
    try {
      return _prefs.getString(key) ?? defaultValue;
    } catch (e, stackTrace) {
      Logger.error('Failed to get string for key: $key', error: e, stackTrace: stackTrace);
      return defaultValue;
    }
  }
  
  // Basic bool operations
  Future<bool> setBool(String key, bool value) async {
    try {
      final result = await _prefs.setBool(key, value);
      Logger.debug('Stored bool value for key: $key');
      return result;
    } catch (e, stackTrace) {
      Logger.error('Failed to store bool for key: $key', error: e, stackTrace: stackTrace);
      return false;
    }
  }
  
  bool getBool(String key, {bool defaultValue = false}) {
    try {
      return _prefs.getBool(key) ?? defaultValue;
    } catch (e, stackTrace) {
      Logger.error('Failed to get bool for key: $key', error: e, stackTrace: stackTrace);
      return defaultValue;
    }
  }
  
  // Basic int operations
  Future<bool> setInt(String key, int value) async {
    try {
      final result = await _prefs.setInt(key, value);
      Logger.debug('Stored int value for key: $key');
      return result;
    } catch (e, stackTrace) {
      Logger.error('Failed to store int for key: $key', error: e, stackTrace: stackTrace);
      return false;
    }
  }
  
  int getInt(String key, {int defaultValue = 0}) {
    try {
      return _prefs.getInt(key) ?? defaultValue;
    } catch (e, stackTrace) {
      Logger.error('Failed to get int for key: $key', error: e, stackTrace: stackTrace);
      return defaultValue;
    }
  }
  
  // Basic double operations
  Future<bool> setDouble(String key, double value) async {
    try {
      final result = await _prefs.setDouble(key, value);
      Logger.debug('Stored double value for key: $key');
      return result;
    } catch (e, stackTrace) {
      Logger.error('Failed to store double for key: $key', error: e, stackTrace: stackTrace);
      return false;
    }
  }
  
  double getDouble(String key, {double defaultValue = 0.0}) {
    try {
      return _prefs.getDouble(key) ?? defaultValue;
    } catch (e, stackTrace) {
      Logger.error('Failed to get double for key: $key', error: e, stackTrace: stackTrace);
      return defaultValue;
    }
  }
  
  // JSON operations
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      final result = await _prefs.setString(key, jsonString);
      Logger.debug('Stored JSON value for key: $key');
      return result;
    } catch (e, stackTrace) {
      Logger.error('Failed to store JSON for key: $key', error: e, stackTrace: stackTrace);
      return false;
    }
  }
  
  Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e, stackTrace) {
      Logger.error('Failed to get JSON for key: $key', error: e, stackTrace: stackTrace);
      return null;
    }
  }
  
  // List operations
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      final result = await _prefs.setStringList(key, value);
      Logger.debug('Stored string list for key: $key');
      return result;
    } catch (e, stackTrace) {
      Logger.error('Failed to store string list for key: $key', error: e, stackTrace: stackTrace);
      return false;
    }
  }
  
  List<String> getStringList(String key, {List<String>? defaultValue}) {
    try {
      return _prefs.getStringList(key) ?? defaultValue ?? [];
    } catch (e, stackTrace) {
      Logger.error('Failed to get string list for key: $key', error: e, stackTrace: stackTrace);
      return defaultValue ?? [];
    }
  }
  
  // Secure storage operations (for sensitive data)
  Future<bool> setSecureString(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
      Logger.debug('Stored secure string for key: $key');
      return true;
    } catch (e, stackTrace) {
      Logger.error('Failed to store secure string for key: $key', error: e, stackTrace: stackTrace);
      return false;
    }
  }
  
  Future<String?> getSecureString(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e, stackTrace) {
      Logger.error('Failed to get secure string for key: $key', error: e, stackTrace: stackTrace);
      return null;
    }
  }
  
  Future<bool> deleteSecureString(String key) async {
    try {
      await _secureStorage.delete(key: key);
      Logger.debug('Deleted secure string for key: $key');
      return true;
    } catch (e, stackTrace) {
      Logger.error('Failed to delete secure string for key: $key', error: e, stackTrace: stackTrace);
      return false;
    }
  }
  
  // Remove operations
  Future<bool> remove(String key) async {
    try {
      final result = await _prefs.remove(key);
      Logger.debug('Removed value for key: $key');
      return result;
    } catch (e, stackTrace) {
      Logger.error('Failed to remove key: $key', error: e, stackTrace: stackTrace);
      return false;
    }
  }
  
  Future<bool> clear() async {
    try {
      final result = await _prefs.clear();
      await _secureStorage.deleteAll();
      Logger.warning('Cleared all storage data');
      return result;
    } catch (e, stackTrace) {
      Logger.error('Failed to clear storage', error: e, stackTrace: stackTrace);
      return false;
    }
  }
  
  // Check if key exists
  bool containsKey(String key) {
    try {
      return _prefs.containsKey(key);
    } catch (e, stackTrace) {
      Logger.error('Failed to check if key exists: $key', error: e, stackTrace: stackTrace);
      return false;
    }
  }
  
  // Get all keys
  Set<String> getKeys() {
    try {
      return _prefs.getKeys();
    } catch (e, stackTrace) {
      Logger.error('Failed to get all keys', error: e, stackTrace: stackTrace);
      return <String>{};
    }
  }
  
  // App-specific convenience methods
  Future<bool> setUserToken(String token) async {
    return await setSecureString(AppConstants.userTokenKey, token);
  }
  
  Future<String?> getUserToken() async {
    return await getSecureString(AppConstants.userTokenKey);
  }
  
  Future<bool> clearUserToken() async {
    return await deleteSecureString(AppConstants.userTokenKey);
  }
  
  Future<bool> setThemeMode(String themeMode) async {
    return await setString(AppConstants.themeKey, themeMode);
  }
  
  String getThemeMode() {
    return getString(AppConstants.themeKey, defaultValue: 'system') ?? 'system';
  }
  
  Future<bool> setOnboardingCompleted(bool completed) async {
    return await setBool(AppConstants.onboardingKey, completed);
  }
  
  bool isOnboardingCompleted() {
    return getBool(AppConstants.onboardingKey);
  }
  
  Future<bool> setUserSettings(Map<String, dynamic> settings) async {
    return await setJson(AppConstants.settingsKey, settings);
  }
  
  Map<String, dynamic>? getUserSettings() {
    return getJson(AppConstants.settingsKey);
  }
  
  Future<bool> setStreakData(Map<String, dynamic> streaks) async {
    return await setJson(AppConstants.streaksKey, streaks);
  }
  
  Map<String, dynamic>? getStreakData() {
    return getJson(AppConstants.streaksKey);
  }
}