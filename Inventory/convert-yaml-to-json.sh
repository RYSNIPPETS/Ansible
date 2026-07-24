#!/usr/bin/env bash
set -Eeuo pipefail

# Convert a YAML file (for example an Ansible inventory) to indented JSON. This is a
# hardened rewrite of the original one-line ConvertYaml2Json.sh: it uses yaml.safe_load
# instead of the unsafe FullLoader, reads a file argument or stdin, and writes to stdout.

usage() {
  cat <<'EOF'
Usage: convert-yaml-to-json.sh [FILE]

Convert a YAML document to indented JSON on stdout. Reads FILE when given, otherwise
reads from stdin. Parses with yaml.safe_load.

Examples:
  ./convert-yaml-to-json.sh hosts.sample.yml
  ./convert-yaml-to-json.sh hosts.sample.yml > hosts.json
  cat hosts.yml | ./convert-yaml-to-json.sh
EOF
}

case "${1:-}" in
  -h | --help) usage; exit 0 ;;
esac

command -v python3 >/dev/null 2>&1 || { printf 'ERROR: python3 not found\n' >&2; exit 1; }

# The program is passed with -c (not on stdin), which leaves stdin free for piped YAML.
python3 -c '
import json
import sys

import yaml

path = sys.argv[1] if len(sys.argv) > 1 else None
stream = open(path, encoding="utf-8") if path else sys.stdin
try:
    data = yaml.safe_load(stream)
finally:
    if path is not None:
        stream.close()

json.dump(data, sys.stdout, indent=4, sort_keys=True)
sys.stdout.write("\n")
' "$@"
