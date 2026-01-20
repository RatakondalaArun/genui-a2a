import express from 'express';
import cors from 'cors';
import { AGENT_CARD_PATH } from '@a2a-js/sdk';

import { agentCardHandler, jsonRpcHandler, restHandler, UserBuilder } from '@a2a-js/sdk/server/express';
import { restaurantBookingRequestHandler } from './src/restaurant_agent/handler';

const app = express();

app.use(cors());

app.use(`/${AGENT_CARD_PATH}`, agentCardHandler({ agentCardProvider: restaurantBookingRequestHandler }));
app.use(
  '/',
  jsonRpcHandler({ requestHandler: restaurantBookingRequestHandler, userBuilder: UserBuilder.noAuthentication }),
);
app.use(
  '/a2a/jsonrpc',
  jsonRpcHandler({ requestHandler: restaurantBookingRequestHandler, userBuilder: UserBuilder.noAuthentication }),
);
app.use(
  '/a2a/rest',
  restHandler({ requestHandler: restaurantBookingRequestHandler, userBuilder: UserBuilder.noAuthentication }),
);

app.listen(4000, () => {
  console.log(`🚀 Server started on http://localhost:4000`);
});
