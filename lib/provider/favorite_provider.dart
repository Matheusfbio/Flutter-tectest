import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  int get count => _favorites.length;

  FavoriteProvider() {
    loadFavorites();
  }

  bool isFavorite(Map<String, dynamic> post) {
    return _favorites.any((p) => p['id'] == post['id']);
  }

  void toggleFavorite(Map<String, dynamic> post) {
    if (isFavorite(post)) {
      _favorites.removeWhere((p) => p['id'] == post['id']);
    } else {
      _favorites.add(post);
    }

    saveFavorites();
    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_favorites);
    await prefs.setString('favorites', jsonString);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('favorites');
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      _favorites = decoded.cast<Map<String, dynamic>>();
      notifyListeners();
    }
  }
}
