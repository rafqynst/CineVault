import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerControls extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback onPlayPause;
  final VoidCallback onToggleOrientation;
  final Future<void> Function() onBack;
  final bool isLandscape;
  final bool visible;

  const PlayerControls({
    super.key,
    required this.controller,
    required this.onPlayPause,
    required this.onToggleOrientation,
    required this.onBack,
    required this.isLandscape,
    required this.visible,
  });

  String _formatDuration(Duration duration) {
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

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    final position = controller.value.position;
    final duration = controller.value.duration;

    final maxMilliseconds = duration.inMilliseconds > 0
        ? duration.inMilliseconds.toDouble()
        : 1.0;

    final currentMilliseconds = position.inMilliseconds
        .clamp(0, duration.inMilliseconds)
        .toDouble();

    return Positioned.fill(
      child: Stack(
        children: [
          // Back button
          Positioned(
            top: 8,
            left: 8,
            child: IconButton(
              onPressed: () async {
                await onBack();
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),

          // Play / Pause
          Center(
            child: IconButton(
              onPressed: onPlayPause,
              iconSize: 56,
              color: Colors.white,
              icon: Icon(
                controller.value.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
              ),
            ),
          ),

          // Speed
          Positioned(
            left: 8,
            bottom: 48,
            child: PopupMenuButton<double>(
              tooltip: 'Speed',
              color: Colors.black87,
              onSelected: (speed) async {
                await controller.setPlaybackSpeed(speed);
              },
              itemBuilder: (context) {
                const speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

                return speeds.map((speed) {
                  final isSelected = controller.value.playbackSpeed == speed;

                  return PopupMenuItem<double>(
                    value: speed,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${speed}x',
                          style: const TextStyle(color: Colors.white),
                        ),

                        if (isSelected) ...[
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList();
              },
              icon: const Icon(Icons.speed, color: Colors.white, size: 28),
            ),
          ),

          // Orientation
          Positioned(
            right: 8,
            bottom: 48,
            child: IconButton(
              onPressed: onToggleOrientation,
              tooltip: isLandscape ? 'Portrait' : 'Landscape',
              icon: Icon(
                isLandscape
                    ? Icons.stay_current_portrait
                    : Icons.screen_rotation_alt,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),

          // Progress
          Positioned(
            left: 16,
            right: 16,
            bottom: 8,
            child: Row(
              children: [
                Text(
                  _formatDuration(position),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Slider(
                    value: currentMilliseconds,
                    min: 0,
                    max: maxMilliseconds,
                    onChanged: (value) {
                      controller.seekTo(Duration(milliseconds: value.toInt()));
                    },
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  _formatDuration(duration),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
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
}
