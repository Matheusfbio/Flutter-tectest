import 'package:flutter/material.dart';
import 'package:flutter_tectest/core/services/api_service.dart';
import 'package:flutter_tectest/views/post_details_screen.dart';
import 'package:flutter_tectest/views/favorite_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Future<List<dynamic>> _posts;
  List<Map<String, dynamic>> favoritePosts = [];

  @override
  void initState() {
    super.initState();
    _posts = ApiService().fetchPosts();
  }

  void toggleFavorite(Map<String, dynamic> post) {
    setState(() {
      if (favoritePosts.contains(post)) {
        favoritePosts.remove(post);
      } else {
        favoritePosts.add(post);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                children: [
                  Icon(Icons.post_add_rounded, size: 120, color: Colors.white),
                  SizedBox(height: 8),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favoritos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => FavoriteScreen(favorites: favoritePosts),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: \${snapshot.error}'));
          } else {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final post = posts[index];
                final title = post['title'] ?? 'Sem título';
                final body = post['body'] ?? 'Sem conteúdo';
                final reactions =
                    post['reactions'] ?? {'likes': 0, 'dislikes': 0};

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostDetailScreen(post: post),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  favoritePosts.contains(post)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      favoritePosts.contains(post)
                                          ? Colors.red
                                          : Colors.grey,
                                ),
                                onPressed: () => toggleFavorite(post),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            body,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14, height: 1.5),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(
                                Icons.label_outline,
                                color: Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Tags: \$tags',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'likes: ${reactions['likes']}, dislikes: ${reactions['dislikes']}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
