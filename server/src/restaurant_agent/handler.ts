import { DefaultRequestHandler, InMemoryTaskStore } from '@a2a-js/sdk/server';

import { resturantBookingAgentCard } from './agent_card';
import { A2UIExecutor } from './a2ui_executor';

const agentExecutor = new A2UIExecutor();
const memoryStore = new InMemoryTaskStore();

export const restaurantBookingRequestHandler = new DefaultRequestHandler(
  resturantBookingAgentCard,
  memoryStore,
  agentExecutor,
);
