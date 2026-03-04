///| File reading FFI (JS/Bun)
///| Returns file content on success, or "\0" on failure (error details printed to stderr).
extern "js" fn read_file_sync(path : String) -> String =
  #| (path) => {
  #|   const fs = require('node:fs');
  #|   try {
  #|     return fs.readFileSync(path, 'utf-8');
  #|   } catch (e) {
  #|     process.stderr.write('Error: ' + (e.message || String(e)) + '\n');
  #|     return '\0';
  #|   }
  #| }

///| Get command line arguments
extern "js" fn get_args() -> Array[String] =
  #| () => process.argv.slice(2)

///| Read from stdin
///| Uses chunked readSync with EAGAIN retry to handle non-blocking fd 0.
///| Design rationale: Node.js sets fd 0 to non-blocking mode when process.stdin
///| is accessed (e.g. via isTTY). readFileSync(0) does not retry on EAGAIN,
///| causing silent empty reads on large piped input. Manual readSync loop with
///| EAGAIN retry avoids this.
extern "js" fn read_stdin_sync() -> String =
  #| () => {
  #|   const fs = require('node:fs');
  #|   const chunks = [];
  #|   const buf = Buffer.allocUnsafe(65536);
  #|   for (;;) {
  #|     try {
  #|       const n = fs.readSync(0, buf, 0, buf.length);
  #|       if (n === 0) break;
  #|       chunks.push(Uint8Array.prototype.slice.call(buf, 0, n));
  #|     } catch (e) {
  #|       if (e.code === 'EAGAIN') { Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, 1); continue; }
  #|       if (e.code === 'EOF') break;
  #|       return '';
  #|     }
  #|   }
  #|   return Buffer.concat(chunks).toString('utf-8');
  #| }

///| Check if stdin has data (is piped)
///| Design rationale: process.stdin.isTTY switches fd 0 to non-blocking mode,
///| breaking subsequent readFileSync/readSync. tty.isatty(0) checks without
///| side effects.
extern "js" fn stdin_is_piped() -> Bool =
  #| () => !require('node:tty').isatty(0)

///| Get version (injected at build time via bun build --define)
extern "js" fn get_version() -> String =
  #| () => __MDP_VERSION__

///| Print without newline
extern "js" fn print_raw(s : String) -> Unit =
  #| (s) => process.stdout.write(s)

///| Setup PAGER if stdout is a TTY and PAGER env var is set.
///| Spawns the pager process and redirects stdout to its stdin.
///| The pager reference is stored on globalThis.__mdp_pager for cleanup by the launcher.
extern "js" fn setup_pager() -> Unit =
  #| () => {
  #|   if (!process.stdout.isTTY || !process.env.PAGER || globalThis.__mdp_pager) return;
  #|   const { spawn } = require('node:child_process');
  #|   if (!process.env.LESS) process.env.LESS = '-R';
  #|   try {
  #|     const pager = spawn(process.env.PAGER, [], {
  #|       stdio: ['pipe', 'inherit', 'inherit'],
  #|       shell: true,
  #|     });
  #|     const origWrite = process.stdout.write.bind(process.stdout);
  #|     const restoreStdout = () => {
  #|       process.stdout.write = origWrite;
  #|       globalThis.__mdp_pager = undefined;
  #|     };
  #|     pager.on('error', restoreStdout);
  #|     pager.stdin.on('error', () => {});
  #|     process.stdout.write = function(chunk, encoding, callback) {
  #|       if (pager.stdin && !pager.stdin.destroyed) {
  #|         return pager.stdin.write(chunk, encoding, callback);
  #|       }
  #|       return origWrite(chunk, encoding, callback);
  #|     };
  #|     globalThis.__mdp_pager = pager;
  #|   } catch {}
  #| }
