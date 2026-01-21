import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

class AIChatWidget extends StatelessWidget {
  final AiTextMessage message;

  const AIChatWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Text('AI: ${message.text}');
  }
}
