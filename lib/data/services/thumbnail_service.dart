import 'dart:io';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailService {
  const ThumbnailService();

  Future<String?> getThumbnail(String videoPath) async {
    try {
      // Folder cache aplikasi
      final Directory cacheDir = await getTemporaryDirectory();

      final Directory thumbnailDir = Directory(
        path.join(cacheDir.path, 'video_thumbnails'),
      );

      // Buat folder jika belum ada
      if (!await thumbnailDir.exists()) {
        await thumbnailDir.create(recursive: true);
      }

      // Nama file thumbnail berdasarkan nama video
      final hash = md5.convert(utf8.encode(videoPath)).toString();

      final fileName = '$hash.jpg';

      final String thumbnailPath = path.join(
        thumbnailDir.path,
        fileName,
      );

      // Jika thumbnail sudah ada, langsung gunakan
      if (await File(thumbnailPath).exists()) {
        return thumbnailPath;
      }

      const retryTimes = [
          1000,
          3000,
          5000,
        ];

        for (final time in retryTimes) {
          final generatedPath = await _generateThumbnail(
            videoPath: videoPath,
            thumbnailDir: thumbnailDir.path,
            timeMs: time,
          );

          if (generatedPath != null) {
            print(
              'Thumbnail berhasil dibuat '
              '(${time}ms): $generatedPath',
            );

            return generatedPath;
          }

          print(
            'Thumbnail gagal pada ${time}ms '
            'untuk $videoPath',
          );
        }

        print(
          'Semua percobaan thumbnail gagal '
          'untuk $videoPath',
        );

        return null;
    } catch (_) {
      return null;
    }
  }
    Future<String?> _generateThumbnail({
    required String videoPath,
    required String thumbnailDir,
    required int timeMs,
  }) async {
    return VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: thumbnailDir,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 320,
      quality: 75,
      timeMs: timeMs,
    );
  }
}