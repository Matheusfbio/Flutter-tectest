// Importa o material para widgets e o serviço de API
import 'package:flutter/material.dart';
import '../core/services/api_service.dart';

/// View‑Model no padrão **MVVM**.
/// Mantém o estado da lista de posts, favoritos, carregamento e erros.
class PostViewModel extends ChangeNotifier {
  // Instância do serviço que faz as requisições HTTP
  final ApiService _apiService = ApiService();

  // ----------------- ESTADO PRIVADO -----------------
  List<Map<String, dynamic>> _posts = []; // Lista completa de posts
  final List<Map<String, dynamic>> _favorites =
      []; // Lista de posts favoritados
  bool _isLoading = false; // Flag de carregamento
  String? _error; // Mensagem de erro (se houver)

  // ----------------- GETTERS PÚBLICOS -----------------
  List<Map<String, dynamic>> get posts => _posts;
  List<Map<String, dynamic>> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Busca os posts na API e atualiza o estado.
  Future<void> fetchPosts() async {
    _isLoading = true; // Inicia o indicador de loading
    notifyListeners(); // Notifica a UI para exibir o loader

    try {
      final data = await _apiService.fetchPosts(); // Chamada HTTP
      _posts = List<Map<String, dynamic>>.from(
        data,
      ); // Converte para lista tipada
      _error = null; // Limpa erros anteriores
    } catch (e) {
      _error = 'Erro ao buscar os posts'; // Define mensagem de erro
    } finally {
      _isLoading = false; // Finaliza o loading
      notifyListeners(); // Atualiza a UI (com dados ou erro)
    }
  }

  /// Adiciona ou remove um post da lista de favoritos.
  void toggleFavorite(Map<String, dynamic> post) {
    if (_favorites.contains(post)) {
      _favorites.remove(post); // Remove se já for favorito
    } else {
      _favorites.add(post); // Adiciona se não for
    }
    notifyListeners(); // Notifica a mudança
  }

  /// Verifica se um post está marcado como favorito.
  bool isFavorite(Map<String, dynamic> post) {
    return _favorites.contains(post);
  }
}
