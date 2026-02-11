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
extern "js" fn read_stdin_sync() -> String =
  #| () => {
  #|   const fs = require('node:fs');
  #|   try {
  #|     return fs.readFileSync(0, 'utf-8');
  #|   } catch (e) {
  #|     return '';
  #|   }
  #| }

///| Check if stdin has data (is piped)
extern "js" fn stdin_is_piped() -> Bool =
  #| () => !process.stdin.isTTY

///| Print without newline
extern "js" fn print_raw(s : String) -> Unit =
  #| (s) => process.stdout.write(s)
