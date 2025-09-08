import 'package:equatable/equatable.dart';

enum MemoryType { photo, video, text, audio }

enum MemoryVisibility { public, private, friends }

class Memory extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final MemoryType type;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final String caption;
  final MemoryLocation location;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int viewsCount;
  final bool isLiked;
  final bool isBookmarked;
  final MemoryVisibility visibility;
  final bool allowComments;
  final List<String> tags;
  final List<String> mentions;
  final MemoryMetadata metadata;
  final List<Comment> comments;

  const Memory({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.type,
    this.mediaUrl,
    this.thumbnailUrl,
    required this.caption,
    required this.location,
    required this.createdAt,
    this.updatedAt,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.viewsCount,
    required this.isLiked,
    required this.isBookmarked,
    required this.visibility,
    required this.allowComments,
    required this.tags,
    required this.mentions,
    required this.metadata,
    this.comments = const [],
  });

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String,
      type: MemoryType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      mediaUrl: json['mediaUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      caption: json['caption'] as String,
      location: MemoryLocation.fromJson(json['location'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      likesCount: json['likesCount'] as int,
      commentsCount: json['commentsCount'] as int,
      sharesCount: json['sharesCount'] as int,
      viewsCount: json['viewsCount'] as int,
      isLiked: json['isLiked'] as bool,
      isBookmarked: json['isBookmarked'] as bool,
      visibility: MemoryVisibility.values.firstWhere(
        (e) => e.toString().split('.').last == json['visibility'],
      ),
      allowComments: json['allowComments'] as bool,
      tags: List<String>.from(json['tags'] as List),
      mentions: List<String>.from(json['mentions'] as List),
      metadata: MemoryMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      comments: (json['comments'] as List?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'type': type.toString().split('.').last,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'caption': caption,
      'location': location.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'viewsCount': viewsCount,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
      'visibility': visibility.toString().split('.').last,
      'allowComments': allowComments,
      'tags': tags,
      'mentions': mentions,
      'metadata': metadata.toJson(),
      'comments': comments.map((e) => e.toJson()).toList(),
    };
  }

  Memory copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    MemoryType? type,
    String? mediaUrl,
    String? thumbnailUrl,
    String? caption,
    MemoryLocation? location,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    int? viewsCount,
    bool? isLiked,
    bool? isBookmarked,
    MemoryVisibility? visibility,
    bool? allowComments,
    List<String>? tags,
    List<String>? mentions,
    MemoryMetadata? metadata,
    List<Comment>? comments,
  }) {
    return Memory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      type: type ?? this.type,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      caption: caption ?? this.caption,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      visibility: visibility ?? this.visibility,
      allowComments: allowComments ?? this.allowComments,
      tags: tags ?? this.tags,
      mentions: mentions ?? this.mentions,
      metadata: metadata ?? this.metadata,
      comments: comments ?? this.comments,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userAvatar,
        type,
        mediaUrl,
        thumbnailUrl,
        caption,
        location,
        createdAt,
        updatedAt,
        likesCount,
        commentsCount,
        sharesCount,
        viewsCount,
        isLiked,
        isBookmarked,
        visibility,
        allowComments,
        tags,
        mentions,
        metadata,
        comments,
      ];
}

class MemoryLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String name;
  final String? address;
  final String? city;
  final String? country;
  final double? accuracy;

  const MemoryLocation({
    required this.latitude,
    required this.longitude,
    required this.name,
    this.address,
    this.city,
    this.country,
    this.accuracy,
  });

  factory MemoryLocation.fromJson(Map<String, dynamic> json) {
    return MemoryLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      name: json['name'] as String,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      accuracy: json['accuracy'] != null ? (json['accuracy'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'address': address,
      'city': city,
      'country': country,
      'accuracy': accuracy,
    };
  }

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        name,
        address,
        city,
        country,
        accuracy,
      ];
}

class MemoryMetadata extends Equatable {
  final String? camera;
  final String? lens;
  final Map<String, dynamic>? exifData;
  final Duration? duration; // For video/audio
  final String? fileSize;
  final String? resolution;
  final List<String>? filters;
  final Map<String, dynamic>? customData;

  const MemoryMetadata({
    this.camera,
    this.lens,
    this.exifData,
    this.duration,
    this.fileSize,
    this.resolution,
    this.filters,
    this.customData,
  });

  factory MemoryMetadata.fromJson(Map<String, dynamic> json) {
    return MemoryMetadata(
      camera: json['camera'] as String?,
      lens: json['lens'] as String?,
      exifData: json['exifData'] as Map<String, dynamic>?,
      duration: json['duration'] != null
          ? Duration(milliseconds: json['duration'] as int)
          : null,
      fileSize: json['fileSize'] as String?,
      resolution: json['resolution'] as String?,
      filters: json['filters'] != null
          ? List<String>.from(json['filters'] as List)
          : null,
      customData: json['customData'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'camera': camera,
      'lens': lens,
      'exifData': exifData,
      'duration': duration?.inMilliseconds,
      'fileSize': fileSize,
      'resolution': resolution,
      'filters': filters,
      'customData': customData,
    };
  }

  @override
  List<Object?> get props => [
        camera,
        lens,
        exifData,
        duration,
        fileSize,
        resolution,
        filters,
        customData,
      ];
}

class Comment extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String text;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likesCount;
  final bool isLiked;
  final String? parentId; // For replies
  final List<Comment> replies;

  const Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.text,
    required this.createdAt,
    this.updatedAt,
    required this.likesCount,
    required this.isLiked,
    this.parentId,
    this.replies = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      likesCount: json['likesCount'] as int,
      isLiked: json['isLiked'] as bool,
      parentId: json['parentId'] as String?,
      replies: (json['replies'] as List?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'likesCount': likesCount,
      'isLiked': isLiked,
      'parentId': parentId,
      'replies': replies.map((e) => e.toJson()).toList(),
    };
  }

  Comment copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    bool? isLiked,
    String? parentId,
    List<Comment>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      parentId: parentId ?? this.parentId,
      replies: replies ?? this.replies,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userAvatar,
        text,
        createdAt,
        updatedAt,
        likesCount,
        isLiked,
        parentId,
        replies,
      ];
}