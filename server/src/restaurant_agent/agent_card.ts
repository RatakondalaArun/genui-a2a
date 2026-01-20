import { AgentCard } from '@a2a-js/sdk';

export const resturantBookingAgentCard: AgentCard = {
  name: 'Restourant Booking Agent',
  description: 'An AI agent that helps users find and book restaurants.',
  protocolVersion: '0.3.0',
  version: '0.1.0',
  url: 'http://localhost:4000/a2a/jsonrpc', // The public URL of your agent server
  skills: [{ id: 'chat', name: 'Chat', description: 'Say hello', tags: ['chat'] }],
  capabilities: {
    pushNotifications: false,
    stateTransitionHistory: true,
    streaming: true,
    extensions: [
      {
        uri: 'a2uiClientCapabilities',
        description: 'Ability to render A2UI',
        required: false,
        params: {
          supportedCatalogIds: [
            'a2ui.org:standard_catalog_0_8_0',
            'https://github.com/google/A2UI/blob/main/specification/0.8/json/standard_catalog_definition.json',
            // 'https://my-company.com/a2ui/v0.8/my_custom_catalog.json',
          ],
          acceptsInlineCatalogs: true,
        },
      },
    ],
  },
  defaultInputModes: ['text'],
  defaultOutputModes: ['text'],
  additionalInterfaces: [
    { url: 'http://localhost:4000/', transport: 'JSONRPC' }, // Default JSON-RPC transport
    { url: 'http://localhost:4000/a2a/jsonrpc', transport: 'JSONRPC' }, // Default JSON-RPC transport
    { url: 'http://localhost:4000/a2a/rest', transport: 'HTTP+JSON' }, // HTTP+JSON/REST transport
  ],
};
