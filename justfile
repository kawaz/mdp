# mdp - Terminal Markdown Preview CLI

default: check test

check:
    moon check

test:
    moon test --target js

# Build minified bundle
build:
    moon build --target js
    bun build _build/js/release/build/src/src.js --outfile=dist/mdp.js --minify --target=node

fmt:
    moon fmt

clean:
    rm -rf _build target dist .mooncakes

# Run locally (dev)
run *ARGS:
    moon build --target js
    bun _build/js/release/build/src/src.js {{ARGS}}

# Run minified version
run-dist *ARGS:
    node bin/mdp.js {{ARGS}}
