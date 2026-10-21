class LastPlayedModel {
  final int id;
  final String videoId;
  final String videoPath;
  final String videoName;
  final int position;
  final int duration;
  final DateTime lastPlayed;

  const LastPlayedModel({
    required this.id,
    required this.videoId,
    required this.videoPath,
    required this.videoName,
    required this.position,
    required this.duration,
    required this.lastPlayed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'video_id': videoId,
      'video_path': videoPath,
      'video_name': videoName,
      'position': position,
      'duration': duration,
      'last_played': lastPlayed.toIso8601String(),
    };
  }

  factory LastPlayedModel.fromMap(Map<String, dynamic> map) {
    return LastPlayedModel(
      id: map['id'] as int,
      videoId: map['video_id'] as String,
      videoPath: map['video_path'] as String,
      videoName: map['video_name'] as String,
      position: map['position'] as int,
      duration: map['duration'] as int,
      lastPlayed: DateTime.parse(map['last_played'] as String),
    );
  }
}