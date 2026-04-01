import 'package:uuid/uuid.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isBot;
  final DateTime timestamp;

  ChatMessage({
    String? id,
    required this.text,
    required this.isBot,
    DateTime? timestamp,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();
}
