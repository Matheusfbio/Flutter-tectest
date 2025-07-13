import 'package:flutter/material.dart';
import 'package:flutter_tectest/provider/favorite_provider.dart';
import 'package:provider/provider.dart';

class PostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  // bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final title = post['title'] ?? 'Sem título';
    final body = post['body'] ?? 'Sem conteúdo';
    final tags = (post['tags'] as List?)?.join(', ') ?? 'Sem tags';
    final favoriteProvider = Provider.of<FavoriteProvider>(
      context,
      listen: false,
    );
    final isFavorite = favoriteProvider.isFavorite(post);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título e Favorito
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              favoriteProvider.toggleFavorite(post);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Corpo
                    Text(
                      body,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 30),

                    // Tags
                    Row(
                      children: [
                        const Icon(Icons.label_outline, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tags: $tags',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Reações
                    Row(
                      children: [
                        const Icon(Icons.favorite_border, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'likes: ${post['reactions']['likes']}, dislikes: ${post['reactions']['dislikes']}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
