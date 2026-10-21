import '../../core/result/result.dart';
import '../../core/exceptions/app_exception.dart';
import '../datasource/media_store_datasource.dart';
import '../models/video_item.dart';

class VideoRepository {
  final MediaStoreDataSource _dataSource;

  const VideoRepository(this._dataSource);

  Future<Result<List<VideoItem>>> getVideos() async {
    try {
      final videos = await _dataSource.getVideos();

      return Success(videos);
    } on PermissionDeniedException {
      return const Failure(
        'PERMISSION_DENIED',
      );
    } on MediaStoreException catch (e) {
      return Failure(
        e.message,
      );
    } catch (e) {
      return Failure(
        e.toString(),
      );
    }
  }
}