
import 'package:flutter/material.dart';

import '../data/models/video_item.dart';
import '../data/repositories/favorite_repository.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteRepository _repository;

  FavoriteProvider(this._repository);

  List<Map<String, Object?>> _favorites = [];

  bool _isLoading = false;
  String? _message;

  List<Map<String, Object?>> get favorites =>
      List.unmodifiable(_favorites);

  Set<String> get favoriteIds => _favorites
      .map((item) => item['video_id'] as String)
      .toSet();

  bool get isLoading => _isLoading;

  String? get message => _message;

  bool isFavorite(String videoId) {
    return favoriteIds.contains(videoId);
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    try {
      _favorites = await _repository.getFavorites();
    } catch (e) {
      _message = 'Gagal memuat daftar favorit.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(VideoItem video) async {
    final alreadyFavorite = isFavorite(video.id);

    try {
      if (alreadyFavorite) {
        await _repository.removeFavorite(video.id);
      } else {
        await _repository.addFavorite(
          videoId: video.id,
          videoPath: video.path,
          videoName: video.displayName,
        );
      }

      await loadFavorites();
    } catch (e) {
      _message = 'Gagal memperbarui favorit.';
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String videoId) async {
    try {
      await _repository.removeFavorite(videoId);
      await loadFavorites();
    } catch (e) {
      _message = 'Gagal menghapus favorit.';
      notifyListeners();
    }
  }
}
