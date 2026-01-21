import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_a2ui/genui_a2ui.dart';
import 'package:genui_flutter/agents_page.dart';
import 'package:genui_flutter/feature/chat/ui/widgets/agent_info_widget.dart';
import 'package:genui_flutter/feature/chat/ui/widgets/ai_chat_widget.dart';
import 'package:genui_flutter/feature/chat/ui/widgets/user_chat_widget.dart';
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
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        // Pressing Enter will send the message.
        LogicalKeySet(.meta, .enter): const SendMessageIntent(),
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: Text(widget.agent.name),
          actions: [],
        ),
        body: Row(
          children: [
            Expanded(
              flex: 2,
              child: AgentInfoWidget(conversation: conversation, agent: widget.agent),
            ),
            VerticalDivider(),
            Expanded(
              flex: 5,
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                        borderRadius: .circular(20),
                      ),
                      margin: const .all(8.0),
                      padding: const .symmetric(horizontal: 16.0, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Actions(
                              actions: <Type, Action<Intent>>{
                                SendMessageIntent: CallbackAction<SendMessageIntent>(
                                  onInvoke: (intent) {
                                    _sendMessage(_textController.text);
                                    _textController.clear();
                                    return;
                                  },
                                ),
                              },
                              child: Focus(
                                autofocus: true,
                                child: TextField(
                                  controller: _textController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter a message',
                                    // fillColor: Colors.grey[50],
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ValueListenableBuilder(
                            valueListenable: contentGenerator.isProcessing,
                            builder: (context, isProcessing, _) {
                              return IconButton.filled(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                icon: isProcessing
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(),
                                      )
                                    : const Icon(Icons.send_outlined),
                                onPressed: isProcessing
                                    ? null
                                    : () {
                                        _sendMessage(_textController.text);
                                        _textController.clear();
                                      },
                              );
                            },
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
              flex: 2,
              child: AgentInfoWidget(conversation: conversation, agent: widget.agent),
            ),
          ],
        ),
      ),
    );
  }
}

class SendMessageIntent extends Intent {
  const SendMessageIntent();
}
