
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/video_item.dart';
import '../../../providers/favorite_provider.dart';
import '../../home/widgets/video_thumbnail_widget.dart';

class FavoriteVideoList extends StatelessWidget {
  final Future<void> Function(VideoItem video) onVideoSelected;
  final VoidCallback onClose;

 const FavoriteVideoList({
  super.key,
  required this.onVideoSelected,
  required this.onClose,
});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, provider, child) {
        final favorites = provider.favorites;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 8, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Video Favorit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Tutup panel',
                    onPressed: onClose,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white24),
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : favorites.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Belum ada video favorit.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: favorites.length,
                          itemBuilder: (context, index) {
                            final item = favorites[index];

                            final videoId =
                                item['video_id'] as String;
                            final videoName =
                                item['video_name'] as String;
                            final videoPath =
                                item['video_path'] as String;

                            return FutureBuilder<bool>(
                              future: File(videoPath).exists(),
                              builder: (context, snapshot) {
                                if (snapshot.data != true) {
                                  return const SizedBox.shrink();
                                }

                                return FutureBuilder<int>(
                                  future: File(videoPath).length(),
                                  builder: (context, sizeSnapshot) {
                                    if (!sizeSnapshot.hasData) {
                                      return const SizedBox(
                                        height: 70,
                                      );
                                    }

                                    final video = VideoItem(
                                      id: videoId,
                                      displayName: videoName,
                                      path: videoPath,
                                      duration: Duration.zero,
                                      size: sizeSnapshot.data!,
                                      dateModified: DateTime.now(),
                                    );

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        onTap: () {
                                          onVideoSelected(video);
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            VideoThumbnailWidget(
                                              video: video,
                                              width: double.infinity,
                                              height: 90,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              videoName,
                                              maxLines: 2,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        );
      },
    );
  }
}
