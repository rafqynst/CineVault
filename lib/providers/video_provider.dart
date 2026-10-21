import 'package:flutter/material.dart';

import '../core/constants/load_state.dart';
import '../core/result/result.dart';
import '../data/models/video_item.dart';
import '../data/repositories/video_repository.dart';

class VideoProvider extends ChangeNotifier {
  final VideoRepository _repository;

  VideoProvider(this._repository);

  LoadState _state = LoadState.initial;

  List<VideoItem> _videos = [];

  String? _message;

  LoadState get state => _state;

  List<VideoItem> get videos => List.unmodifiable(_videos);

  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  List<VideoItem> get filteredVideos {
    if (_searchQuery.trim().isEmpty) {
      return List.unmodifiable(_videos);
    }

    final query = _searchQuery.trim().toLowerCase();

    return List.unmodifiable(
      _videos.where((video) {
        return video.displayName.toLowerCase().contains(query);
      }),
    );
  }

  void searchVideos(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  String? get message => _message;

  Future<void> loadVideos() async {
    _state = LoadState.loading;
    notifyListeners();

    await _fetchVideos();
  }

  Future<void> refreshVideos() async {
    // Pertahankan tampilan saat ini selama refresh berlangsung.
    await _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    final result = await _repository.getVideos();

    switch (result) {
      case Success<List<VideoItem>>():
        _videos = result.data;
        _message = null;

        if (_videos.isEmpty) {
          _state = LoadState.empty;
        } else {
          _state = LoadState.loaded;
        }

      case Failure<List<VideoItem>>():
        _message = result.message;

        if (result.message == 'PERMISSION_DENIED') {
          _state = LoadState.permissionDenied;
        } else {
          _state = LoadState.error;
        }
    }

    notifyListeners();
  }
}
