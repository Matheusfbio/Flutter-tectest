// Importações necessárias
import 'package:flutter/material.dart';
import 'package:flutter_tectest/provider/favorite_provider.dart';
import 'package:flutter_tectest/views/post_details_screen.dart';
import 'package:provider/provider.dart';

// Componente de tela para exibir os posts favoritos
class FavoriteScreen extends StatelessWidget {
  // Lista de favoritos passada como parâmetro
  final List<Map<String, dynamic>> favorites;

  const FavoriteScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    // Acesso ao provider de favoritos para manipulação (remover, etc.)
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Verifica se a lista de favoritos está vazia
      body:
          favorites.isEmpty
              ? const Center(child: Text('Nenhum post favoritado.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final post = favorites[index];
                  final title = post['title'] ?? 'Sem título';
                  final body = post['body'] ?? 'Sem conteúdo';

                  return GestureDetector(
                    // Ao tocar no card, navega para a tela de detalhes
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
                            // Linha com o título e botão de excluir
                            Row(
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
                                // Botão de deletar o post dos favoritos
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    // Remove o post dos favoritos
                                    favoriteProvider.toggleFavorite(post);

                                    // Exibe um feedback visual (snackbar)
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Post removido dos favoritos',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        backgroundColor: Colors.white,
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(seconds: 2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Exibição do corpo do post (limite de 3 linhas)
                            Text(
                              body,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, height: 1.5),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
