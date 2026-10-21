
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../data/models/video_item.dart';
import '../../../../data/services/thumbnail_service.dart';
import 'video_placeholder.dart';

class VideoThumbnailWidget extends StatefulWidget {
  final VideoItem video;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const VideoThumbnailWidget({
    super.key,
    required this.video,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(16),
    ),
  });

  @override
  State<VideoThumbnailWidget> createState() =>
      _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState
    extends State<VideoThumbnailWidget> {
  static const ThumbnailService _thumbnailService =
      ThumbnailService();

  String? _thumbnailPath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _thumbnailPath = widget.video.thumbnailPath;
    _loadThumbnail();
  }

  @override
  void didUpdateWidget(covariant VideoThumbnailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.path != widget.video.path) {
      _thumbnailPath = widget.video.thumbnailPath;
      _loadThumbnail();
    }
  }

  Future<void> _loadThumbnail() async {
    if (_thumbnailPath != null || _isLoading) return;

    _isLoading = true;

    try {
      final result = await _thumbnailService.getThumbnail(
        widget.video.path,
      );

      if (!mounted) return;

      setState(() {
        _thumbnailPath = result;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;

    return Hero(
      tag: video.id,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: _buildThumbnail(video),
        ),
      ),
    );
  }

  Widget _buildThumbnail(VideoItem video) {
    if (video.thumbnailBytes != null) {
      return Image.memory(
        video.thumbnailBytes!,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) {
          return _buildFileThumbnail(video);
        },
      );
    }

    return _buildFileThumbnail(video);
  }

  Widget _buildFileThumbnail(VideoItem video) {
    final thumbnailPath =
        _thumbnailPath ?? video.thumbnailPath;

    if (thumbnailPath != null) {
      return Image.file(
        File(thumbnailPath),
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) {
          return VideoPlaceholder(video: video);
        },
      );
    }

    return VideoPlaceholder(video: video);
  }
}
