import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider para gerenciar a lista de posts favoritos.
/// Utiliza ChangeNotifier para notificar a UI sobre mudanças.
class FavoriteProvider extends ChangeNotifier {
  // Lista interna de favoritos armazenados como mapas dinâmicos
  List<Map<String, dynamic>> _favorites = [];

  // Getter público para acessar a lista de favoritos
  List<Map<String, dynamic>> get favorites => _favorites;

  // Getter que retorna a quantidade de posts favoritos
  int get count => _favorites.length;

  // Construtor que carrega os favoritos salvos localmente ao iniciar
  FavoriteProvider() {
    loadFavorites();
  }

  /// Verifica se um post já está na lista de favoritos
  bool isFavorite(Map<String, dynamic> post) {
    // Retorna true se algum post na lista tiver o mesmo id
    return _favorites.any((p) => p['id'] == post['id']);
  }

  /// Adiciona ou remove um post da lista de favoritos
  void toggleFavorite(Map<String, dynamic> post) {
    if (isFavorite(post)) {
      // Se já é favorito, remove da lista
      _favorites.removeWhere((p) => p['id'] == post['id']);
    } else {
      // Se não é favorito, adiciona na lista
      _favorites.add(post);
    }

    // Salva a lista atualizada em SharedPreferences
    saveFavorites();
    // Notifica os ouvintes para atualizar a UI
    notifyListeners();
  }

  /// Salva a lista de favoritos no armazenamento local (SharedPreferences)
  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // Converte a lista de mapas para JSON string
    final jsonString = jsonEncode(_favorites);
    // Salva a string no SharedPreferences na chave 'favorites'
    await prefs.setString('favorites', jsonString);
  }

  /// Carrega a lista de favoritos do armazenamento local (SharedPreferences)
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('favorites');
    if (jsonString != null) {
      // Decodifica a string JSON para lista dinâmica
      final List<dynamic> decoded = jsonDecode(jsonString);
      // Converte a lista dinâmica para lista de Map<String, dynamic>
      _favorites = decoded.cast<Map<String, dynamic>>();
      // Notifica os ouvintes para atualizar a UI com os dados carregados
      notifyListeners();
    }
  }
}
