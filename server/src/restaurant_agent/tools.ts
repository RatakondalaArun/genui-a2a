import { ToolboxClient } from '@toolbox-sdk/core';
export const mcpToolsServerUrl = 'http://127.0.0.1:5000';
export const mcpToolsClient = new ToolboxClient(mcpToolsServerUrl);
export const mcpToolSet = await mcpToolsClient.loadToolset();

// for (const tool of mcpToolSet) {
//   console.log(`Loaded tool: ${tool.name} - ${tool.description}`);
// }
