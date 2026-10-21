import 'package:flutter/foundation.dart';

import '../data/models/last_played_model.dart';
import '../data/repositories/last_played_repository.dart';

class LastPlayedProvider extends ChangeNotifier {
  final LastPlayedRepository _repository;

  LastPlayedProvider({LastPlayedRepository? repository})
      : _repository = repository ?? LastPlayedRepository();

  LastPlayedModel? _lastPlayed;
  bool _isLoading = false;
  String? _errorMessage;

  LastPlayedModel? get lastPlayed => _lastPlayed;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get hasLastPlayed => _lastPlayed != null;

  Future<void> loadLastPlayed() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lastPlayed = await _repository.getLastPlayed();
    } catch (e) {
      _errorMessage = 'Gagal memuat Last Played.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadLastPlayed();
  }
}