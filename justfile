# mdp - Terminal Markdown Preview CLI

default: fmt check test build

check:
    moon check --target js

test:
    moon test --target js

# Build minified bundle
build: bundle

build-mbt:
    moon build --target js --release

build-js: build-mbt
    #!/usr/bin/env bash
    set -euo pipefail
    V=$(node -p "require('./package.json').version")
    bun build _build/js/release/build/src/src.js --outfile=dist/mdp.js --minify --target=node --define "__MDP_VERSION__='$V'"

bundle: build-js
    #!/usr/bin/env bash
    set -euo pipefail
    bun build bin/mdp.js --outfile=dist/mdp.bundle.js --minify --target=node
    {
      printf '#!/bin/sh\n'"'"':'"'"' //; b=$(command -v bun) && exec "$b" --bun "$0" "$@"; exec node "$0" "$@"\n'
      tail -n +2 dist/mdp.bundle.js
    } > dist/mdp.bundle.js.tmp
    mv dist/mdp.bundle.js.tmp dist/mdp.bundle.js
    chmod +x dist/mdp.bundle.js

fmt:
    moon fmt

# Sync version from package.json to moon.mod.json
sync-version:
    #!/usr/bin/env bash
    set -euo pipefail
    V=$(jq -r '.version' package.json)
    jq --arg v "$V" '.version = $v' moon.mod.json > moon.mod.json.tmp
    mv moon.mod.json.tmp moon.mod.json
    git add moon.mod.json

clean:
    rm -rf _build target dist .mooncakes

# Run locally (dev)
run *ARGS: build-mbt
    bun _build/js/release/build/src/src.js {{ARGS}}

# Run minified version
run-dist *ARGS: build-js
    node bin/mdp.js {{ARGS}}
