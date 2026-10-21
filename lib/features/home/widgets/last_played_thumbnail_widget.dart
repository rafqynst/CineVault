import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class LastPlayedThumbnailWidget extends StatefulWidget {
  final String videoPath;
  final int position;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const LastPlayedThumbnailWidget({
    super.key,
    required this.videoPath,
    required this.position,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(14),
    ),
  });

  @override
  State<LastPlayedThumbnailWidget> createState() =>
      _LastPlayedThumbnailWidgetState();
}

class _LastPlayedThumbnailWidgetState
    extends State<LastPlayedThumbnailWidget> {
  Uint8List? _thumbnailBytes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  @override
  void didUpdateWidget(LastPlayedThumbnailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.videoPath != widget.videoPath ||
        oldWidget.position != widget.position) {
      _generateThumbnail();
    }
  }

  Future<void> _generateThumbnail() async {
    setState(() {
      _isLoading = true;
      _thumbnailBytes = null;
    });

    try {
      final bytes = await VideoThumbnail.thumbnailData(
        video: widget.videoPath,
        imageFormat: ImageFormat.JPEG,
        timeMs: widget.position,
        maxWidth: 300,
        quality: 75,
      );

      if (!mounted) return;

      setState(() {
        _thumbnailBytes = bytes;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _thumbnailBytes = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const ColoredBox(
        color: Colors.black26,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white54,
            ),
          ),
        ),
      );
    }

    if (_thumbnailBytes != null) {
      return Image.memory(
        _thumbnailBytes!,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    }

    return const ColoredBox(
      color: Colors.black26,
      child: Center(
        child: Icon(
          Icons.play_circle_outline_rounded,
          color: Colors.white54,
          size: 30,
        ),
      ),
    );
  }
}