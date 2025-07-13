import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tectest/core/services/api_service.dart';
import 'package:mockito/mockito.dart';

import 'mock_http_client.mocks.dart';

void main() {
  group('ApiService', () {
    late MockClient mockClient;
    late ApiService apiService;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiService(client: mockClient);
    });

    test('retorna lista de posts quando statusCode for 200', () async {
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

      when(
        mockClient.get(Uri.parse('https://dummyjson.com/posts')),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final posts = await apiService.fetchPosts();

      expect(posts.length, 30);
      expect(posts[0]['title'], "His mother had always taught him");
    });
  });
}
