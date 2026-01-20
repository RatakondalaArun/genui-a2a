import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_a2ui/genui_a2ui.dart';
import 'package:genui_flutter/agents_page.dart';
import 'package:genui_flutter/main.dart';
import 'package:genui_flutter/message.dart';

class GenUIChat extends StatefulWidget {
  const GenUIChat({super.key, required this.agent});

  final Agent agent;

  @override
  State<GenUIChat> createState() => _GenUIChatState();
}

class _GenUIChatState extends State<GenUIChat> {
  late final Catalog catalog;
  late final A2uiMessageProcessor messageProcessor;
  late final ContentGenerator contentGenerator;
  late final GenUiConversation conversation;

  final _textController = TextEditingController();

  // final _surfaceIds = <String>[];
  final List<MessageController> _messages = [];
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onTextResponse(String text) {
    if (!mounted) return;
    setState(() {
      _messages.add(MessageController(text: 'AI: $text'));
    });
    _scrollToBottom();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();

    setState(() {
      _messages.add(MessageController(text: 'You: $text'));
    });

    _scrollToBottom();
    conversation.sendRequest(UserMessage.text(text));
  }

  // A callback invoked by the [GenUiConversation] when a new
  // UI surface is generated. Here, the ID is stored so the
  // build method can create a GenUiSurface to display it.
  void _onSurfaceAdded(SurfaceAdded update) {
    setState(() {
      _messages.add(MessageController(surfaceId: update.surfaceId));
    });
  }

  void _onSurfaceUpdated(SurfaceUpdated update) {
    // setState(() {
    //   _messages..removeWhere((element) => element.surfaceId==update.surfaceId)..add(MessageController(surfaceId: update.surfaceId));
    // });
  }

  // A callback invoked by GenUiConversation when a UI surface is removed.
  void _onSurfaceDeleted(SurfaceRemoved update) {
    setState(() {
      _messages.remove(MessageController(surfaceId: update.surfaceId));
    });
  }

  @override
  void initState() {
    super.initState();

    catalog = CoreCatalogItems.asCatalog();
    // print(catalog.definition.toJson());
    messageProcessor = A2uiMessageProcessor(catalogs: [catalog]);
    contentGenerator = A2uiContentGenerator(
      serverUrl: Uri.parse('http://localhost:4000'),
      // connector: A2uiAgentConnector(url: Uri.parse('http://localhost:4000/a2a/jsonrpc')),
    );

    conversation = GenUiConversation(
      a2uiMessageProcessor: messageProcessor,
      contentGenerator: contentGenerator,
      onSurfaceAdded: _onSurfaceAdded,
      onSurfaceUpdated: _onSurfaceUpdated,
      onSurfaceDeleted: _onSurfaceDeleted,
      onTextResponse: _onTextResponse,
      onError: (value) {
        logger.info('[ERR] $value');
      },
    );

    // Create a ContentGenerator to communicate with the LLM.
    // Provide system instructions and the tools from the A2uiMessageProcessor.

    // Create the GenUiConversation to orchestrate everything.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(widget.agent.name),
        actions: [],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SizedBox(
                  height: 2,
                  child: ValueListenableBuilder(
                    valueListenable: contentGenerator.isProcessing,
                    builder: (context, isProcessing, _) {
                      if (isProcessing) {
                        return LinearProgressIndicator();
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: conversation.conversation,
                    builder: (context, messages, child) {
                      return ListView.builder(
                        itemCount: messages.length,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        itemBuilder: (context, index) {
                          // For each surface, create a GenUiSurface to display it.
                          final message = messages[index];
                          return switch (message) {
                            UserMessage() => UserChatWidget(message: message),
                            AiTextMessage() => AIChatWidget(message: message),
                            AiUiMessage() => GenUiSurface(host: conversation.host, surfaceId: message.surfaceId),
                            InternalMessage() => SizedBox.shrink(),
                            UserUiInteractionMessage() => SizedBox.shrink(),
                            ToolResponseMessage() => SizedBox.shrink(),
                          };
                        },
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: 'Enter a message',
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Send the user's text to the agent.
                            _sendMessage(_textController.text);
                            _textController.clear();
                          },
                          child: const Text('Send'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(
            flex: 1,
            child: AgentInfoWidget(conversation: conversation, agent: widget.agent),
          ),
        ],
      ),
    );
  }
}

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
        AppBar(
          automaticallyImplyLeading: false,
          title: Text('Debug Info'),
          primary: false,
        ),
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
    // final contentGenerator = (conversation.contentGenerator as GoogleGenerativeAiContentGenerator);
    // return ListView(
    //   children: [
    //     AppBar(
    //       automaticallyImplyLeading: false,
    //       title: Text('Agent Info'),
    //     ),
    //     Card(
    //       child: Column(
    //         children: [
    //           Text('Token Usage'),
    //           Text('Inputs: ${contentGenerator.inputTokenUsage}'),
    //           Text('Inputs: ${contentGenerator.outputTokenUsage}'),
    //         ],
    //       ),
    //     ),

    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: [
    //         Text('Name'),
    //         Text(agent.name),
    //       ],
    //     ),
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: [
    //         Text('Prompt'),
    //         Text(agent.prompt),
    //       ],
    //     ),
    //   ],
    // );
  }
}

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
