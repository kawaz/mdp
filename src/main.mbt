///| mdp - Terminal Markdown Preview CLI

fn main {
  let args = get_args()

  // Parse options
  let mut cjk = false
  let mut file_arg : String? = None
  for arg in args {
    if arg == "-h" || arg == "--help" {
      print_usage()
      return
    }
    if arg == "-v" || arg == "--version" {
      println("mdp 0.1.0")
      return
    }
    if arg == "--cjk-width" {
      cjk = true
    } else {
      file_arg = Some(arg)
    }
  }

  // Get markdown source
  let source : String = match file_arg {
    Some(path) => {
      let content = read_file_sync(path)
      if content.has_prefix("\u0000") {
        println("Error: Cannot read file: " + path)
        return
      }
      content
    }
    None =>
      if stdin_is_piped() {
        read_stdin_sync()
      } else {
        print_usage()
        return
      }
  }

  // Render markdown to terminal with Unicode-aware width calculation
  let options = @tui.TuiOptions::with_str_width(fn(s) {
    @unicodewidth.str_width(s.view(), cjk~)
  })
  let output = @tui.from_markdown_with_options(source, options)
  print_raw(output)
}

fn print_usage() -> Unit {
  println("mdp - Terminal Markdown Preview")
  println("")
  println("Usage:")
  println("  mdp <file.md>        Preview markdown file")
  println("  cat file.md | mdp    Preview from stdin")
  println("")
  println("Options:")
  println("  --cjk-width          Treat ambiguous-width characters as wide (2 columns)")
  println("  -h, --help           Show this help")
  println("  -v, --version        Show version")
}
