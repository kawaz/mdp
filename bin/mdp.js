#!/usr/bin/env node
import { spawn } from 'node:child_process';

// Pipe output through $PAGER when: file arg given + stdout is a TTY
const args = process.argv.slice(2);
const hasFileArg = args.some(a => !a.startsWith('-'));
const hasInfoFlag = args.some(a => ['-h', '--help', '-v', '--version'].includes(a));

let pager;
if (hasFileArg && !hasInfoFlag && process.stdout.isTTY) {
  const pagerCmd = process.env.PAGER ?? 'less';
  if (pagerCmd) {
    if (!process.env.LESS) process.env.LESS = '-R';
    try {
      pager = spawn(pagerCmd, [], {
        stdio: ['pipe', 'inherit', 'inherit'],
        shell: true,
      });
      const origWrite = process.stdout.write.bind(process.stdout);
      pager.on('error', () => {
        process.stdout.write = origWrite;
        pager = undefined;
      });
      pager.stdin.on('error', () => {}); // Ignore EPIPE when pager exits early
      process.stdout.write = function (chunk, encoding, callback) {
        if (pager?.stdin && !pager.stdin.destroyed) {
          return pager.stdin.write(chunk, encoding, callback);
        }
        return origWrite(chunk, encoding, callback);
      };
    } catch {
      pager = undefined;
    }
  }
}

await import('../dist/mdp.js');

if (pager) {
  pager.stdin.end();
  await new Promise(resolve => pager.on('close', resolve));
}
