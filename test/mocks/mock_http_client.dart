// Importa a biblioteca HTTP para fazer requisições HTTP
import 'package:http/http.dart' as http;

// Importa a anotação para gerar mocks usando o Mockito
import 'package:mockito/annotations.dart';

// Anotação que indica para o Mockito gerar uma classe mock para http.Client
// Essa classe mock pode ser usada em testes para simular o comportamento do cliente HTTP real
@GenerateMocks([http.Client])
// Função principal vazia porque o foco aqui é gerar mocks para testes
void main() {}
