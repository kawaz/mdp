# mdp - Terminal Markdown Preview CLI

default: fmt check test

check:
    moon check --target js

test:
    moon test --target js

# Build minified bundle
build:
    bun run build

fmt:
    moon fmt

clean:
    rm -rf _build target dist .mooncakes

# Run locally (dev)
run *ARGS:
    moon build --target js --release
    bun _build/js/release/build/src/src.js {{ARGS}}

# Run minified version
run-dist *ARGS:
    node bin/mdp.js {{ARGS}}
