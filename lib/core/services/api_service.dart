import 'dart:convert';
import 'package:http/http.dart' as http;

/// Serviço para realizar chamadas HTTP e buscar dados de posts.
class ApiService {
  // URL base da API
  static const String baseUrl = "https://dummyjson.com";

  // Cliente HTTP para fazer requisições, pode ser injetado para testes
  final http.Client client;

  // Construtor que permite passar um cliente HTTP ou cria um novo por padrão
  ApiService({http.Client? client}) : client = client ?? http.Client();

  /// Busca a lista de posts da API
  Future<List<dynamic>> fetchPosts() async {
    // Monta a URL completa para buscar os posts
    final url = Uri.parse('$baseUrl/posts');
    // Faz uma requisição GET para a URL usando o cliente HTTP
    final response = await http.get(url);

    // Verifica se a resposta teve sucesso (status code 200)
    if (response.statusCode == 200) {
      // Decodifica o corpo da resposta JSON para Map
      final data = jsonDecode(response.body);
      // Retorna a lista contida na chave 'posts' do JSON
      return data['posts'];
    } else {
      // Em caso de erro, imprime o código de status e corpo da resposta
      print('Erro statusCode: ${response.statusCode}');
      print('Resposta: ${response.body}');
      // Lança uma exceção para indicar falha na requisição
      throw Exception('Erro ao buscar os posts');
    }
  }
}
