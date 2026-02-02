///| mdp - Terminal Markdown Preview CLI

fn main {
  let args = get_args()

  // Get markdown source
  let source : String = if args.length() > 0 {
    let first_arg = args[0]
    // Help
    if first_arg == "-h" || first_arg == "--help" {
      print_usage()
      return
    }
    // Version
    if first_arg == "-v" || first_arg == "--version" {
      println("mdp 0.1.0")
      return
    }
    // Read from file
    let content = read_file_sync(first_arg)
    if content.is_empty() {
      println("Error: Cannot read file: " + first_arg)
      return
    }
    content
  } else if stdin_is_piped() {
    // Read from stdin
    read_stdin_sync()
  } else {
    // Show usage
    print_usage()
    return
  }

  // Render markdown to terminal
  let output = @tui.from_markdown(source)
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
  println("  -h, --help           Show this help")
  println("  -v, --version        Show version")
}
