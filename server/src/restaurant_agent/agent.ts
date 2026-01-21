import a2UISchema from '../../a2ui_schema.json';
import { mcpToolsServerUrl } from './tools';
import { MultiServerMCPClient } from '@langchain/mcp-adapters';
import { ChatGoogleGenerativeAI } from '@langchain/google-genai';
import { createAgent, initChatModel, SystemMessage } from 'langchain';
import { resturantBookingAgentCard } from './agent_card';
const A2UI_SCHEMA = JSON.stringify(a2UISchema);

function getA2UIPrompt() {
  return `
#Instructions
You are a restaurant recommendation agent that helps users find and book restaurants based on their preferences.

## When responding to user queries, you MUST provide two types of responses:
1. Follow the below A2UI JSON SCHEMA to create dynamic user interfaces.
2. A conversational text response that addresses the user's query.
3. Only use the tools provided to you to fetch restaurant data when necessary.
4. Do not make up any restaurant data. If you don't have enough information, ask the user for more details.
5. Generate a beautiful and user-friendly UI using A2UI components.
6. Use Proper Spacing and Layouts to ensure the UI is visually appealing and easy to navigate.
7. Frontend is using flutter framework, so use components that are compatible with flutter.
8. Use STRING type in the A2UI JSON schema wherever string/double type is required.

## Conversation Flow
1. Greet the user and ask for their restaurant preferences (cuisine, location, price range, etc.) if not provided.
2. Use the provided tool \"get-all-restaurants\" to fetch a list of restaurants based on user preferences.
3. Display the restaurant list using A2UI components, including images, ratings, and brief descriptions.
4. Allow users to filter and sort the restaurant list based on different criteria (e.g., rating, distance, price).
5. Provide detailed information about a selected restaurant when the user clicks on it.
6. Assist with booking reservations if the user expresses interest in a particular restaurant.

## Your final output MUST be a a2ui UI JSON response.

To generate the response, you MUST follow these rules:
1.  Your response MUST be in two parts, separated by the delimiter: \`---a2ui_JSON---\`.
2.  The first part is your conversational text response.
3.  The second part is a single, raw JSON object which is a list of A2UI messages.
4.  The JSON part MUST validate against the A2UI JSON SCHEMA provided below.

--- UI TEMPLATE RULES ---
-   If the query is for a list of restaurants, you can query for the restaurant data with the available tool to populate the \`dataModelUpdate.contents\` array (e.g., as a \`valueMap\` for the "items" key).
-   Use \`beginRendering\` to create a new UI surface when starting a new interaction.
-   Use \`surfaceUpdate\` to update an existing surface with new components or changes.
-   Use \`dataModelUpdate\` to update the data models that back your UI components.
-   Use \`deleteSurface\` to remove a UI surface when it is no longer needed.

---BEGIN A2UI JSON SCHEMA---
${A2UI_SCHEMA}
---END A2UI JSON SCHEMA---
`;
}

const client = new MultiServerMCPClient({
  mcpServers: {
    database: {
      transport: 'http',
      url: 'http://127.0.0.1:5000/mcp', // Main MCP server URL'
    },
  },
});

console.log('[MCP Client] Fetching tools from MCP server at', mcpToolsServerUrl);
const tools = await client.getTools();
console.log(`[Tools] Loaded tools`);
for (const t of tools) {
  console.log(`- ${t.name}: (${t.description})`);
}

const chatModel = new ChatGoogleGenerativeAI({
  model: 'gemini-2.5-pro',
  temperature: 0.7,
  apiKey: process.env.GEMINI_API_KEY ?? '',
});

export const restaurantAgent = createAgent({
  model: chatModel,
  tools: tools,
  name: resturantBookingAgentCard.name,
  description: resturantBookingAgentCard.description,
  systemPrompt: new SystemMessage({
    name: 'agent',
    content: [
      {
        type: 'text',
        text: getA2UIPrompt(),
      },
    ],
  }),
});
