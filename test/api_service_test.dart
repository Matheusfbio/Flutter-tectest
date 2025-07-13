// Importa a biblioteca padrão do Dart para codificação e decodificação JSON
import 'dart:convert';

// Importa o pacote de testes do Flutter
import 'package:flutter_test/flutter_test.dart';

// Importa a biblioteca http para fazer requisições HTTP
import 'package:http/http.dart' as http;

// Importa o serviço da sua aplicação que você deseja testar
import 'package:flutter_tectest/core/services/api_service.dart';

// Importa as funções do Mockito para simular comportamentos
import 'package:mockito/mockito.dart';

// Importa o mock do cliente HTTP gerado pelo Mockito
import 'mocks/mock_http_client.mocks.dart';

void main() {
  // Define um grupo de testes relacionados ao ApiService
  group('ApiService', () {
    // Declara as variáveis que serão usadas nos testes
    late MockClient mockClient;
    late ApiService apiService;

    // Executado antes de cada teste individual
    setUp(() {
      mockClient = MockClient(); // Cria uma instância mock do http.Client
      apiService = ApiService(
        client: mockClient,
      ); // Injeta o mock no ApiService
    });

    // Define um teste específico dentro do grupo
    test('retorna lista de posts quando statusCode for 200', () async {
      // Simula a resposta da API com apenas 1 post para teste
      final mockResponse = {
        "posts": [
          {
            "id": 1,
            "title": "His mother had always taught him",
            "body":
                "His mother had always taught him not to ever think of himself as better than others. He'd tried to live by this motto. He never looked down on those who were less fortunate or who had less money than him. But the stupidity of the group of people he was talking to made him change his mind.",
            "tags": ["history", "american", "crime"],
            "reactions": {"likes": 192, "dislikes": 25},
            "views": 305,
          },
        ],
      };

      // Define o comportamento simulado do mockClient
      // Sempre que for feita uma requisição GET para esse URL, retornará a resposta simulada acima com status 200
      when(
        mockClient.get(Uri.parse('https://dummyjson.com/posts')),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      // Chama o método a ser testado
      final posts = await apiService.fetchPosts();

      // Verificações: Espera-se que a lista contenha 30 elementos (mas o mock só tem 1 — isso causará falha)
      expect(posts.length, 30); // ⚠️ Pode falhar! O mock só tem 1 post
      expect(posts[0]['title'], "His mother had always taught him");
    });
  });
}
