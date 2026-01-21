import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

class UserChatWidget extends StatelessWidget {
  final UserMessage message;

  const UserChatWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Text('You: ${message.text}');
  }
}
