import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

import '../../core/constants/video_constants.dart';
import '../../core/exceptions/app_exception.dart';
import '../../core/utils/app_logger.dart';
import '../models/video_item.dart';

class MediaStoreDataSource {
  const MediaStoreDataSource();

  Future<List<VideoItem>> getVideos() async {
    final permission = await PhotoManager.requestPermissionExtend();

    if (!permission.hasAccess) {
      throw const PermissionDeniedException();
    }

    try {
      final albums = await PhotoManager.getAssetPathList(
        onlyAll: true,
        type: RequestType.video,
      );

      if (albums.isEmpty) {
        return [];
      }

      final album = albums.first;

      final List<VideoItem> videos = [];

      int page = 0;

      while (true) {
        final assets = await album.getAssetListPaged(
          page: page,
          size: VideoConstants.pageSize,
        );

        if (assets.isEmpty) {
          break;
        }

        for (final asset in assets) {
          try {
            // Filter durasi terlebih dahulu
            if (asset.duration < VideoConstants.minimumDurationSeconds) {
              continue;
            }

            final File? file = await asset.file;

            if (file == null) {
              continue;
            }

            final fileSize = await file.length();

            videos.add(
              VideoItem(
                id: asset.id,
                displayName: asset.title ?? file.uri.pathSegments.last,
                path: file.path,
                duration: Duration(seconds: asset.duration),
                size: fileSize,
                dateModified: asset.modifiedDateTime,
                thumbnailPath: null,
                width: asset.width,
                height: asset.height,
              ),
            );
          } catch (e, stackTrace) {
            AppLogger.error(
              'Video ${asset.id} gagal diproses',
              error: e,
              stackTrace: stackTrace,
            );
          }
        }

        page++;
      }

      videos.sort((a, b) => b.dateModified.compareTo(a.dateModified));

      AppLogger.info('Scan selesai. Total video: ${videos.length}');

      return videos;
    } catch (e, stackTrace) {
      AppLogger.error('MediaStore Error', error: e, stackTrace: stackTrace);

      throw MediaStoreException(e.toString());
    }
  }
}
