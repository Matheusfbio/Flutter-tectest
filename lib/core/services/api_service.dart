import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://dummyjson.com";

  Future<List<dynamic>> fetchPosts() async {
    final url = Uri.parse('$baseUrl/posts');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['posts']; // aqui a chave 'posts' contém a lista
    } else {
      print('Erro statusCode: ${response.statusCode}');
      print('Resposta: ${response.body}');
      throw Exception('Erro ao buscar os posts');
    }
  }
}
