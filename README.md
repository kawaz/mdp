# mdp

Terminal Markdown Preview CLI powered by [MoonBit](https://moonbitlang.com) and [mizchi/markdown.mbt](https://github.com/mizchi/markdown.mbt).

## Features

- ANSI color output for terminal
- Syntax highlighting for code blocks
- Tables, task lists, blockquotes
- Works with Node.js and Bun

## Installation

```bash
npm install -g @kawaz/mdp
```

## Usage

```bash
# Preview a file
mdp README.md

# Pipe from stdin
cat README.md | mdp

# With curl
curl -s https://raw.githubusercontent.com/kawaz/mdp/main/README.md | mdp
```

## Example Output

```
# Heading                    ← magenta + bold
## Subheading                ← blue + bold

This is **bold** and *italic* text.

  • Bullet point             ← yellow marker
  ☑ Completed task           ← green checkbox
  ☐ Pending task             ← gray checkbox

┌─ javascript ─────────────┐
│ const x = 1;             │  ← cyan code
└──────────────────────────┘

│ A blockquote             ← italic

| Name | Value |            ← table with borders
├──────┼───────┤
| foo  | 123   |
```

## Performance

| Runtime | Startup |
|---------|---------|
| Node.js | ~70ms   |
| Bun     | ~27ms   |

## Development

Requires [MoonBit](https://moonbitlang.com) toolchain.

```bash
# Build
just build

# Run locally
just run README.md

# Run with Bun
just run-bun README.md
```

## License

MIT
