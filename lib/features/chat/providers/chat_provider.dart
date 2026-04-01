import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_provider.g.dart';

@riverpod
class ChatList extends _$ChatList {
  final _service = ChatService();

  @override
  List<ChatMessage> build() {
    return [
      ChatMessage(text: "Hi! I'm FinBot. Ask me about your balance or tell me to track an expense!", isBot: true)
    ];
  }

  void sendMessage(String text, WidgetRef ref) async {
    if (text.trim().isEmpty) return;

    // Add user message
    state = [...state, ChatMessage(text: text, isBot: false)];

    // Add immediate typing indicator or just process blockingly (since it's offline, it's virtually instant)
    // To simulate realistic "bot thinking" we can add a slight delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    final response = await _service.processMessage(text, ref);
    state = [...state, ChatMessage(text: response, isBot: true)];
  }
}
