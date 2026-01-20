import { AgentExecutor, ExecutionEventBus, RequestContext } from '@a2a-js/sdk/server';
import { DataPart, Message, Part, Task, TextPart } from '@a2a-js/sdk';
import { v4 as uuidv4 } from 'uuid';
import { HumanMessage } from 'langchain';
import { restaurantAgent } from './agent';

export class A2UIExecutor implements AgentExecutor {
  async execute(requestContext: RequestContext, eventBus: ExecutionEventBus): Promise<void> {
    console.log(requestContext.referenceTasks);

    const userText =
      requestContext.userMessage?.parts
        ?.filter((p) => p.kind === 'text')
        .map((p) => p.text)
        .join('\n') ?? 'Say hello';

    const res = await restaurantAgent.invoke({
      messages: [new HumanMessage({ content: userText })],
    });

    const reply = res.messages[res.messages.length - 1]?.text ?? '';

    const [textPart, a2UIPart] = reply.split('---a2ui_JSON---');

    const parts: Part[] = [];

    if (textPart) {
      parts.push({
        kind: 'text',
        text: textPart,
      } as TextPart);
    }

    if (a2UIPart) {
      try {
        const parsedJson = JSON.parse(a2UIPart) as any[];
        console.log('Parsed A2UI JSON part:', JSON.stringify(parsedJson, null, 2));
        if (parsedJson.length !== 0) {
          for (const dataPart of parsedJson) {
            parts.push({
              kind: 'data',
              data: dataPart,
              metadata: {
                mimeType: 'application/json+a2ui',
              },
            } as DataPart);
          }
        }
      } catch (error) {
        console.error('Failed to parse A2UI JSON part:', error);
      }
    }

    // 3. Send A2A-compliant response
    const responseMessage: Message = {
      kind: 'message',
      messageId: uuidv4(),
      role: 'agent',
      contextId: requestContext.contextId,
      parts: parts,
    };

    const responseTask: Task = {
      kind: 'task',
      status: {
        message: responseMessage,
        state: 'completed',
      },
      contextId: requestContext.contextId,
      id: uuidv4(),
      metadata: {
        mimeType: 'application/json+a2ui',
      },
    };

    console.log(JSON.stringify(responseTask, null, 2));

    // Publish the message and signal that the interaction is finished.
    eventBus.publish(responseTask);
    eventBus.finished();
  }

  // cancelTask is not needed for this simple, non-stateful agent.
  cancelTask = async (): Promise<void> => {};
}
