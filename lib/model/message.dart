class UserMessage {
  final String message;

  UserMessage({required this.message});
}

class ChatbotResponse {
  final String response;

  ChatbotResponse({required this.response});
}
class Messages {
  String response;
  MessageType type;

  Messages({required this.response, required this.type});
}

enum MessageType { user, chatbot }
