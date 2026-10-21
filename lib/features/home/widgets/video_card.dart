import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/video_item.dart';
import 'video_thumbnail_widget.dart';
import '../../../../providers/favorite_provider.dart';

class VideoCard extends StatefulWidget {
  final VideoItem video;
  final VoidCallback? onTap;

  const VideoCard({super.key, required this.video, this.onTap});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();
    final isFavorite = favoriteProvider.isFavorite(widget.video.id);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: _pressed ? 0.98 : 1,
        child: GestureDetector(
          onTapDown: (_) {
            setState(() => _pressed = true);
          },
          onTapCancel: () {
            setState(() => _pressed = false);
          },
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onTap?.call();
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      VideoThumbnailWidget(
                        video: widget.video,
                        width: 140,
                        height: 80,
                      ),
                      Positioned(
                        right: 6,
                        bottom: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.video.formattedDuration,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: SizedBox(
                      height: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.video.displayName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () async {
                                  await context
                                      .read<FavoriteProvider>()
                                      .toggleFavorite(widget.video);
                                },
                                icon: Icon(
                                  isFavorite
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_border_rounded,
                                  color: isFavorite
                                      ? Colors.amber
                                      : Colors.grey.shade400,
                                  size: 22,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                tooltip: isFavorite
                                    ? 'Hapus dari favorit'
                                    : 'Tambahkan ke favorit',
                              ),
                            ],
                          ),

                          const Spacer(),

                          Text(
                            "${widget.video.resolution} • ${widget.video.formattedSize}",
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
