# flutter_tectest

Aplicativo Flutter para exibição, detalhamento e gerenciamento de favoritos de posts utilizando uma API pública.

## Visão Geral

Este projeto foi desenvolvido com o objetivo de demonstrar boas práticas em Flutter, incluindo gerenciamento de estado, persistência local e consumo de APIs REST. O app permite listar posts, visualizar detalhes e favoritar/desfavoritar itens, com persistência dos favoritos.

## Decisões Técnicas

### 1. **Gerenciamento de Estado**

Optou-se pelo pacote [`provider`](https://pub.dev/packages/provider) por ser leve, fácil de implementar e recomendado pela equipe Flutter para projetos de pequeno e médio porte. O estado dos posts e favoritos é centralizado em `PostViewModel` e `FavoriteProvider`.

### 2. **Persistência Local**

Para salvar os favoritos, foi utilizado o [`shared_preferences`](https://pub.dev/packages/shared_preferences), que permite armazenar dados simples localmente sem complexidade adicional.

### 3. **Consumo de API**

A comunicação com a API ([dummyjson.com](https://dummyjson.com)) é feita via pacote [`http`](https://pub.dev/packages/http), garantindo simplicidade e eficiência nas requisições.

### 4. **Arquitetura**

O projeto foi dividido em camadas utilizando MVVM:

- **Services:** Comunicação com API.
- **ViewModels/Providers:** Gerenciamento de estado e lógica de negócio.
- **Views:** Telas e componentes visuais.

Essa separação facilita manutenção, testes e escalabilidade.

### 5. **Interface**

Utiliza Material Design para garantir uma experiência consistente e responsiva.

## Estrutura de Pastas

```
lib/
├── core/
│   └── services/
│       └── api_service.dart
├── provider/
│   └── favorite_provider.dart
├── viewmodels/
│   └── post_viewmodel.dart
├── views/
│   ├── post_screen.dart
│   ├── post_details_screen.dart
│   └── favorite_screen.dart
└── main.dart
```

## Instruções de Execução

1. **Instale as dependências:**

   ```sh
   flutter pub get
   ```

2. **Execute o aplicativo:**

   ```sh
   flutter run
   ```

3. **Testes (se houver):**
   ```sh
   flutter test
   ```

## Como Usar

- **Listagem:** A tela inicial exibe todos os posts.
- **Detalhes:** Toque em um post para ver detalhes completos.
- **Favoritar:** Use o ícone de favorito para adicionar/remover posts dos favoritos.
- **Favoritos:** Acesse a tela de favoritos para visualizar todos os posts marcados.

## Considerações Finais

- O projeto é modular e pode ser expandido facilmente.
- O uso de Provider e SharedPreferences garante performance e persistência sem complexidade.
- O código está comentado para facilitar entendimento e manutenção.

## Licença

Projeto de demonstração para fins educacionais.

---

Dúvidas ou sugestões? Abra uma issue ou entre em contato!
