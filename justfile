# mdp - Terminal Markdown Preview CLI

default: check test

# Type check
check:
    moon check

# Run tests
test:
    moon test --target js

# Build for distribution
build:
    moon build --target js
    mkdir -p dist
    cp -r _build/js/release/build/src dist/

# Format code
fmt:
    moon fmt

# Clean build artifacts
clean:
    rm -rf _build target dist .mooncakes

# Run locally
run *ARGS:
    moon build --target js
    node _build/js/release/build/src/src.js {{ARGS}}

# Run with bun (faster)
run-bun *ARGS:
    moon build --target js
    bun _build/js/release/build/src/src.js {{ARGS}}
