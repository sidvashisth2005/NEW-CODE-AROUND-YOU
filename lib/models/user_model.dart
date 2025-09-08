import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String username;
  final String? bio;
  final String avatar;
  final String? coverImage;
  final int memoriesCount;
  final int followersCount;
  final int followingCount;
  final int trailsCount;
  final DateTime joinDate;
  final bool isPremium;
  final bool isAdmin;
  final bool isVerified;
  final UserPreferences preferences;
  final UserStats stats;
  final UserLocation? location;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    this.bio,
    required this.avatar,
    this.coverImage,
    required this.memoriesCount,
    required this.followersCount,
    required this.followingCount,
    required this.trailsCount,
    required this.joinDate,
    required this.isPremium,
    required this.isAdmin,
    required this.isVerified,
    required this.preferences,
    required this.stats,
    this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      bio: json['bio'] as String?,
      avatar: json['avatar'] as String,
      coverImage: json['coverImage'] as String?,
      memoriesCount: json['memoriesCount'] as int,
      followersCount: json['followersCount'] as int,
      followingCount: json['followingCount'] as int,
      trailsCount: json['trailsCount'] as int,
      joinDate: DateTime.parse(json['joinDate'] as String),
      isPremium: json['isPremium'] as bool,
      isAdmin: json['isAdmin'] as bool,
      isVerified: json['isVerified'] as bool,
      preferences: UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
      stats: UserStats.fromJson(json['stats'] as Map<String, dynamic>),
      location: json['location'] != null
          ? UserLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'bio': bio,
      'avatar': avatar,
      'coverImage': coverImage,
      'memoriesCount': memoriesCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'trailsCount': trailsCount,
      'joinDate': joinDate.toIso8601String(),
      'isPremium': isPremium,
      'isAdmin': isAdmin,
      'isVerified': isVerified,
      'preferences': preferences.toJson(),
      'stats': stats.toJson(),
      'location': location?.toJson(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? username,
    String? bio,
    String? avatar,
    String? coverImage,
    int? memoriesCount,
    int? followersCount,
    int? followingCount,
    int? trailsCount,
    DateTime? joinDate,
    bool? isPremium,
    bool? isAdmin,
    bool? isVerified,
    UserPreferences? preferences,
    UserStats? stats,
    UserLocation? location,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      coverImage: coverImage ?? this.coverImage,
      memoriesCount: memoriesCount ?? this.memoriesCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      trailsCount: trailsCount ?? this.trailsCount,
      joinDate: joinDate ?? this.joinDate,
      isPremium: isPremium ?? this.isPremium,
      isAdmin: isAdmin ?? this.isAdmin,
      isVerified: isVerified ?? this.isVerified,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        username,
        bio,
        avatar,
        coverImage,
        memoriesCount,
        followersCount,
        followingCount,
        trailsCount,
        joinDate,
        isPremium,
        isAdmin,
        isVerified,
        preferences,
        stats,
        location,
      ];
}

class UserPreferences extends Equatable {
  final bool notificationsEnabled;
  final bool locationEnabled;
  final bool hapticEnabled;
  final bool soundEnabled;
  final double proximityRadius;
  final String theme; // 'light', 'dark', 'system'
  final String language;
  final List<String> contentFilters;
  final Map<String, bool> privacySettings;

  const UserPreferences({
    required this.notificationsEnabled,
    required this.locationEnabled,
    required this.hapticEnabled,
    required this.soundEnabled,
    required this.proximityRadius,
    required this.theme,
    required this.language,
    required this.contentFilters,
    required this.privacySettings,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notificationsEnabled: json['notificationsEnabled'] as bool,
      locationEnabled: json['locationEnabled'] as bool,
      hapticEnabled: json['hapticEnabled'] as bool,
      soundEnabled: json['soundEnabled'] as bool,
      proximityRadius: (json['proximityRadius'] as num).toDouble(),
      theme: json['theme'] as String,
      language: json['language'] as String,
      contentFilters: List<String>.from(json['contentFilters'] as List),
      privacySettings: Map<String, bool>.from(json['privacySettings'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'locationEnabled': locationEnabled,
      'hapticEnabled': hapticEnabled,
      'soundEnabled': soundEnabled,
      'proximityRadius': proximityRadius,
      'theme': theme,
      'language': language,
      'contentFilters': contentFilters,
      'privacySettings': privacySettings,
    };
  }

  UserPreferences copyWith({
    bool? notificationsEnabled,
    bool? locationEnabled,
    bool? hapticEnabled,
    bool? soundEnabled,
    double? proximityRadius,
    String? theme,
    String? language,
    List<String>? contentFilters,
    Map<String, bool>? privacySettings,
  }) {
    return UserPreferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      proximityRadius: proximityRadius ?? this.proximityRadius,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      contentFilters: contentFilters ?? this.contentFilters,
      privacySettings: privacySettings ?? this.privacySettings,
    );
  }

  @override
  List<Object> get props => [
        notificationsEnabled,
        locationEnabled,
        hapticEnabled,
        soundEnabled,
        proximityRadius,
        theme,
        language,
        contentFilters,
        privacySettings,
      ];
}

class UserStats extends Equatable {
  final int totalLikes;
  final int totalComments;
  final int totalShares;
  final int totalViews;
  final int streakCount;
  final int longestStreak;
  final DateTime? lastActivity;
  final Map<String, int> categoryStats;
  final Map<String, double> engagementMetrics;

  const UserStats({
    required this.totalLikes,
    required this.totalComments,
    required this.totalShares,
    required this.totalViews,
    required this.streakCount,
    required this.longestStreak,
    this.lastActivity,
    required this.categoryStats,
    required this.engagementMetrics,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalLikes: json['totalLikes'] as int,
      totalComments: json['totalComments'] as int,
      totalShares: json['totalShares'] as int,
      totalViews: json['totalViews'] as int,
      streakCount: json['streakCount'] as int,
      longestStreak: json['longestStreak'] as int,
      lastActivity: json['lastActivity'] != null
          ? DateTime.parse(json['lastActivity'] as String)
          : null,
      categoryStats: Map<String, int>.from(json['categoryStats'] as Map),
      engagementMetrics: Map<String, double>.from(
        (json['engagementMetrics'] as Map).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalLikes': totalLikes,
      'totalComments': totalComments,
      'totalShares': totalShares,
      'totalViews': totalViews,
      'streakCount': streakCount,
      'longestStreak': longestStreak,
      'lastActivity': lastActivity?.toIso8601String(),
      'categoryStats': categoryStats,
      'engagementMetrics': engagementMetrics,
    };
  }

  UserStats copyWith({
    int? totalLikes,
    int? totalComments,
    int? totalShares,
    int? totalViews,
    int? streakCount,
    int? longestStreak,
    DateTime? lastActivity,
    Map<String, int>? categoryStats,
    Map<String, double>? engagementMetrics,
  }) {
    return UserStats(
      totalLikes: totalLikes ?? this.totalLikes,
      totalComments: totalComments ?? this.totalComments,
      totalShares: totalShares ?? this.totalShares,
      totalViews: totalViews ?? this.totalViews,
      streakCount: streakCount ?? this.streakCount,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivity: lastActivity ?? this.lastActivity,
      categoryStats: categoryStats ?? this.categoryStats,
      engagementMetrics: engagementMetrics ?? this.engagementMetrics,
    );
  }

  @override
  List<Object?> get props => [
        totalLikes,
        totalComments,
        totalShares,
        totalViews,
        streakCount,
        longestStreak,
        lastActivity,
        categoryStats,
        engagementMetrics,
      ];
}

class UserLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? country;
  final DateTime lastUpdated;

  const UserLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.country,
    required this.lastUpdated,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'country': country,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  UserLocation copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? country,
    DateTime? lastUpdated,
  }) {
    return UserLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        address,
        city,
        country,
        lastUpdated,
      ];
}