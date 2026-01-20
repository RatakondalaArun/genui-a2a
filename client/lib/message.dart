import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

class MessageController with EquatableMixin {
  MessageController({this.text, this.surfaceId}) : assert((surfaceId == null) != (text == null));

  final String? text;
  final String? surfaceId;

  @override
  List<Object?> get props => [text, surfaceId];
}

class MessageView extends StatelessWidget {
  const MessageView(this.controller, this.host, {super.key});

  final MessageController controller;
  final GenUiHost host;

  @override
  Widget build(BuildContext context) {
    final String? surfaceId = controller.surfaceId;

    if (surfaceId == null) {
      return Text(controller.text ?? '');
    }

    return GenUiSurface(host: host, surfaceId: surfaceId);
  }
}
