# mdp - Terminal Markdown Preview CLI

default: fmt check test build

check:
    moon check --target js

test:
    moon test --target js

# Build minified bundle
build: build-js

build-js: build-mbt
    bun run build

build-mbt:
    moon build --target js --release

fmt:
    moon fmt

clean:
    rm -rf _build target dist .mooncakes

# Run locally (dev)
run *ARGS: build-mbt
    bun _build/js/release/build/src/src.js {{ARGS}}

# Run minified version
run-dist *ARGS: build-mbt
    node bin/mdp.js {{ARGS}}
