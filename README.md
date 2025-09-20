# App Todolist iOS

Um aplicativo moderno e completo de lista de tarefas para iOS, desenvolvido com SwiftUI, que integra Firebase para armazenamento em nuvem, Google Sign-In para autenticação e frases motivacionais para manter os usuários inspirados.

## 📱 Funcionalidades

### Funcionalidades Principais
- **Gerenciamento de Tarefas**: Criar, editar, excluir e organizar tarefas com títulos, descrições e datas de vencimento
- **Sincronização em Tempo Real**: As tarefas são armazenadas no Firebase Firestore e sincronizam entre dispositivos
- **Busca e Filtro**: Pesquisar nas tarefas para encontrar rapidamente o que você precisa
- **Conclusão de Tarefas**: Marcar tarefas como concluídas e acompanhar seu progresso

### Autenticação
- **Autenticação Firebase**: Registro e login seguros com email e senha
- **Google Sign-In**: Autenticação rápida usando contas Google
- **Gerenciamento de Sessão**: Estado de login persistente entre aberturas do app

### Recursos Inteligentes
- **Notificações Push**: Agendar notificações para datas de vencimento das tarefas
- **Frases Motivacionais**: Citações inspiradoras diárias obtidas da API Ninjas
- **Interface Responsiva**: Interface SwiftUI nativa otimizada para dispositivos iOS

## 🎥 Demonstração do Projeto

Veja o app em funcionamento no vídeo abaixo, que apresenta todas as funcionalidades principais:

[![Vídeo Demonstrativo do App Todolist iOS](https://img.youtube.com/vi/NR8Z3Jzv10g/maxresdefault.jpg)](https://www.youtube.com/watch?v=NR8Z3Jzv10g)

**[📺 Assistir Vídeo Demonstrativo no YouTube](https://www.youtube.com/watch?v=NR8Z3Jzv10g)**

O vídeo mostra:
- Interface de autenticação (login/signup)
- Integração com Google Sign-In
- Criação e edição de tarefas
- Sincronização em tempo real
- Sistema de notificações
- Funcionalidade de frases motivacionais
- Navegação e experiência do usuário

## 🚀 Como Executar

### Pré-requisitos
- **Xcode 15.0+** (com SDK do iOS 17.0+)
- **Dispositivo iOS ou Simulador** executando iOS 17.0+
- **Conta de Desenvolvedor Apple** (para testes em dispositivo físico)
- **Projeto Firebase** com Firestore e Autenticação habilitados

### Instruções de Configuração

1. **Clonar o Repositório**
   ```bash
   git clone https://github.com/guimaggiorini/checkpoint4-mobile.git
   cd checkpoint4-mobile
   ```

2. **Configuração do Firebase**
   - Criar um novo projeto Firebase no [Console Firebase](https://console.firebase.google.com)
   - Habilitar Autenticação (Email/Senha e Google Sign-In)
   - Habilitar Banco de Dados Firestore
   - Baixar o `GoogleService-Info.plist` e adicionar ao projeto Xcode
   - Garantir que o bundle ID corresponde à configuração do projeto Firebase

3. **Configuração do Google Sign-In**
   - No Console Firebase, vá para Authentication → Método de login
   - Habilitar o provedor Google Sign-In
   - Adicionar o bundle ID do seu app iOS às configurações OAuth

4. **Abrir no Xcode**
   ```bash
   open Todolist.xcodeproj
   ```

5. **Instalar Dependências**
   - O Xcode resolverá automaticamente as dependências do Swift Package Manager
   - Se necessário, vá para File → Add Package Dependencies e verifique se todos os pacotes estão instalados

6. **Configurar Assinatura**
   - Selecione sua equipe de desenvolvimento em Project Settings → Signing & Capabilities
   - Garantir que o identificador do bundle seja único

7. **Compilar e Executar**
   - Selecione seu dispositivo de destino ou simulador
   - Pressione `Cmd + R` ou clique no botão Run no Xcode

### Configuração da API

O app usa API Ninjas para frases motivacionais. A chave da API está atualmente incorporada no código, mas para uso em produção, você deve:

1. Obter sua própria chave da API em [API Ninjas](https://api.api-ninjas.com)
2. Substituir a chave em `QuotesStore.swift`
3. Considerar usar variáveis de ambiente ou armazenamento seguro para chaves de API

## 🛠 Bibliotecas e Frameworks Utilizados

### Frameworks da Apple
- **SwiftUI**: Framework moderno e declarativo para UI
- **Foundation**: Funcionalidades principais do Swift e estruturas de dados
- **UserNotifications**: Notificações push locais e remotas

### Firebase SDK (v12.3.0)
- **Firebase**: Funcionalidade principal do Firebase
- **FirebaseAuth**: Autenticação de usuário e gerenciamento de sessão
- **FirebaseFirestore**: Banco de dados NoSQL em nuvem para armazenamento de dados em tempo real
- **FirebaseAppCheck**: Segurança do app e prevenção de abuso

### Serviços Google
- **GoogleSignIn-iOS (v9.0.0)**: Autenticação OAuth do Google
- **GoogleAppMeasurement**: Analytics e monitoramento de performance
- **GoogleDataTransport**: Camada eficiente de transporte de dados

### Bibliotecas de Suporte
- **GTMSessionFetcher (v3.5.0)**: Gerenciamento de sessões HTTP
- **SwiftProtobuf (v1.31.1)**: Suporte a protocol buffer para serialização eficiente de dados
- **gRPC-binary (v1.69.1)**: Framework RPC de alta performance
- **Promises (v2.4.0)**: Utilitários de programação assíncrona

## 📁 Estrutura do Projeto

```
Todolist/
├── TodolistApp.swift           # Ponto de entrada principal do app e configuração
├── ContentView.swift          # View raiz com roteamento de autenticação
├── Models/
│   ├── TodoTask.swift         # Modelo de dados de tarefa com integração Firestore
│   ├── Quote.swift            # Modelo de citação para conteúdo motivacional
│   └── NetworkError.swift     # Tratamento de erros de rede
├── Services/
│   ├── AuthService.swift      # Serviço de autenticação Firebase
│   ├── TaskService.swift      # Operações CRUD de tarefas com Firestore
│   ├── NotificationService.swift # Gerenciamento de notificações push
│   └── WebService.swift       # Cliente HTTP para APIs externas
├── Views/
│   ├── AuthView.swift         # View de seleção de autenticação
│   ├── LoginView.swift        # Interface de login com email/senha
│   ├── SignupView.swift       # Interface de registro de usuário
│   ├── TaskList.swift         # Listagem principal de tarefas com busca
│   └── TaskForm.swift         # Formulário de criação e edição de tarefas
├── Stores/
│   └── QuotesStore.swift      # Gerenciamento de estado para frases motivacionais
└── Assets.xcassets/           # Ícones do app, imagens e assets de cores
```

## 🏗 Arquitetura

- **Models**: Estruturas de dados (`TodoTask`, `Quote`) com suporte Codable para serialização JSON/Firestore
- **Views**: Views SwiftUI para componentes da interface do usuário
- **Services**: Camadas de lógica de negócio que lidam com autenticação, persistência de dados e APIs externas
- **Stores**: Classes observáveis que gerenciam o estado do app usando a macro `@Observable` do SwiftUI

### Padrões de Design Principais
- **Injeção de Dependência**: Serviços são injetados através do sistema de environment do SwiftUI
- **Programação Reativa**: Atualizações de UI em tempo real usando listeners do Firestore e gerenciamento de estado do SwiftUI
- **Separação de Responsabilidades**: Separação clara entre UI, lógica de negócio e camadas de dados

## 👥 Equipe de Desenvolvimento

| Nome | RM | E-mail | GitHub | LinkedIn |
|------|-------|---------|---------|----------|
| Arthur Vieira Mariano | RM554742 | arthvm@proton.me | [@arthvm](https://github.com/arthvm) | [arthvm](https://linkedin.com/in/arthvm/) |
| Guilherme Henrique Maggiorini | RM554745 | guimaggiorini@gmail.com | [@guimaggiorini](https://github.com/guimaggiorini) | [guimaggiorini](https://linkedin.com/in/guimaggiorini/) |
| Ian Rossato Braga | RM554989 | ian007953@gmail.com | [@iannrb](https://github.com/iannrb) | [ianrossato](https://linkedin.com/in/ianrossato/) |

## 📄 Licença

Este projeto é parte do curso de Desenvolvimento Mobile da FIAP - Checkpoint 4.

---