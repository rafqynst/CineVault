import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../data/models/video_item.dart';
import '../widgets/player_controls.dart';
import '../../../../data/repositories/last_played_repository.dart';
import '../../../../data/models/last_played_model.dart';
import '../widgets/favorite_overlay.dart';
import '../widgets/favorite_video_list.dart';

class PlayerPage extends StatefulWidget {
  final VideoItem video;

  const PlayerPage({super.key, required this.video});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late VideoPlayerController _controller;
  late VideoItem _currentVideo;

  final LastPlayedRepository _lastPlayedRepository = LastPlayedRepository();

  bool _controlsVisible = true;
  bool _isLandscape = false;

  // ============================================================
  // VOLUME
  // ============================================================

  bool _isVolumeGesture = false;
  bool _showVolumeIndicator = false;
  double _volume = 1.0;

  // ============================================================
  // BRIGHTNESS
  // ============================================================

  bool _isBrightnessGesture = false;
  bool _showBrightnessIndicator = false;
  double _brightness = 1.0;

  // ============================================================
  // DOUBLE / TRIPLE TAP
  // ============================================================

  Timer? _tapTimer;
  Timer? _skipIndicatorTimer;

  int _tapCount = 0;

  // true  = sisi kanan
  // false = sisi kiri
  bool _isTapOnRightSide = false;

  bool _showSkipIndicator = false;
  int _skipSeconds = 0;

  bool _isFavoritePanelOpen = false;

  @override
  void initState() {
    super.initState();

    _enterFullscreen();
    _enableWakelock();

    _currentVideo = widget.video;

    _controller = VideoPlayerController.file(File(_currentVideo.path))
      ..addListener(_videoListener)
      ..initialize().then((_) {
        _onPlayerInitialized();
      });

    _loadBrightness();
  }

  // ============================================================
  // PLAYER INITIALIZATION
  // ============================================================

  void _enableWakelock() {
    WakelockPlus.enable();
  }

  void _disableWakelock() {
    WakelockPlus.disable();
  }

  void _videoListener() {
    if (!mounted) return;

    setState(() {});
  }

  Future<void> _onPlayerInitialized() async {
    if (!mounted) return;

    _volume = _controller.value.volume;

    await _loadBrightness();

    await _loadResumePosition();

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _switchVideo(VideoItem video) async {
    if (video.id == _currentVideo.id) {
      setState(() {
        _isFavoritePanelOpen = false;
      });
      return;
    }

    // Simpan posisi video yang sedang diputar.
    await _saveLastPlayed();

    if (!mounted) return;

    // Lepaskan controller lama.
    _controller.removeListener(_videoListener);
    await _controller.pause();
    await _controller.dispose();

    if (!mounted) return;

    setState(() {
      _currentVideo = video;
      _isFavoritePanelOpen = false;
    });

    // Siapkan controller untuk video baru.
    _controller = VideoPlayerController.file(File(_currentVideo.path))
      ..addListener(_videoListener);

    try {
      await _controller.initialize();

      if (!mounted) return;

      await _controller.setVolume(_volume);

      await _onPlayerInitialized();

      if (!mounted) return;

      await _controller.play();
    } catch (error) {
      debugPrint('Gagal mengganti video: $error');

      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video tidak dapat diputar.')),
        );
      }
    }
  }

  Future<void> _loadResumePosition() async {
    try {
      final lastPlayed = await _lastPlayedRepository.getLastPlayed();

      if (lastPlayed == null) return;

      // Pastikan data Last Played adalah video yang sedang dibuka.
      if (lastPlayed.videoId != _currentVideo.id) return;

      final position = Duration(milliseconds: lastPlayed.position);

      final duration = _controller.value.duration;

      // Jangan melakukan seek jika posisi sudah tidak valid.
      if (position <= Duration.zero) return;

      // Jika posisi sudah mencapai akhir video,
      // mulai kembali dari awal.
      if (position >= duration) {
        await _controller.seekTo(Duration.zero);
        return;
      }

      await _controller.seekTo(position);
    } catch (_) {
      // Resume tidak boleh membuat PlayerPage gagal dibuka.
    }
  }

  Future<void> _saveLastPlayed() async {
    if (!_controller.value.isInitialized) return;

    final position = _controller.value.position;
    final duration = _controller.value.duration;

    final lastPlayed = LastPlayedModel(
      id: 1,
      videoId: _currentVideo.id,
      videoPath: _currentVideo.path,
      videoName: _currentVideo.displayName,
      position: position.inMilliseconds,
      duration: duration.inMilliseconds,
      lastPlayed: DateTime.now(),
    );

    await _lastPlayedRepository.saveLastPlayed(lastPlayed);
  }

  Future<void> _loadBrightness() async {
    try {
      final brightness = await ScreenBrightness().application;

      if (!mounted) return;

      setState(() {
        _brightness = brightness.clamp(0.0, 1.0);
      });
    } catch (_) {
      _brightness = 1.0;
    }
  }

  // ============================================================
  // FULLSCREEN
  // ============================================================

  void _enterFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _restoreSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  // ============================================================
  // ORIENTATION
  // ============================================================

  Future<void> _toggleOrientation() async {
    if (_isLandscape) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      if (!mounted) return;

      setState(() {
        _isLandscape = false;
      });
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      if (!mounted) return;

      setState(() {
        _isLandscape = true;
      });
    }

    _enterFullscreen();
  }

  // ============================================================
  // PLAY / PAUSE
  // ============================================================

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }

    if (!mounted) return;

    setState(() {});
  }

  // ============================================================
  // CONTROLS
  // ============================================================

  void _toggleControls() {
    if (!mounted) return;

    setState(() {
      _controlsVisible = !_controlsVisible;
    });
  }

  // ============================================================
  // VIDEO TAP
  // ============================================================

  void _handleVideoTapDown(TapDownDetails details, double videoWidth) {
    _isTapOnRightSide = details.localPosition.dx > videoWidth / 2;
  }

  void _handleVideoTap() {
    _tapCount++;

    // Kalau sudah 3 tap, langsung proses sebagai
    // skip 30 detik.
    if (_tapCount == 3) {
      _tapTimer?.cancel();

      _performSkip(
        seconds: _isTapOnRightSide ? 10 : -10,
        isForward: _isTapOnRightSide,
      );

      _resetTapState();
      return;
    }

    // Tunggu sebentar untuk melihat apakah ada
    // tap kedua atau ketiga.
    _tapTimer?.cancel();

    _tapTimer = Timer(const Duration(milliseconds: 300), () {
      if (_tapCount == 2) {
        _performSkip(
          seconds: _isTapOnRightSide ? 5 : -5,
          isForward: _isTapOnRightSide,
        );
      } else if (_tapCount == 1) {
        // Single tap hanya berfungsi Play/Pause
        // ketika kontrol sedang tersembunyi.
        if (!_controlsVisible) {
          _togglePlayPause();
        }
      }

      _resetTapState();
    });
  }

  void _resetTapState() {
    _tapCount = 0;
    _tapTimer = null;
  }

  // ============================================================
  // SKIP / SEEK
  // ============================================================

  void _performSkip({required int seconds, required bool isForward}) {
    if (!_controller.value.isInitialized) return;

    final currentPosition = _controller.value.position;
    final duration = _controller.value.duration;

    final targetPosition = currentPosition + Duration(seconds: seconds);

    final clampedPosition = Duration(
      milliseconds: targetPosition.inMilliseconds.clamp(
        0,
        duration.inMilliseconds,
      ),
    );

    _controller.seekTo(clampedPosition);

    _showSkipFeedback(seconds: seconds.abs(), isForward: isForward);
  }

  void _showSkipFeedback({required int seconds, required bool isForward}) {
    _skipIndicatorTimer?.cancel();

    if (!mounted) return;

    setState(() {
      _skipSeconds = seconds;
      _showSkipIndicator = true;
    });

    _skipIndicatorTimer = Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;

      setState(() {
        _showSkipIndicator = false;
      });
    });
  }

  // ============================================================
  // LONG PRESS
  // ============================================================

  void _handleVideoLongPress() {
    // Batalkan kemungkinan tap yang sedang menunggu.
    _tapTimer?.cancel();
    _resetTapState();

    _toggleControls();
  }

  // ============================================================
  // VERTICAL GESTURE
  // ============================================================

  void _handleVerticalDragStart(DragStartDetails details, double videoWidth) {
    final isRightSide = details.localPosition.dx > videoWidth / 2;

    _isVolumeGesture = isRightSide;
    _isBrightnessGesture = !isRightSide;

    if (_isVolumeGesture) {
      _volume = _controller.value.volume;

      setState(() {
        _showVolumeIndicator = true;
        _showBrightnessIndicator = false;
      });
    }

    if (_isBrightnessGesture) {
      setState(() {
        _showBrightnessIndicator = true;
        _showVolumeIndicator = false;
      });
    }
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    if (_isVolumeGesture) {
      _updateVolume(details);
      return;
    }

    if (_isBrightnessGesture) {
      _updateBrightness(details);
    }
  }

  void _updateVolume(DragUpdateDetails details) {
    if (!_controller.value.isInitialized) return;

    const sensitivity = 0.0025;

    final newVolume = (_volume - details.delta.dy * sensitivity).clamp(
      0.0,
      1.0,
    );

    _volume = newVolume;

    _controller.setVolume(_volume);

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _updateBrightness(DragUpdateDetails details) async {
    const sensitivity = 0.0025;

    final newBrightness = (_brightness - details.delta.dy * sensitivity).clamp(
      0.0,
      1.0,
    );

    _brightness = newBrightness;

    try {
      await ScreenBrightness().setApplicationScreenBrightness(_brightness);
    } catch (_) {
      // Abaikan jika sistem menolak perubahan.
    }

    if (!mounted) return;

    setState(() {});
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    _isVolumeGesture = false;
    _isBrightnessGesture = false;

    if (!mounted) return;

    setState(() {
      _showVolumeIndicator = false;
      _showBrightnessIndicator = false;
    });
  }

  // ============================================================
  // VOLUME INDICATOR
  // ============================================================

  IconData _getVolumeIcon() {
    if (_volume <= 0) {
      return Icons.volume_off_rounded;
    }

    if (_volume < 0.5) {
      return Icons.volume_down_rounded;
    }

    return Icons.volume_up_rounded;
  }

  int get _volumePercentage {
    return (_volume * 100).round();
  }

  // ============================================================
  // BRIGHTNESS INDICATOR
  // ============================================================

  int get _brightnessPercentage {
    return (_brightness * 100).round();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _tapTimer?.cancel();
    _skipIndicatorTimer?.cancel();

    SystemChrome.setPreferredOrientations([]);

    _controller.removeListener(_videoListener);
    _controller.dispose();

    _disableWakelock();
    _restoreSystemUI();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        await _saveLastPlayed();

        if (!mounted) return;

        navigator.pop();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    children: [
                      _buildVideo(),

                      PlayerControls(
                        controller: _controller,
                        onPlayPause: _togglePlayPause,
                        onToggleOrientation: _toggleOrientation,
                        onBack: () async {
                          await _saveLastPlayed();

                          if (!mounted) return;

                          navigator.pop();
                        },
                        isLandscape: _isLandscape,
                        visible: _controlsVisible,
                      ),

                      _buildVolumeIndicator(),
                      _buildBrightnessIndicator(),
                      _buildSkipIndicator(),
                      FavoriteOverlay(
                        isOpen: _isFavoritePanelOpen,
                        controlsVisible: _controlsVisible,
                        onToggle: () {
                          setState(() {
                            _isFavoritePanelOpen = !_isFavoritePanelOpen;
                          });
                        },
                        child: FavoriteVideoList(
                          onClose: () {
                            setState(() {
                              _isFavoritePanelOpen = false;
                            });
                          },
                          onVideoSelected: _switchVideo,
                        ),
                      ),
                    ],
                  ),
                )
              : const CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }

  // ============================================================
  // VIDEO + GESTURE
  // ============================================================

  Widget _buildVideo() {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,

            onTapDown: (details) {
              _handleVideoTapDown(details, constraints.maxWidth);
            },

            onTap: _handleVideoTap,

            onLongPress: _handleVideoLongPress,

            onVerticalDragStart: (details) {
              _handleVerticalDragStart(details, constraints.maxWidth);
            },

            onVerticalDragUpdate: _handleVerticalDragUpdate,

            onVerticalDragEnd: _handleVerticalDragEnd,

            child: VideoPlayer(_controller),
          );
        },
      ),
    );
  }

  // ============================================================
  // VOLUME INDICATOR
  // ============================================================

  Widget _buildVolumeIndicator() {
    if (!_showVolumeIndicator) {
      return const SizedBox.shrink();
    }

    return Positioned(
      right: 24,
      top: 0,
      bottom: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getVolumeIcon(), color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                '$_volumePercentage%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BRIGHTNESS INDICATOR
  // ============================================================

  Widget _buildBrightnessIndicator() {
    if (!_showBrightnessIndicator) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 24,
      top: 0,
      bottom: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.brightness_6_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                '$_brightnessPercentage%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SKIP INDICATOR
  // ============================================================

  Widget _buildSkipIndicator() {
    if (!_showSkipIndicator) {
      return const SizedBox.shrink();
    }

    final isForward = _isTapOnRightSide;

    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isForward
                      ? Icons.forward_10_rounded
                      : Icons.replay_10_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  isForward ? '+$_skipSeconds detik' : '-$_skipSeconds detik',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
