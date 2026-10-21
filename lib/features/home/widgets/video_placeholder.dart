import 'package:flutter/material.dart';

import '../../../data/models/video_item.dart';

class VideoPlaceholder extends StatelessWidget {
  final VideoItem video;

  const VideoPlaceholder({
    super.key,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff303030),
            Color(0xff1B1B1B),
            Color(0xff111111),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Icon
          Center(
            child: Icon(
              Icons.play_circle_fill_rounded,
              size: 46,
              color: Colors.white.withValues(alpha: .18),
            ),
          ),

          // Resolution Badge
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: _badgeColor(),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                _resolutionLabel(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ),

          // Bottom Info
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _extension(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),

                const Spacer(),

                Text(
                  video.formattedDuration,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _extension() {
    final ext = video.path.split('.').last.toUpperCase();

    if (ext.isEmpty) {
      return "VIDEO";
    }

    return ext;
  }

  String _resolutionLabel() {
    final width = video.width ?? 0;

    if (width >= 3840) return "4K";
    if (width >= 2560) return "2K";
    if (width >= 1920) return "1080P";
    if (width >= 1280) return "720P";

    return "SD";
  }

  Color _badgeColor() {
    final width = video.width ?? 0;

    if (width >= 3840) {
      return Colors.deepPurple;
    }

    if (width >= 1920) {
      return Colors.blue;
    }

    return Colors.grey;
  }
}