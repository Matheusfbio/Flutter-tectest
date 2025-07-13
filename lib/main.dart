// Importa o pacote principal do Flutter para construção de interfaces
import 'package:flutter/material.dart';

// Importa a tela principal do app, onde os posts são exibidos
import 'package:flutter_tectest/views/post_screen.dart';

// Importa o provider responsável por gerenciar os posts favoritos
import 'package:flutter_tectest/provider/favorite_provider.dart';

// Importa o Provider, usado para gerenciamento de estado no Flutter
import 'package:provider/provider.dart';

// Função principal que inicializa o aplicativo
void main() {
  runApp(
    // Envolve o app com ChangeNotifierProvider para fornecer o FavoriteProvider
    ChangeNotifierProvider(
      // Cria uma instância de FavoriteProvider
      create: (_) => FavoriteProvider(),
      // Define o widget principal do app como filho
      child: const MyApp(),
    ),
  );
}

// Classe principal do app, representando o widget raiz
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove a faixa de "DEBUG" do canto superior direito
      debugShowCheckedModeBanner: false,
      // Define a tela inicial como sendo o PostScreen (lista de posts)
      home: PostScreen(),
    );
  }
}
