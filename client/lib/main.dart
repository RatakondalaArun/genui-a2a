import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_flutter/agents_page.dart';
import 'package:logging/logging.dart';

final logger = configureGenUiLogging(level: Level.ALL);

void main() {
  logger.onRecord.listen((record) {
    debugPrint('${record.loggerName}: ${record.message}');
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GenUI Chat',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: AgentsPage(), //const GenUIChat(title: 'Flutter Demo Home Page'),
    );
  }
}
