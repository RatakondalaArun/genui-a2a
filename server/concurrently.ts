import concurrently from 'concurrently';

const { result } = concurrently(
  [
    {
      name: 'MCP',
      command: 'toolbox -p 5000 --ui --log-level DEBUG',
      prefixColor: 'blue',
    },
    {
      name: 'SERVER',
      command: 'wait-on -t 10000 -d 500 http://127.0.0.1:5000 && bun run --watch --env-file=.env server.ts',
      prefixColor: 'green',
    },
  ],
  {
    killOthersOn: ['failure', 'success'],

    restartTries: 0,
    prefix: 'name',
  },
);

result.catch((err) => {
  console.error('❌ Dev processes exited with error:', err);
  process.exit(1);
});
