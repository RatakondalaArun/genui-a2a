import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_flutter/agents_page.dart';

class AgentInfoWidget extends StatelessWidget {
  final GenUiConversation conversation;
  final Agent agent;

  const AgentInfoWidget({
    super.key,
    required this.conversation,
    required this.agent,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text('Debug Info'),
        StreamBuilder(
          stream: conversation.contentGenerator.a2uiMessageStream,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case SurfaceUpdate():
                final surfaceUpdate = snapshot.data as SurfaceUpdate;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Surface ID: ${surfaceUpdate.surfaceId}'),
                        ...surfaceUpdate.components.map((component) => Text(component.toJson().toString())).toList(),
                      ],
                    ),
                  ),
                );
              default:
                return SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
