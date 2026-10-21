import 'dart:typed_data';
import '../../core/utils/duration_formatter.dart';
import '../../core/utils/file_size_formatter.dart';

class VideoItem {
  final String id;

  /// Nama video yang tampil di UI
  final String displayName;

  /// Path asli file video
  final String path;

  /// Durasi video
  final Duration duration;

  /// Ukuran file (bytes)
  final int size;

  /// Tanggal terakhir dimodifikasi
  final DateTime dateModified;

  final Uint8List? thumbnailBytes;

  final String? thumbnailPath;

  final int? width;

  final int? height;

 const VideoItem({
  required this.id,
  required this.displayName,
  required this.path,
  required this.duration,
  required this.size,
  required this.dateModified,
  this.thumbnailBytes,
  this.thumbnailPath,
  this.width,
  this.height,
});

  String get formattedDuration =>
      formatDuration(duration);

  String get formattedSize =>
      formatFileSize(size);

  String get resolution {
  if (width == null || height == null) {
    return "Unknown";
  }

  return "${width}×${height}";
}

  bool get isValid =>
      duration.inSeconds >= 300;

  @override
  String toString() {
    return '''
VideoItem(
 id: $id,
 name: $displayName,
 duration: $formattedDuration,
 size: $formattedSize
)
''';
  }
}