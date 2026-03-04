#!/usr/bin/env node
await import('../dist/mdp.js');

const pager = globalThis.__mdp_pager;
if (pager) {
  pager.stdin.end();
  await new Promise(resolve => pager.on('close', resolve));
}
