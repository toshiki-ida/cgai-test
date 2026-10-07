// Notion MCP サーバーの起動役（Mac・Linux・Windows 共通）
// Windows では npx が npx.cmd のため、そのままでは起動できない。ここで OS に合わせて起動する。
'use strict';
const { spawn } = require('child_process');

const isWin = process.platform === 'win32';
const child = spawn(isWin ? 'npx.cmd' : 'npx', ['-y', '@notionhq/notion-mcp-server'], {
  stdio: 'inherit',
  env: process.env,
  shell: isWin,
});
child.on('error', (e) => {
  console.error('Notion MCP サーバーを起動できませんでした: ' + e.message);
  process.exit(1);
});
child.on('exit', (code) => process.exit(code === null ? 1 : code));
for (const sig of ['SIGINT', 'SIGTERM']) process.on(sig, () => child.kill(sig));
