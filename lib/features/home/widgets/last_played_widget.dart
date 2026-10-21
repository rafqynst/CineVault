import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/last_played_model.dart';
import 'last_played_thumbnail_widget.dart';

class LastPlayedWidget extends StatelessWidget {
  final LastPlayedModel lastPlayed;
  final VoidCallback onTap;

  const LastPlayedWidget({
    super.key,
    required this.lastPlayed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              LastPlayedThumbnailWidget(
                videoPath: lastPlayed.videoPath,
                position: lastPlayed.position,
                width: 100,
                height: 60,
                borderRadius: BorderRadius.circular(14),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Terakhir Diputar",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      lastPlayed.videoName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: lastPlayed.duration > 0
                            ? (lastPlayed.position / lastPlayed.duration).clamp(
                                0.0,
                                1.0,
                              )
                            : 0.0,
                        minHeight: 5,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      '${_formatDuration(lastPlayed.position)} / '
                      '${_formatDuration(lastPlayed.duration)}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
