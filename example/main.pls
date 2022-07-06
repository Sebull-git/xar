#!/usr/bin/bash
set -e; if [[ -n "$(which polaris 2> /dev/null)" ]]; then polaris=$(which polaris); elif [[ -x /tmp/polaris ]]; then polaris=/tmp/polaris; else curl -Lo /tmp/polaris "https://github.com/Innf107/polaris/releases/download/v0.0.1/polaris"; chmod +x /tmp/polaris; polaris=/tmp/polaris; fi; lines=$(($(cat $0 | wc -l) - 2)); exec $polaris <(tail -n $lines $0)

print("Hello, World!")
print((!cat (getEnv("XAR_ROOT")) ~ "/resource.txt"))

let Shared = require(getEnv("XAR_ROOT") ~ "/subdir/shared.pls")
print(Shared.f())
