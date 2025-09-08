import 'package:equatable/equatable.dart';
import 'memory_model.dart';

enum TrailDifficulty { easy, medium, hard }

enum TrailStatus { draft, published, archived }

class Trail extends Equatable {
  final String id;
  final String title;
  final String description;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String coverImage;
  final TrailDifficulty difficulty;
  final double distance; // in kilometers
  final Duration estimatedDuration;
  final int memoryCount;
  final double rating;
  final int reviewCount;
  final String category;
  final bool isBookmarked;
  final bool isCompleted;
  final List<String> tags;
  final TrailStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<TrailPoint> points;
  final TrailStats stats;
  final List<String> completedBy;
  final bool isPublic;
  final bool allowCollaboration;

  const Trail({
    required this.id,
    required this.title,
    required this.description,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.coverImage,
    required this.difficulty,
    required this.distance,
    required this.estimatedDuration,
    required this.memoryCount,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.isBookmarked,
    required this.isCompleted,
    required this.tags,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    required this.points,
    required this.stats,
    required this.completedBy,
    required this.isPublic,
    required this.allowCollaboration,
  });

  factory Trail.fromJson(Map<String, dynamic> json) {
    return Trail(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorAvatar: json['authorAvatar'] as String,
      coverImage: json['coverImage'] as String,
      difficulty: TrailDifficulty.values.firstWhere(
        (e) => e.toString().split('.').last == json['difficulty'],
      ),
      distance: (json['distance'] as num).toDouble(),
      estimatedDuration: Duration(minutes: json['estimatedDuration'] as int),
      memoryCount: json['memoryCount'] as int,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      category: json['category'] as String,
      isBookmarked: json['isBookmarked'] as bool,
      isCompleted: json['isCompleted'] as bool,
      tags: List<String>.from(json['tags'] as List),
      status: TrailStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      points: (json['points'] as List)
          .map((e) => TrailPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: TrailStats.fromJson(json['stats'] as Map<String, dynamic>),
      completedBy: List<String>.from(json['completedBy'] as List),
      isPublic: json['isPublic'] as bool,
      allowCollaboration: json['allowCollaboration'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'coverImage': coverImage,
      'difficulty': difficulty.toString().split('.').last,
      'distance': distance,
      'estimatedDuration': estimatedDuration.inMinutes,
      'memoryCount': memoryCount,
      'rating': rating,
      'reviewCount': reviewCount,
      'category': category,
      'isBookmarked': isBookmarked,
      'isCompleted': isCompleted,
      'tags': tags,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'points': points.map((e) => e.toJson()).toList(),
      'stats': stats.toJson(),
      'completedBy': completedBy,
      'isPublic': isPublic,
      'allowCollaboration': allowCollaboration,
    };
  }

  Trail copyWith({
    String? id,
    String? title,
    String? description,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? coverImage,
    TrailDifficulty? difficulty,
    double? distance,
    Duration? estimatedDuration,
    int? memoryCount,
    double? rating,
    int? reviewCount,
    String? category,
    bool? isBookmarked,
    bool? isCompleted,
    List<String>? tags,
    TrailStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<TrailPoint>? points,
    TrailStats? stats,
    List<String>? completedBy,
    bool? isPublic,
    bool? allowCollaboration,
  }) {
    return Trail(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      coverImage: coverImage ?? this.coverImage,
      difficulty: difficulty ?? this.difficulty,
      distance: distance ?? this.distance,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      memoryCount: memoryCount ?? this.memoryCount,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      category: category ?? this.category,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isCompleted: isCompleted ?? this.isCompleted,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      points: points ?? this.points,
      stats: stats ?? this.stats,
      completedBy: completedBy ?? this.completedBy,
      isPublic: isPublic ?? this.isPublic,
      allowCollaboration: allowCollaboration ?? this.allowCollaboration,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        authorId,
        authorName,
        authorAvatar,
        coverImage,
        difficulty,
        distance,
        estimatedDuration,
        memoryCount,
        rating,
        reviewCount,
        category,
        isBookmarked,
        isCompleted,
        tags,
        status,
        createdAt,
        updatedAt,
        points,
        stats,
        completedBy,
        isPublic,
        allowCollaboration,
      ];
}

class TrailPoint extends Equatable {
  final String id;
  final int order;
  final String title;
  final String? description;
  final double latitude;
  final double longitude;
  final String? memoryId;
  final Memory? memory;
  final TrailPointType type;
  final bool isRequired;
  final Duration? timeLimit;
  final String? instructions;
  final List<String> hints;
  final bool isCompleted;
  final DateTime? completedAt;

  const TrailPoint({
    required this.id,
    required this.order,
    required this.title,
    this.description,
    required this.latitude,
    required this.longitude,
    this.memoryId,
    this.memory,
    required this.type,
    required this.isRequired,
    this.timeLimit,
    this.instructions,
    required this.hints,
    required this.isCompleted,
    this.completedAt,
  });

  factory TrailPoint.fromJson(Map<String, dynamic> json) {
    return TrailPoint(
      id: json['id'] as String,
      order: json['order'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      memoryId: json['memoryId'] as String?,
      memory: json['memory'] != null
          ? Memory.fromJson(json['memory'] as Map<String, dynamic>)
          : null,
      type: TrailPointType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      isRequired: json['isRequired'] as bool,
      timeLimit: json['timeLimit'] != null
          ? Duration(minutes: json['timeLimit'] as int)
          : null,
      instructions: json['instructions'] as String?,
      hints: List<String>.from(json['hints'] as List),
      isCompleted: json['isCompleted'] as bool,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order': order,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'memoryId': memoryId,
      'memory': memory?.toJson(),
      'type': type.toString().split('.').last,
      'isRequired': isRequired,
      'timeLimit': timeLimit?.inMinutes,
      'instructions': instructions,
      'hints': hints,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  TrailPoint copyWith({
    String? id,
    int? order,
    String? title,
    String? description,
    double? latitude,
    double? longitude,
    String? memoryId,
    Memory? memory,
    TrailPointType? type,
    bool? isRequired,
    Duration? timeLimit,
    String? instructions,
    List<String>? hints,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return TrailPoint(
      id: id ?? this.id,
      order: order ?? this.order,
      title: title ?? this.title,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      memoryId: memoryId ?? this.memoryId,
      memory: memory ?? this.memory,
      type: type ?? this.type,
      isRequired: isRequired ?? this.isRequired,
      timeLimit: timeLimit ?? this.timeLimit,
      instructions: instructions ?? this.instructions,
      hints: hints ?? this.hints,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        order,
        title,
        description,
        latitude,
        longitude,
        memoryId,
        memory,
        type,
        isRequired,
        timeLimit,
        instructions,
        hints,
        isCompleted,
        completedAt,
      ];
}

enum TrailPointType {
  viewpoint,
  landmark,
  activity,
  checkpoint,
  finish,
}

class TrailStats extends Equatable {
  final int totalViews;
  final int totalCompletions;
  final int totalBookmarks;
  final int totalShares;
  final double averageRating;
  final Duration averageCompletionTime;
  final Map<String, int> categoryBreakdown;
  final Map<String, double> difficultyRatings;

  const TrailStats({
    required this.totalViews,
    required this.totalCompletions,
    required this.totalBookmarks,
    required this.totalShares,
    required this.averageRating,
    required this.averageCompletionTime,
    required this.categoryBreakdown,
    required this.difficultyRatings,
  });

  factory TrailStats.fromJson(Map<String, dynamic> json) {
    return TrailStats(
      totalViews: json['totalViews'] as int,
      totalCompletions: json['totalCompletions'] as int,
      totalBookmarks: json['totalBookmarks'] as int,
      totalShares: json['totalShares'] as int,
      averageRating: (json['averageRating'] as num).toDouble(),
      averageCompletionTime: Duration(minutes: json['averageCompletionTime'] as int),
      categoryBreakdown: Map<String, int>.from(json['categoryBreakdown'] as Map),
      difficultyRatings: Map<String, double>.from(
        (json['difficultyRatings'] as Map).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalViews': totalViews,
      'totalCompletions': totalCompletions,
      'totalBookmarks': totalBookmarks,
      'totalShares': totalShares,
      'averageRating': averageRating,
      'averageCompletionTime': averageCompletionTime.inMinutes,
      'categoryBreakdown': categoryBreakdown,
      'difficultyRatings': difficultyRatings,
    };
  }

  @override
  List<Object> get props => [
        totalViews,
        totalCompletions,
        totalBookmarks,
        totalShares,
        averageRating,
        averageCompletionTime,
        categoryBreakdown,
        difficultyRatings,
      ];
}

class TrailReview extends Equatable {
  final String id;
  final String trailId;
  final String userId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String? comment;
  final DateTime createdAt;
  final List<String> pros;
  final List<String> cons;
  final Duration completionTime;
  final TrailDifficulty perceivedDifficulty;

  const TrailReview({
    required this.id,
    required this.trailId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.pros,
    required this.cons,
    required this.completionTime,
    required this.perceivedDifficulty,
  });

  factory TrailReview.fromJson(Map<String, dynamic> json) {
    return TrailReview(
      id: json['id'] as String,
      trailId: json['trailId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      pros: List<String>.from(json['pros'] as List),
      cons: List<String>.from(json['cons'] as List),
      completionTime: Duration(minutes: json['completionTime'] as int),
      perceivedDifficulty: TrailDifficulty.values.firstWhere(
        (e) => e.toString().split('.').last == json['perceivedDifficulty'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trailId': trailId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'pros': pros,
      'cons': cons,
      'completionTime': completionTime.inMinutes,
      'perceivedDifficulty': perceivedDifficulty.toString().split('.').last,
    };
  }

  @override
  List<Object?> get props => [
        id,
        trailId,
        userId,
        userName,
        userAvatar,
        rating,
        comment,
        createdAt,
        pros,
        cons,
        completionTime,
        perceivedDifficulty,
      ];
}