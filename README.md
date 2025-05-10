# 📦 Delivery Track App

Aplicativo Flutter para entregadores rastrearem entregas em tempo real via WebSocket. O app permite cadastro, login, início e finalização de entregas, com envio contínuo da localização atual para um backend.

---

## ✨ Funcionalidades

- Cadastro de novos entregadores
- Login com autenticação JWT
- Início de uma entrega com geração de link de rastreio
- Envio da localização do entregador em tempo real via WebSocket
- Finalização da entrega
- Integração com backend Spring Boot

---

## 🚀 Tecnologias Utilizadas

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [Shared Preferences](https://pub.dev/packages/shared_preferences)
- [STOMP WebSocket (stomp_dart_client)](https://pub.dev/packages/stomp_dart_client)
- [HTTP](https://pub.dev/packages/http)

---

## 🧩 Estrutura do Projeto

```plaintext
lib/
├── main.dart                # Inicialização do app e definição de rotas
├── pages/
│   ├── login_page.dart      # Tela de login
│   ├── register_page.dart   # Tela de cadastro
│   └── home_page.dart       # Tela principal após login
├── services/
│   ├── api_service.dart     # Integração com a API (cadastro, login, entregas)
│   └── websocket_service.dart # Comunicação via WebSocket (STOMP)
```

## 🔐 Autenticação

- Autenticação é baseada em JWT, armazena localmente via SharedPreferences.
- Token é enviado nos headers das requisições HTTP e conexões WebSocket.

## 📱 Telas
- LoginPage: Formulário de login e link para cadastro
- RegisterPage: Formulário de cadastro e link para login
- HomePage: Interface principal