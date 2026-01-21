import 'package:flutter/material.dart';
import 'package:genui_flutter/feature/chat/ui/genui_chat.dart';

class Agent {
  final String name;
  final String prompt;
  final String? startMsg;

  const Agent({
    required this.name,
    required this.prompt,
    this.startMsg,
  });
}

class AgentsPage extends StatelessWidget {
  const AgentsPage({super.key});

  static final agents = <Agent>[
    Agent(
      name: 'AWS Expert Agent',
      prompt: '''
You are an AWS Expert. Follow the below instructions
# Instructions
- Generate a interactive quiz
- Generate at least 10 questions
- Show status of the questions
- At the end of the quiz generate a detailed breakdown of the quiz and answers
- Ask Questions one after another
''',
    ),
    Agent(
      name: 'Restaurant Recommendation Agent',
      prompt: '''
# Instructions
## Role:
- You are a Google Cloud Platform (GCP) Subject Matter Expert and Interactive Quiz Master.
## Task:
- Create an interactive GCP quiz that tests both conceptual and practical knowledge.

## Quiz Requirements:
- Clean, modern UI/UX
- Generate at least 10 questions related to GCP (mix of beginner to intermediate level).
- Ask one question at a time, waiting for the user’s answer before proceeding.
- After each response, clearly show the status of the question:
- ✅ Correct
- ❌ Incorrect (include a brief explanation)
- Keep track of the current score and question number (e.g., Question 3 of 10).

## End of Quiz Summary:
- Provide a detailed breakdown including:
- Each question
- The user's answer
- The correct answer
- A clear explanation for each
- Display the final score and performance assessment (e.g., Beginner / Intermediate / Advanced).

##Interaction Rules:
- Do not show future questions in advance.
- Maintain a clear, friendly, and professional tone.
- Ensure explanations are concise but informative.
''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GenUI Chat'),
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
        ),
        padding: EdgeInsets.all(10),
        children: agents.map<Widget>((agent) {
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return GenUIChat(agent: agent);
                  },
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
                margin: const EdgeInsets.all(8),
                child: GridPaper(
                  child: Center(
                    child: GridTile(
                      footer: Text(agent.name, textAlign: TextAlign.center),
                      child: Icon(Icons.person_2),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
