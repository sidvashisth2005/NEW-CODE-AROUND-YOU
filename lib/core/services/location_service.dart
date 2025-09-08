import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/app_constants.dart';
import '../error/failures.dart';
import '../utils/logger.dart';

class LocationService {
  static LocationService? _instance;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;
  final StreamController<Position> _positionController = StreamController<Position>.broadcast();
  
  LocationService._();
  
  static LocationService get instance {
    _instance ??= LocationService._();
    return _instance!;
  }
  
  Stream<Position> get positionStream => _positionController.stream;
  Position? get currentPosition => _currentPosition;
  
  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e, stackTrace) {
      Logger.error('Failed to check location service status', error: e, stackTrace: stackTrace);
      return false;
    }
  }
  
  /// Check current location permission status
  Future<LocationPermission> checkPermission() async {
    try {
      return await Geolocator.checkPermission();
    } catch (e, stackTrace) {
      Logger.error('Failed to check location permission', error: e, stackTrace: stackTrace);
      return LocationPermission.denied;
    }
  }
  
  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    try {
      Logger.info('Requesting location permission');
      return await Geolocator.requestPermission();
    } catch (e, stackTrace) {
      Logger.error('Failed to request location permission', error: e, stackTrace: stackTrace);
      return LocationPermission.denied;
    }
  }
  
  /// Get current position with error handling
  Future<Position?> getCurrentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration? timeLimit,
  }) async {
    try {
      // Check if location services are enabled
      final isServiceEnabled = await isLocationServiceEnabled();
      if (!isServiceEnabled) {
        Logger.warning('Location services are disabled');
        throw const LocationException(
          message: 'Location services are disabled. Please enable location services in settings.',
          code: 1001,
        );
      }
      
      // Check and request permissions
      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          Logger.warning('Location permission denied');
          throw const LocationException(
            message: 'Location permission denied. Please grant location access to use this feature.',
            code: 1002,
          );
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        Logger.warning('Location permission permanently denied');
        throw const LocationException(
          message: 'Location permission permanently denied. Please enable location access in app settings.',
          code: 1003,
        );
      }
      
      // Get current position
      Logger.debug('Getting current position with accuracy: $accuracy');
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: timeLimit ?? const Duration(seconds: 15),
      );
      
      _currentPosition = position;
      _positionController.add(position);
      
      Logger.info('Location obtained: ${position.latitude}, ${position.longitude}');
      return position;
      
    } on LocationException {
      rethrow;
    } catch (e, stackTrace) {
      Logger.error('Failed to get current position', error: e, stackTrace: stackTrace);
      throw LocationException(
        message: 'Unable to get your current location. Please try again.',
        code: 1000,
      );
    }
  }
  
  /// Start listening to position changes
  Future<void> startLocationUpdates({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10, // meters
    Duration interval = const Duration(seconds: 5),
  }) async {
    try {
      // Stop existing subscription
      await stopLocationUpdates();
      
      // Check permissions first
      final permission = await checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw const LocationException(
          message: 'Location permission required for continuous updates',
          code: 1002,
        );
      }
      
      final locationSettings = LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
        timeLimit: const Duration(seconds: 30),
      );
      
      Logger.info('Starting location updates with accuracy: $accuracy, distanceFilter: ${distanceFilter}m');
      
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          _currentPosition = position;
          _positionController.add(position);
          Logger.debug('Location updated: ${position.latitude}, ${position.longitude}');
        },
        onError: (error) {
          Logger.error('Location stream error', error: error);
          _positionController.addError(LocationException(
            message: 'Location updates failed: $error',
            code: 1004,
          ));
        },
      );
      
    } catch (e, stackTrace) {
      Logger.error('Failed to start location updates', error: e, stackTrace: stackTrace);
      throw LocationException(
        message: 'Unable to start location tracking. Please check your location settings.',
        code: 1005,
      );
    }
  }
  
  /// Stop location updates
  Future<void> stopLocationUpdates() async {
    try {
      await _positionStreamSubscription?.cancel();
      _positionStreamSubscription = null;
      Logger.info('Location updates stopped');
    } catch (e, stackTrace) {
      Logger.error('Failed to stop location updates', error: e, stackTrace: stackTrace);
    }
  }
  
  /// Calculate distance between two positions
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    try {
      return Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );
    } catch (e, stackTrace) {
      Logger.error('Failed to calculate distance', error: e, stackTrace: stackTrace);
      return 0.0;
    }
  }
  
  /// Calculate bearing between two positions
  double calculateBearing(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    try {
      return Geolocator.bearingBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );
    } catch (e, stackTrace) {
      Logger.error('Failed to calculate bearing', error: e, stackTrace: stackTrace);
      return 0.0;
    }
  }
  
  /// Get address from coordinates (reverse geocoding)
  Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      Logger.debug('Getting address for coordinates: $latitude, $longitude');
      
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final address = [
          placemark.name,
          placemark.street,
          placemark.locality,
          placemark.administrativeArea,
          placemark.country,
        ].where((component) => component != null && component.isNotEmpty).join(', ');
        
        Logger.debug('Address found: $address');
        return address.isNotEmpty ? address : null;
      }
      
      return null;
    } catch (e, stackTrace) {
      Logger.error('Failed to get address from coordinates', error: e, stackTrace: stackTrace);
      return null;
    }
  }
  
  /// Get coordinates from address (geocoding)
  Future<Position?> getCoordinatesFromAddress(String address) async {
    try {
      Logger.debug('Getting coordinates for address: $address');
      
      final locations = await locationFromAddress(address);
      
      if (locations.isNotEmpty) {
        final location = locations.first;
        final position = Position(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
        
        Logger.debug('Coordinates found: ${position.latitude}, ${position.longitude}');
        return position;
      }
      
      return null;
    } catch (e, stackTrace) {
      Logger.error('Failed to get coordinates from address', error: e, stackTrace: stackTrace);
      return null;
    }
  }
  
  /// Check if user is within a certain radius of a location
  bool isWithinRadius(
    double userLatitude,
    double userLongitude,
    double targetLatitude,
    double targetLongitude,
    double radiusInMeters,
  ) {
    try {
      final distance = calculateDistance(
        userLatitude,
        userLongitude,
        targetLatitude,
        targetLongitude,
      );
      
      return distance <= radiusInMeters;
    } catch (e, stackTrace) {
      Logger.error('Failed to check radius', error: e, stackTrace: stackTrace);
      return false;
    }
  }
  
  /// Format distance for display
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()}m';
    } else {
      final km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(1)}km';
    }
  }
  
  /// Get location accuracy description
  String getAccuracyDescription(double accuracy) {
    if (accuracy <= 5) {
      return 'Excellent';
    } else if (accuracy <= 10) {
      return 'Good';
    } else if (accuracy <= 20) {
      return 'Fair';
    } else {
      return 'Poor';
    }
  }
  
  /// Open device location settings
  Future<bool> openLocationSettings() async {
    try {
      Logger.info('Opening location settings');
      return await Geolocator.openLocationSettings();
    } catch (e, stackTrace) {
      Logger.error('Failed to open location settings', error: e, stackTrace: stackTrace);
      return false;
    }
  }
  
  /// Open app settings
  Future<bool> openAppSettings() async {
    try {
      Logger.info('Opening app settings');
      return await Geolocator.openAppSettings();
    } catch (e, stackTrace) {
      Logger.error('Failed to open app settings', error: e, stackTrace: stackTrace);
      return false;
    }
  }
  
  /// Dispose of resources
  void dispose() {
    stopLocationUpdates();
    _positionController.close();
    Logger.info('LocationService disposed');
  }
}