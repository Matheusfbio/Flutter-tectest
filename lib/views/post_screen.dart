// Importa funcionalidades para detectar erros de rede (como SocketException)
import 'dart:io';

// Importa o pacote base do Flutter para construção da UI
import 'package:flutter/material.dart';

// Importa o serviço de API que busca os posts
import 'package:flutter_tectest/core/services/api_service.dart';

// Importa o provider de favoritos
import 'package:flutter_tectest/provider/favorite_provider.dart';

// Importa a tela de detalhes do post
import 'package:flutter_tectest/views/post_details_screen.dart';

// Importa a tela de favoritos
import 'package:flutter_tectest/views/favorite_screen.dart';

// Importa o provider para gerenciamento de estado
import 'package:provider/provider.dart';

// Tela principal que exibe a lista de posts
class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  // Variável que armazena a Future da API
  late Future<List<dynamic>> _posts;

  // Controlador para o campo de busca
  final TextEditingController _searchController = TextEditingController();

  // Lista completa de posts
  List<dynamic> _allPosts = [];

  // Lista filtrada de posts (exibida na tela)
  List<dynamic> _filteredPosts = [];

  @override
  void initState() {
    super.initState();
    // Busca os posts ao iniciar e inicializa as listas
    _posts = ApiService().fetchPosts().then((posts) {
      _allPosts = posts;
      _filteredPosts = posts;
      return posts;
    });
  }

  // Função que filtra os posts com base no título buscado
  void _filterPosts(String query) {
    final filtered =
        _allPosts.where((post) {
          final title = post['title']?.toString().toLowerCase() ?? '';
          return title.contains(query.toLowerCase());
        }).toList();

    setState(() {
      _filteredPosts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Acessa o provider de favoritos
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Ícone de favoritos com contador
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  // Navega para a tela de favoritos
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => FavoriteScreen(
                            favorites: favoriteProvider.favorites,
                          ),
                    ),
                  );
                },
              ),
              // Exibe o contador de favoritos
              if (favoriteProvider.count > 0)
                Positioned(
                  right: 8,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${favoriteProvider.count}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      // Permite puxar para atualizar os dados
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _posts = ApiService().fetchPosts().then((posts) {
              _allPosts = posts;
              _filteredPosts = posts;
              return posts;
            });
          });
        },
        // Constrói o conteúdo com base na resposta da Future
        child: FutureBuilder<List<dynamic>>(
          future: _posts,
          builder: (context, snapshot) {
            // Enquanto os dados estão sendo carregados
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // Se houve erro
            else if (snapshot.hasError) {
              final error = snapshot.error;

              // Se for erro de conexão
              if (error is SocketException) {
                return ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: const Center(
                        child: Text(
                          'Sem conexão com a internet.',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                );
              }
              // Outros erros
              else {
                return ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(
                        child: Text(
                          'Erro ao carregar dados: $error',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
            // Se os dados foram carregados corretamente
            else {
              return Column(
                children: [
                  // Campo de busca
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Buscar por título',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: _filterPosts,
                    ),
                  ),

                  // Lista dos posts
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = _filteredPosts[index];
                        final title = post['title'] ?? 'Sem título';
                        final body = post['body'] ?? 'Sem conteúdo';
                        final isFavorite = favoriteProvider.isFavorite(post);

                        return GestureDetector(
                          onTap: () {
                            // Navega para a tela de detalhes
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
                                  // Título + ícone de favorito
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color:
                                              isFavorite
                                                  ? Colors.red
                                                  : Colors.grey,
                                        ),
                                        onPressed: () {
                                          // Alterna favorito ao clicar
                                          favoriteProvider.toggleFavorite(post);
                                        },
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Corpo do post
                                  Text(
                                    body,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
