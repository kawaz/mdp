///| File reading FFI (JS/Bun)
extern "js" fn read_file_sync(path : String) -> String =
  #| (path) => {
  #|   const fs = require('node:fs');
  #|   try {
  #|     return fs.readFileSync(path, 'utf-8');
  #|   } catch (e) {
  #|     return '';
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
