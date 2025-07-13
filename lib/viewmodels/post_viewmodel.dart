import 'package:flutter/material.dart';
import '../core/services/api_service.dart';

class PostViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> _posts = [];
  final List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get posts => _posts;
  List<Map<String, dynamic>> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _apiService.fetchPosts();
      _posts = List<Map<String, dynamic>>.from(data);
      _error = null;
    } catch (e) {
      _error = 'Erro ao buscar os posts';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(Map<String, dynamic> post) {
    if (_favorites.contains(post)) {
      _favorites.remove(post);
    } else {
      _favorites.add(post);
    }
    notifyListeners();
  }

  bool isFavorite(Map<String, dynamic> post) {
    return _favorites.contains(post);
  }
}
