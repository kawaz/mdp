///|
/// mdp - Terminal Markdown Preview CLI
fn main {
  let args = get_args()

  // Parse options
  let mut cjk = false
  let files : Array[String] = []
  let mut opts_done = false
  for arg in args {
    if opts_done {
      files.push(arg)
      continue
    }
    if arg == "--" {
      opts_done = true
      continue
    }
    if arg == "-h" || arg == "--help" {
      print_usage()
      return
    }
    if arg == "-v" || arg == "--version" {
      println("mdp " + get_version())
      return
    }
    if arg == "--cjk-width" {
      cjk = true
    } else if arg.has_prefix("-") {
      eprintln("Error: Unknown option: " + arg)
      println("")
      print_usage()
      set_exit_code(1)
      return
    } else {
      files.push(arg)
    }
  }

  let options = @tui.TuiOptions::with_str_width(fn(s) {
    @unicodewidth.str_width(s.view(), cjk~)
  })

  if files.is_empty() {
    if stdin_is_piped() {
      let source = read_stdin_sync()
      setup_pager()
      print_raw(@tui.from_markdown_with_options(source, options))
    } else {
      print_usage()
      return
    }
  } else {
    for path in files {
      let content = read_file_sync(path)
      if content.has_prefix("\u0000") {
        eprintln("Error: Cannot read file: " + path)
        set_exit_code(1)
        continue
      }
      setup_pager() // idempotent: no-op after first call
      print_raw(@tui.from_markdown_with_options(content, options))
    }
  }
}

///|
fn print_usage() -> Unit {
  println("mdp - Terminal Markdown Preview")
  println("")
  println("Usage:")
  println("  mdp <file.md> ...    Preview markdown file(s)")
  println("  cat file.md | mdp    Preview from stdin")
  println("")
  println("Options:")
  println(
    "  --cjk-width          Treat ambiguous-width characters as wide (2 columns)",
  )
  println("  -h, --help           Show this help")
  println("  -v, --version        Show version")
  println("")
  println("Use -- to separate options from filenames starting with -")
}
